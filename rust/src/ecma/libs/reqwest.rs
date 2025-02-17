use lazy_static::lazy_static;
use std::time::Duration;

use boa_engine::{
    js_string, object::ObjectInitializer, property::Attribute, Context, JsArgs, JsError,
    JsNativeError, JsObject, JsResult, JsValue, NativeFunction,
};
use reqwest::{
    header::{HeaderMap, HeaderName},
    Client, Method, Response,
};
use serde_json::Value;

lazy_static! {
    static ref HTTP_CLIENT: Client = create_default_client();
}

// 创建默认的Client配置
fn create_default_client() -> Client {
    Client::builder()
        .danger_accept_invalid_certs(true)
        .use_rustls_tls()
        .timeout(Duration::from_secs(4))
        .build()
        .expect("Failed to create HTTP client")
}

// 请求配置结构体
#[derive(Debug)]
struct RequestConfig {
    headers: HeaderMap,
    body: Option<String>,
    query: Option<String>,
    timeout: Option<Duration>,
    form: Option<Value>,
    json: Option<Value>,
}

impl RequestConfig {
    fn from_js_value(value: &JsValue, ctx: &mut Context) -> JsResult<Self> {
        if !value.is_object() {
            return Err(JsNativeError::typ()
                .with_message("Config must be an object")
                .into());
        }

        let obj = value.as_object().unwrap();
        let mut config = RequestConfig {
            headers: HeaderMap::new(),
            body: None,
            query: None,
            timeout: None,
            form: None,
            json: None,
        };

        // 处理 headers
        let headers_value = obj.get(js_string!("headers"), ctx)?;
        if !headers_value.is_undefined() && !headers_value.is_null() {
            if let Some(headers_obj) = headers_value.as_object() {
                for key in headers_obj.own_property_keys(ctx)? {
                    let key_str = key.to_string();
                    let value = headers_obj.get(key, ctx)?;
                    let value_str = value.to_string(ctx).unwrap().to_std_string().unwrap();

                    if let Ok(header_name) = HeaderName::from_bytes(key_str.as_bytes()) {
                        config
                            .headers
                            .insert(header_name, value_str.parse().unwrap());
                    }
                }
            }
        }

        // 处理 timeout
        let timeout_value = obj.get(js_string!("timeout"), ctx)?;
        if !timeout_value.is_undefined() && !timeout_value.is_null() && timeout_value.is_number() {
            config.timeout = Some(Duration::from_secs(
                timeout_value.as_number().unwrap() as u64
            ));
        }

        // 处理 body
        let body_value = obj.get(js_string!("body"), ctx)?;
        if !body_value.is_undefined() && !body_value.is_null() {
            config.body = body_value.to_string(ctx).unwrap().to_std_string().ok();
        }

        // 处理 json
        let json_value = obj.get(js_string!("json"), ctx)?;
        if !json_value.is_undefined() && !json_value.is_null() {
            config.json = json_value.to_json(ctx).ok();
        }

        // 处理 form
        let form_value = obj.get(js_string!("form"), ctx)?;
        if !form_value.is_undefined() && !form_value.is_null() {
            config.form = form_value.to_json(ctx).ok();
        }

        // 处理 query string
        let query_value = obj.get(js_string!("query"), ctx)?;
        if !query_value.is_undefined() && !query_value.is_null() {
            config.query = query_value.to_string(ctx).unwrap().to_std_string().ok();
        }

        Ok(config)
    }
}

// 创建Headers对象
fn create_headers_object(headers: &HeaderMap, ctx: &mut Context) -> JsResult<JsObject> {
    let headers_obj = ObjectInitializer::new(ctx).build();

    for (name, value) in headers.iter() {
        if let Ok(value_str) = value.to_str() {
            headers_obj.set(js_string!(name.as_str()), js_string!(value_str), true, ctx)?;
        }
    }

    Ok(headers_obj)
}

// 创建Response对象
async fn create_response_object(response: Response, ctx: &mut Context) -> JsResult<JsObject> {
    let response_obj = ObjectInitializer::new(ctx).build();

    // 设置基本属性
    response_obj.set(js_string!("ok"), response.status().is_success(), true, ctx)?;
    response_obj.set(js_string!("status"), response.status().as_u16(), true, ctx)?;
    response_obj.set(
        js_string!("statusText"),
        js_string!(response.status().canonical_reason().unwrap_or("")),
        true,
        ctx,
    )?;
    response_obj.set(js_string!("type"), js_string!("default"), true, ctx)?;

    // 设置headers
    let headers_obj = create_headers_object(response.headers(), ctx)?;
    response_obj.set(js_string!("headers"), headers_obj, true, ctx)?;

    // 设置body相关方法
    let body_text = response.text().await.unwrap_or_default();

    response_obj.set(
        js_string!("body"),
        JsValue::new(js_string!(body_text)),
        true,
        ctx,
    )?;

    Ok(response_obj)
}

// 统一的请求处理函数
async fn make_request(
    method: Method,
    url: String,
    config: RequestConfig,
) -> Result<Response, Box<dyn std::error::Error>> {
    let mut request_builder = HTTP_CLIENT.request(method, url);

    // 应用配置
    if !config.headers.is_empty() {
        request_builder = request_builder.headers(config.headers);
    }

    if let Some(query) = config.query {
        request_builder = request_builder.query(&query);
    }

    if let Some(json) = config.json {
        request_builder = request_builder.json(&json);
    } else if let Some(form) = config.form {
        request_builder = request_builder.form(&form);
    } else if let Some(body) = config.body {
        request_builder = request_builder.body(body);
    }

    Ok(request_builder.send().await?)
}

// JS包装函数
fn handle_request(method: Method, args: &[JsValue], ctx: &mut Context) -> JsResult<JsValue> {
    let url = args
        .get_or_undefined(0)
        .to_string(ctx)?
        .to_std_string()
        .map_err(|e| JsError::from_opaque(js_string!(format!("Invalid URL: {}", e)).into()))?;

    let config = if let Some(config_arg) = args.get(1) {
        RequestConfig::from_js_value(config_arg, ctx)?
    } else {
        RequestConfig {
            headers: HeaderMap::new(),
            body: None,
            query: None,
            timeout: None,
            form: None,
            json: None,
        }
    };

    let response = tokio::task::block_in_place(|| {
        tokio::runtime::Handle::current().block_on(async {
            make_request(method, url, config).await.map_err(|e| {
                JsError::from_opaque(js_string!(format!("Request failed: {}", e)).into())
            })
        })
    })?;

    let response_obj = tokio::task::block_in_place(|| {
        tokio::runtime::Handle::current().block_on(async {
            create_response_object(response, ctx).await.map_err(|e| {
                JsError::from_opaque(
                    js_string!(format!("Failed to create response object: {}", e)).into(),
                )
            })
        })
    })?;

    Ok(response_obj.into())
}

// HTTP方法包装函数
fn rq_get(_: &JsValue, args: &[JsValue], ctx: &mut Context) -> JsResult<JsValue> {
    handle_request(Method::GET, args, ctx)
}

fn rq_post(_: &JsValue, args: &[JsValue], ctx: &mut Context) -> JsResult<JsValue> {
    handle_request(Method::POST, args, ctx)
}

fn rq_put(_: &JsValue, args: &[JsValue], ctx: &mut Context) -> JsResult<JsValue> {
    handle_request(Method::PUT, args, ctx)
}

fn rq_delete(_: &JsValue, args: &[JsValue], ctx: &mut Context) -> JsResult<JsValue> {
    handle_request(Method::DELETE, args, ctx)
}

// 注册全局函数
pub fn define_rq(ctx: &mut Context) {
    let rq = ObjectInitializer::new(ctx)
        .function(NativeFunction::from_fn_ptr(rq_get), js_string!("get"), 2)
        .function(NativeFunction::from_fn_ptr(rq_post), js_string!("post"), 2)
        .function(NativeFunction::from_fn_ptr(rq_put), js_string!("put"), 2)
        .function(
            NativeFunction::from_fn_ptr(rq_delete),
            js_string!("delete"),
            2,
        )
        .build();

    ctx.register_global_property(js_string!("rq"), rq, Attribute::all())
        .expect("the rq builtin shouldn't exist");
}

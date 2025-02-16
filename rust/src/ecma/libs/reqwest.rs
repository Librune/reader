use std::time::Duration;

use boa_engine::{
    js_string, object::ObjectInitializer, property::Attribute, Context, JsArgs, JsError,
    JsNativeError, JsResult, JsValue, NativeFunction,
};
use reqwest::header::{HeaderMap, HeaderName};
use serde_json::Value;

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
        if !timeout_value.is_undefined() && !timeout_value.is_null() {
            if timeout_value.is_number() {
                config.timeout = Some(Duration::from_secs(
                    timeout_value.as_number().unwrap() as u64
                ));
            }
        }

        // 处理 body
        let body_value = obj.get(js_string!("body"), ctx)?;
        if !body_value.is_undefined() && !body_value.is_null() {
            config.body = Some(body_value.to_string(ctx).unwrap().to_std_string().unwrap());
        }

        // 处理 json
        let json_value = obj.get(js_string!("json"), ctx)?;
        if !json_value.is_undefined() && !json_value.is_null() {
            let json_str = json_value.to_string(ctx).unwrap().to_std_string().unwrap();
            config.json = Some(serde_json::from_str(&json_str).map_err(|e| {
                JsError::from_opaque(js_string!(format!("Invalid JSON: {}", e)).into())
            })?);
        }

        // 处理 form
        let form_value = obj.get(js_string!("form"), ctx)?;
        let json = form_value.to_json(ctx).unwrap();
        config.form = Some(json);
        // if !form_value.is_undefined() && !form_value.is_null() {
        //     if let Some(form_obj) = form_value.as_object() {
        //         let form_str = form_obj.tojson(ctx)?;
        //         config.form = Some(serde_json::from_str(&form_str).map_err(|e| {
        //             JsError::from_opaque(js_string!(format!("Invalid form data: {}", e)).into())
        //         })?);
        //     }
        // }

        // 处理 query string
        let query_value = obj.get(js_string!("query"), ctx)?;
        if !query_value.is_undefined() && !query_value.is_null() {
            config.query = Some(query_value.to_string(ctx).unwrap().to_std_string().unwrap());
        }

        Ok(config)
    }
}

fn rq_get(_this: &JsValue, args: &[JsValue], ctx: &mut Context) -> JsResult<JsValue> {
    let url = args
        .get_or_undefined(0)
        .to_string(ctx)
        .unwrap()
        .to_std_string()
        .unwrap();

    let client = reqwest::Client::builder()
        .danger_accept_invalid_certs(true)
        .use_rustls_tls()
        .timeout(Duration::from_secs(4))
        .build()
        .unwrap();

    let result = tokio::task::block_in_place(|| {
        // 此处我们在允许阻塞的线程中调用 block_on
        tokio::runtime::Handle::current().block_on(async {
            let response = client.get(url).send().await.unwrap();
            let status = response.status();
            println!("rust response status: {}", status);
            Ok(JsValue::new(js_string!(status.to_string())))
        })
    });
    result
}

fn rq_post(_this: &JsValue, args: &[JsValue], ctx: &mut Context) -> JsResult<JsValue> {
    let url = args
        .get_or_undefined(0)
        .to_string(ctx)
        .unwrap()
        .to_std_string()
        .unwrap();
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

    let client = reqwest::Client::builder()
        .danger_accept_invalid_certs(true)
        .use_rustls_tls()
        .default_headers(config.headers)
        .timeout(Duration::from_secs(4))
        .build()
        .unwrap();

    let result = tokio::task::block_in_place(|| {
        tokio::runtime::Handle::current().block_on(async {
            let mut request_builder = client.post(&url);

            // 添加查询参数
            if let Some(query) = config.query {
                request_builder = request_builder.query(&query);
            }

            // 设置请求体
            if let Some(json) = config.json {
                request_builder = request_builder.json(&json);
            } else if let Some(form) = config.form {
                request_builder = request_builder.form(&form);
            } else if let Some(body) = config.body {
                request_builder = request_builder.body(body);
            }
            let response = request_builder.send().await.map_err(|e| {
                JsError::from_opaque(js_string!(format!("Request failed: {}", e)).into())
            })?;
            let body = response.text().await.unwrap();
            Ok(JsValue::new(js_string!(body)))
        })
    });
    result
}

pub fn define_rq(ctx: &mut Context) {
    let rq = ObjectInitializer::new(ctx)
        .function(NativeFunction::from_fn_ptr(rq_get), js_string!("get"), 2)
        .function(NativeFunction::from_fn_ptr(rq_post), js_string!("post"), 2)
        .build();
    ctx.register_global_property(js_string!("rq"), rq, Attribute::all())
        .expect("the rq builtin shouldn't exist")
}

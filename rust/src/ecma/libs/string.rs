use aes_gcm::KeyInit;
use base64::{engine::general_purpose::STANDARD as BASE64, Engine as _};
use boa_engine::{
    js_error, js_string,
    object::FunctionObjectBuilder,
    property::{PropertyDescriptor, PropertyKey},
    Context, JsResult, JsValue, NativeFunction,
};
use hmac::{Hmac, Mac};
use sha2::Sha256;

fn register_to_md5(context: &mut Context) -> JsResult<JsValue> {
    let string_proto = context.intrinsics().constructors().string().prototype();
    let function = FunctionObjectBuilder::new(
        context.realm(),
        NativeFunction::from_fn_ptr(|this, _args, context| {
            // 将调用对象转换为字符串
            let this_str = this.to_string(context)?;
            // 使用 md5 包计算 MD5 值，并格式化为 16 进制字符串
            let digest = format!("{:x}", md5::compute(this_str.to_std_string_escaped()));
            Ok(JsValue::String(digest.into()))
        }),
    )
    .build();
    string_proto
        .define_property_or_throw(
            PropertyKey::from(js_string!("toMd5")),
            PropertyDescriptor::builder()
                .value(function)
                .writable(true)
                .enumerable(false)
                .configurable(true),
            context,
        )
        .expect("Failed to define property");
    Ok(JsValue::undefined())
}

fn register_to_base64(context: &mut Context) -> JsResult<JsValue> {
    let string_proto = context.intrinsics().constructors().string().prototype();
    let function = FunctionObjectBuilder::new(
        context.realm(),
        NativeFunction::from_fn_ptr(|this, _args, context| {
            // 将调用对象转换为字符串
            let this_str = this.to_string(context)?.to_std_string_escaped();
            // 使用 base64 编码
            let result = BASE64.encode(this_str.as_bytes());
            Ok(JsValue::String(result.into()))
        }),
    )
    .build();
    string_proto
        .define_property_or_throw(
            PropertyKey::from(js_string!("toBase64")),
            PropertyDescriptor::builder()
                .value(function)
                .writable(true)
                .enumerable(false)
                .configurable(true),
            context,
        )
        .expect("Failed to define property");
    Ok(JsValue::undefined())
}

fn register_to_hmac_sha256_base64(context: &mut Context) -> JsResult<JsValue> {
    let string_proto = context.intrinsics().constructors().string().prototype();
    let function = FunctionObjectBuilder::new(
        context.realm(),
        NativeFunction::from_fn_ptr(|this, _args, context| {
            // 将调用对象转换为字符串
            let this_str = this.to_string(context)?.to_std_string_escaped();
            match _args.get(0) {
                Some(key) => {
                    let key_str = key.to_string(context).unwrap().to_std_string_escaped();
                    match <Hmac<Sha256> as KeyInit>::new_from_slice(key_str.as_bytes()) {
                        Ok(mut mac) => {
                            Mac::update(&mut mac, this_str.as_bytes());
                            let result = mac.finalize().into_bytes();
                            Ok(JsValue::String(BASE64.encode(result).into()))
                        }
                        Err(_) => Err(js_error!("Failed to create HMAC-SHA256")),
                    }
                }
                None => {
                    return Err(js_error!("Secret key is required for HMAC-SHA256"));
                }
            }
        }),
    )
    .build();
    string_proto
        .define_property_or_throw(
            PropertyKey::from(js_string!("toHmacSha256Base64")),
            PropertyDescriptor::builder()
                .value(function)
                .writable(true)
                .enumerable(false)
                .configurable(true),
            context,
        )
        .expect("Failed to define property");
    Ok(JsValue::undefined())
}

pub fn extend_string(context: &mut Context) {
    register_to_md5(context).expect("Failed to register toMd5");
    register_to_base64(context).expect("Failed to register toBase64");
    register_to_hmac_sha256_base64(context).expect("Failed to register toHmacSha256Base64");
}

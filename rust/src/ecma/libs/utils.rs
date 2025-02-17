use std::io::Error;

use boa_engine::{js_error, js_string, Context, JsArgs, JsValue, NativeFunction, Source};
use uuid::Uuid;

fn add_uuid(context: &mut Context) {
    let function = NativeFunction::from_fn_ptr(|_this, _args, _context| {
        let uuid = Uuid::new_v4();
        Ok(JsValue::String(js_string!(uuid.to_string())))
    });
    context
        .register_global_builtin_callable(js_string!("uuid"), 0, function)
        .expect("Failed to register uuid");
}

fn set_storage(context: &mut Context) -> Result<(), Error> {
    let function = NativeFunction::from_fn_ptr(|_this, args, context| {
        let key = args.get_or_undefined(0);
        let value = args.get_or_undefined(1);
        if key.is_undefined() || value.is_undefined() {
            return Err(js_error!("key or value is undefined"));
        }
        let uuid = context.eval(Source::from_bytes("id".as_bytes())).unwrap();
        let uuid_str = uuid.to_string(context).unwrap().to_std_string_escaped();
        let key_str = key.to_string(context).unwrap().to_std_string_escaped();
        let value_str = value.to_string(context).unwrap().to_std_string_escaped();
        println!("setStorage: {} {} {}", uuid_str, key_str, value_str);
        Ok(JsValue::undefined())
    });
    context
        .register_global_builtin_callable(js_string!("setStorage"), 2, function)
        .expect("Failed to register setStorage");
    Ok(())
}

fn get_storage(context: &mut Context) -> Result<(), Error> {
    let function = NativeFunction::from_fn_ptr(|_this, args, context| {
        let key = args.get_or_undefined(0);
        if key.is_undefined() {
            return Err(js_error!("key is undefined"));
        }
        let uuid = context.eval(Source::from_bytes("id".as_bytes())).unwrap();
        let uuid_str = uuid.to_string(context).unwrap().to_std_string_escaped();
        let key_str = key.to_string(context).unwrap().to_std_string_escaped();
        println!("getStorage: {} {}", uuid_str, key_str);
        Ok(JsValue::undefined())
    });
    context
        .register_global_builtin_callable(js_string!("getStorage"), 1, function)
        .expect("Failed to register getStorage");
    Ok(())
}

pub fn define_utils(context: &mut Context) {
    add_uuid(context);
    set_storage(context).expect("Failed to register setStorage");
    get_storage(context).expect("Failed to register getStorage");
}

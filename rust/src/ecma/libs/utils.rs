use boa_engine::{js_string, Context, JsValue, NativeFunction};
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

pub fn define_utils(context: &mut Context) {
    add_uuid(context);
}

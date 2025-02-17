use std::io::Error;

use boa_engine::{
    js_string,
    object::FunctionObjectBuilder,
    property::{PropertyDescriptor, PropertyKey},
    Context, JsString, JsValue, NativeFunction,
};

fn register_to_query(context: &mut Context) -> Result<(), Error> {
    let object_proto = context.intrinsics().constructors().object().prototype();
    let function = FunctionObjectBuilder::new(
        context.realm(),
        NativeFunction::from_fn_ptr(|this, _args, context| {
            let this_obj = this.to_object(context)?;
            let mut result = String::new();
            let keys = this_obj.own_property_keys(context)?;
            keys.iter().for_each(|key| {
                let key_str = key.to_string();
                let value = this_obj
                    .get::<JsString>(js_string!(key_str.clone()), context)
                    .unwrap();
                let value_str = value.to_string(context).unwrap();
                result.push_str(&format!(
                    "{}={}&",
                    key_str,
                    value_str.to_std_string_escaped()
                ));
            });
            result.pop();
            Ok(JsValue::String(js_string!(result)))
        }),
    )
    .build();
    object_proto.define_property_or_throw(
        PropertyKey::from(js_string!("toQuery")),
        PropertyDescriptor::builder()
            .value(function)
            .writable(true)
            .enumerable(false)
            .configurable(true),
        context,
    );
    Ok(())
}

pub fn extend_object(context: &mut Context) {
    register_to_query(context).expect("Failed to register toQuery");
}

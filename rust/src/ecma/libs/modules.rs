use std::collections::HashMap;

use boa_engine::{js_string, Context, JsArgs, JsError, JsResult, JsValue, NativeFunction, Source};
use once_cell::sync::Lazy;

const DAY_JS: &str = include_str!("../scripts/dayjs.js");
const CRYPTO_JS: &str = include_str!("../scripts/crypto-js.js");
const FXPARSER: &str = include_str!("../scripts/fxparser.js");
const UUID: &str = include_str!("../scripts/uuid.js");

static MODULES: Lazy<HashMap<&'static str, &'static str>> = Lazy::new(|| {
    let mut m = HashMap::new();
    m.insert("dayjs", DAY_JS);
    m.insert("crypto-js", CRYPTO_JS);
    m.insert("fxparser", FXPARSER);
    m.insert("uuid", UUID);
    m
});

pub fn load_module(name: &str, context: &mut Context) -> JsResult<JsValue> {
    if let Some(source) = MODULES.get(name) {
        context.eval(Source::from_bytes(source.as_bytes()))
    } else {
        return Err(JsError::from_opaque(js_string!("Module not found").into()));
    }
}

pub fn load_es_module(name: &str, context: &mut Context) -> JsResult<boa_engine::Module> {
    if let Some(source) = MODULES.get(name) {
        boa_engine::Module::parse(Source::from_bytes(source.as_bytes()), None, context)
    } else {
        Err(boa_engine::JsError::from_opaque(
            js_string!("Module not found").into(),
        ))
    }
}

fn require(_: &JsValue, args: &[JsValue], context: &mut Context) -> JsResult<JsValue> {
    let name = args
        .get_or_undefined(0)
        .to_string(context)
        .unwrap()
        .to_std_string()
        .unwrap();
    load_module(name.as_str(), context)
}

pub fn define_require(context: &mut Context) {
    context
        .register_global_builtin_callable(
            js_string!("require"),
            1,
            NativeFunction::from_fn_ptr(require),
        )
        .expect("the console builtin shouldn't exist");
}

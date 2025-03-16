use std::collections::HashMap;

use flutter_rust_bridge::frb;

use crate::ecma::{
    entry::EcmaEngine,
    manager::{get_ecma_script, insert_ecma_script, remove_ecma_script},
};

#[frb(sync)]
pub fn js_eval(code: String) -> Result<String, String> {
    let mut engine = EcmaEngine::new();
    engine.eval(code)
}

#[frb]
pub fn js_eval_async(code: String) -> Result<String, String> {
    let mut engine = EcmaEngine::new();
    engine.eval(code)
}

#[frb]
pub fn js_eval_auto(code: String) -> Result<String, String> {
    let mut engine = EcmaEngine::new();
    engine.eval_async(code)
}

#[frb]
pub fn js_action(uuid: String, method: String, args: String) -> Result<String, String> {
    let mut engine = EcmaEngine::new();
    let code = get_ecma_script(&uuid).unwrap();
    engine.action(code, method, args)
}

#[frb(sync)]
pub fn js_get_attribute(uuid: String, key: String) -> Result<String, String> {
    let mut engine = EcmaEngine::new();
    let code = get_ecma_script(&uuid).unwrap();
    engine.get_attribute(code, key)
}

#[frb(sync)]
pub fn js_get_attributes(
    uuid: String,
    keys: Vec<String>,
) -> Result<HashMap<String, String>, String> {
    let mut engine = EcmaEngine::new();
    let code = get_ecma_script(&uuid).unwrap();
    engine.get_attributes(code, keys)
}

#[frb(sync)]
pub fn js_get_attributes_from_code(
    code: String,
    keys: Vec<String>,
) -> Result<HashMap<String, String>, String> {
    let mut engine = EcmaEngine::new();
    engine.get_attributes(code, keys)
}

#[frb(sync)]
pub fn init_js_scripts(scripts: HashMap<String, String>) {
    for (key, value) in scripts {
        insert_ecma_script(key, value);
    }
}

#[frb(sync)]
pub fn insert_js_script(uuid: String, code: String) {
    insert_ecma_script(uuid, code);
}

#[frb(sync)]
pub fn remove_js_script(uuid: String) {
    remove_ecma_script(&uuid);
}

#[frb(sync)]
pub fn get_uuid(code: String) -> String {
    let mut engine = EcmaEngine::new();
    if let Err(_) = engine.eval(code) {
        return uuid::Uuid::new_v4().to_string();
    }
    match engine.eval("id".to_string()) {
        Ok(value) => uuid::Uuid::parse_str(&value)
            .unwrap_or_else(|_| uuid::Uuid::new_v4())
            .to_string(),
        Err(_) => uuid::Uuid::new_v4().to_string(),
    }
}

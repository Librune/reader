use once_cell::sync::Lazy;
use std::collections::HashMap;
use std::sync::Mutex;

use crate::api::envs::get_env;

static ECMA_SCRIPTS: Lazy<Mutex<HashMap<String, String>>> =
    Lazy::new(|| Mutex::new(HashMap::new()));

// 辅助函数
pub fn insert_ecma_script(key: String, value: String) {
    let mut map = ECMA_SCRIPTS.lock().unwrap();
    map.insert(key, value);
}

pub fn get_ecma_script(key: &str) -> Option<String> {
    let map = ECMA_SCRIPTS.lock().unwrap();
    let code = map.get(key).cloned();
    let envs = get_env(key.to_string());
    code.map(|code| {
        let code = code.clone();
        format!(
            "const __ENVS__ = {};\n{}",
            serde_json::to_string(&envs).unwrap(),
            code
        )
    })
}

pub fn remove_ecma_script(key: &str) -> Option<String> {
    let mut map = ECMA_SCRIPTS.lock().unwrap();
    map.remove(key)
}

pub fn clear_ecma_script() {
    let mut map = ECMA_SCRIPTS.lock().unwrap();
    map.clear();
}

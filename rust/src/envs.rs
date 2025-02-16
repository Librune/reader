use once_cell::sync::Lazy;
use std::collections::HashMap;
use std::sync::Mutex;

static ENVS: Lazy<Mutex<HashMap<String, HashMap<String, String>>>> =
    Lazy::new(|| Mutex::new(HashMap::new()));

// 辅助函数
pub fn insert_env(key: String, value: HashMap<String, String>) {
    let mut map = ENVS.lock().unwrap();
    map.insert(key, value);
}

pub fn get_env(key: &str) -> Option<HashMap<String, String>> {
    let map = ENVS.lock().unwrap();
    map.get(key).cloned()
}

pub fn remove_env(key: &str) -> Option<HashMap<String, String>> {
    let mut map = ENVS.lock().unwrap();
    map.remove(key)
}

pub fn clear_env() {
    let mut map = ENVS.lock().unwrap();
    map.clear();
}

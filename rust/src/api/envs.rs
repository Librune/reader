use std::collections::HashMap;

use flutter_rust_bridge::frb;

use crate::envs;

#[frb(sync)]
pub fn get_env(uuid: String) -> HashMap<String, String> {
    envs::get_env(&uuid).unwrap_or_else(|| HashMap::new())
}

#[frb(sync)]
pub fn set_env(uuid: String, value: HashMap<String, String>) {
    envs::insert_env(uuid, value);
}

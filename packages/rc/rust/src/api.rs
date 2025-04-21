pub use boa_engine::{JsResult, JsValue};
pub use book_core::BookCore;
pub use serde_json::Value;
use flutter_rust_bridge::frb;

#[frb]
pub fn hello_world()  { 
    println!("Hello, world!");
}

#[frb]
pub fn init_book_core(code:String)->BookCore  { 
    BookCore::init(code)
}

#[frb(external)]
impl BookCore {
    pub fn init(code: String) -> Self {}
    pub fn eval(&mut self, code: String) -> Result<String, String> {}
    pub fn call_func(&mut self, func: String, args: Vec<Value>) -> JsResult<JsValue> {}
    pub fn set_envs(&mut self, envs: Value) -> Result<(), String> {}
    pub fn set_env(&mut self, key: String, value: Value) -> Result<(), String> {}
    pub fn get_envs(&mut self) -> Result<Value, String> {}
    pub fn get_env(&mut self, key: String) -> Result<Value, String> {}
    pub fn clear_envs(&mut self) {}
    pub fn get_metadata(&mut self) -> Result<String, String> {}
    pub fn get_forms(&mut self) -> Result<String, String> {}
    pub fn get_actions(&mut self) -> Result<String, String> {}
    pub fn run_action(&mut self, action: String) -> Result<String, String> {}
    pub fn search_books(&mut self, keyword: String, page: u8, count: u8) -> Result<Value, String> {}
    pub fn get_book_detail(&mut self, bid: String) -> Result<Value, String> {}
    pub fn get_catalog(&mut self, bid: String) -> Result<Value, String> {}
    pub fn get_chapter(&mut self, bid: String, cid: String) -> Result<Value, String> {}
}
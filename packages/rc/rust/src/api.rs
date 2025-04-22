use book_core::BookCore;
use flutter_rust_bridge::frb;
pub use serde_json::Value;


#[frb]
pub fn hello_world()  { 
    println!("Hello, world!");
}

// #[frb]
// pub fn init_book_core(code:String)->BookCore  { 
//     BookCore::init(code)
// }

#[frb]
pub fn get_code_metadata(code:String)->Result<String, String>  { 
    let mut core = BookCore::init(code);
    core.get_metadata()
}

#[frb]
pub fn run_core_action(code:String,action:String,envs:Value)->Result<Value, String>  { 
    let mut core = BookCore::init(code);
    core.set_envs(envs)?;
    core.run_action(action)?;
    core.get_envs()
}

#[frb]
pub fn core_search_books(code:String,keyword: String, page: u8, count: u8)->Result<Value, String>  { 
    let mut core = BookCore::init(code);
    core.search_books(
        keyword,
        page,
        count
    )
}

#[frb]
pub fn core_book_detail(code:String,bid: String) -> Result<Value, String> {
    let mut core = BookCore::init(code);
    core.get_book_detail(bid)
}

#[frb]
pub fn core_catalog(code:String,bid: String) -> Result<Value, String> {
    let mut core = BookCore::init(code);
    core.get_catalog(bid)
}

#[frb]
pub fn core_chapter(code:String,bid: String,cid: String) -> Result<Value, String> {
    let mut core = BookCore::init(code);
    core.get_chapter(bid, cid)
}


// #[frb(external)]
// impl BookCore {
//     pub fn init(code: String) -> Self {}
//     pub fn eval(&mut self, code: String) -> Result<String, String> {}
//     pub fn call_func(&mut self, func: String, args: Vec<Value>) -> JsResult<JsValue> {}
//     pub fn set_envs(&mut self, envs: Value) -> Result<(), String> {}
//     pub fn set_env(&mut self, key: String, value: Value) -> Result<(), String> {}
//     pub fn get_envs(&mut self) -> Result<Value, String> {}
//     pub fn get_env(&mut self, key: String) -> Result<Value, String> {}
//     pub fn clear_envs(&mut self) {}
//     pub fn get_metadata(&mut self) -> Result<String, String> {}
//     pub fn get_forms(&mut self) -> Result<String, String> {}
//     pub fn get_actions(&mut self) -> Result<String, String> {}
//     pub fn run_action(&mut self, action: String) -> Result<String, String> {}
//     pub fn search_books(&mut self, keyword: String, page: u8, count: u8) -> Result<Value, String> {}
//     pub fn get_book_detail(&mut self, bid: String) -> Result<Value, String> {}
//     pub fn get_catalog(&mut self, bid: String) -> Result<Value, String> {}
//     pub fn get_chapter(&mut self, bid: String, cid: String) -> Result<Value, String> {}
// }
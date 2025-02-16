use std::collections::HashMap;

use boa_engine::{Context, Source};
use tokio::runtime::Runtime;

use crate::ecma::libs::runtime::add_runtime;

pub struct EcmaEngine {
    pub context: Context,
}

impl EcmaEngine {
    pub fn new() -> Self {
        let mut engine = Self {
            context: Context::default(),
        };
        println!("EcmaEngine::new()");
        add_runtime(&mut engine.context);
        engine
    }

    pub fn eval(&mut self, code: String) -> Result<String, String> {
        let rt = Runtime::new().unwrap();
        rt.block_on(async {
            self.context
                .eval(Source::from_bytes(code.as_bytes()))
                .map(|value| {
                    value
                        .to_string(&mut self.context)
                        .unwrap()
                        .to_std_string_escaped()
                })
                .map_err(|err| err.to_string())
        })
    }

    pub fn eval_async(&mut self, code: String) -> Result<String, String> {
        let context = &mut self.context;
        let eval: boa_engine::JsValue = context.eval(Source::from_bytes(code.as_bytes())).unwrap();
        let rt = Runtime::new().unwrap();
        if eval.is_promise() {
            let future = eval.as_promise().unwrap();
            rt.block_on(async {
                future
                    .await_blocking(context)
                    .map(|value| value.to_string(context).unwrap().to_std_string_escaped())
                    .map_err(|err| err.to_string(context).unwrap().to_std_string_escaped())
            })
        } else {
            // 新线程执行 eval
            self.eval(code)
        }
    }

    pub fn action(&mut self, code: String, method: String, args: String) -> Result<String, String> {
        self.eval(code)?;

        // let context = &mut self.context;
        // let global = context.global_object();
        // context.eval(Source::from_bytes("demo()")).unwrap();
        let _code = format!("{}({})", method, args);
        self.eval(_code)
        // self.eval("demo()".to_string())?;
        // Ok("".to_string())
        // let func = global.get(PropertyKey::from(js_string!(method)), context);
        // let js_args = JsValue::from_json(&serde_json::from_str(&args).unwrap(), context).unwrap();
        // func.unwrap()
        //     .as_callable()
        //     .unwrap()
        //     .call(&JsValue::undefined(), &[js_args], context)
        //     .map(|value| value.to_string(context).unwrap().to_std_string_escaped())
        //     .map_err(|err| err.to_string())
    }

    pub fn get_attribute(&mut self, code: String, key: String) -> Result<String, String> {
        self.eval(code)?;
        let _code = format!("JSON.stringify({})", key);
        self.eval(_code)
        // let context = &mut self.context;
        // let global = context.global_object();
        // let func = global.get(PropertyKey::from(js_string!(key)), context);
        // func.unwrap()
        //     .to_string(context)
        //     .map(|value| value.to_std_string_escaped())
        //     .map_err(|err| err.to_string())
    }

    pub fn get_attributes(
        &mut self,
        code: String,
        keys: Vec<String>,
    ) -> Result<HashMap<String, String>, String> {
        self.eval(code)?;
        let mut result = HashMap::new();
        for key in keys {
            let _code = format!("JSON.stringify({})", key);
            let value = self.eval(_code)?;
            result.insert(key, value);
        }
        Ok(result)
    }
}

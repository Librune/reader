use anyhow::Result;
use flutter_rust_bridge::frb;

use std::time::Duration;
use tokio::time::sleep;

// use crate::ecma::instance::run_async;

#[flutter_rust_bridge::frb(sync)] // Synchronous mode for simplicity of the demo
pub fn greet(name: String) -> String {
    format!("Hello, {name}!")
}



#[frb(sync)] // Synchronous mode for simplicity of the demo
pub fn add(num1: i8, num2: i8) -> i8 {
    num1 + num2
}

#[frb] // （如果你使用了 #[frb] 宏来标记需要暴露的模块，这里可以加上）
pub async fn async_greeting(name: String) -> Result<String, String> {
    // 模拟耗时操作
    sleep(Duration::from_secs(1)).await;
    Ok(format!("Hello, {}!", name))
}

#[frb]
pub async fn fetch_baidu() -> Result<String, String> {
    let client = reqwest::Client::builder()
        .danger_accept_invalid_certs(true)
        .build()
        .map_err(|e| format!("创建客户端失败: {}", e))?;

    // 发起 GET 请求
    let response = client
        .get("https://www.baidu.com")
        .send()
        .await
        .map_err(|e| format!("请求失败: {}", e))?;

    // 将响应体转换为字符串
    let body = response
        .text()
        .await
        .map_err(|e| format!("读取响应体失败: {}", e))?;

    Ok(body)
}

// #[frb]
// pub async fn js_run_async(code: String) -> Result<String, String> {
//     run_async(code).await
// }

// #[frb]
// pub async fn async_js(code: String) -> Result<String, String> {
//     let mut ctx = Context::default();

//     // 创建 console 对象
//     // let console = JsObject::default();

//     // 将 console.log 函数注册为 console 对象的一个方法
//     let log_fn = NativeFunction::from_fn_ptr(console_log);
//     // console.insert_property(JsString::from("log"), log_fn.into());
//     // // 将 console 对象注册为全局属性
//     // ctx.register_global_property(
//     //     JsString::from("console"),
//     //     console.into(),
//     //     boa_engine::property::Attribute::all(),
//     // );

//     let console = ObjectInitializer::new(&mut ctx)
//         .function(log_fn, JsString::from("log"), 0)
//         .build();

//     ctx.register_global_property(JsString::from("console"), console, Attribute::all());

//     let promise = ctx.eval(Source::from_bytes(&code)).unwrap();
//     let future = promise.as_promise().unwrap();
//     let res = future
//         .await_blocking(&mut ctx)
//         .map(|value| value.to_string(&mut ctx).unwrap().to_std_string_escaped())
//         .map_err(|err| err.to_string(&mut ctx).unwrap().to_std_string_escaped());
//     return res;
// }

// fn console_log(_: &JsValue, args: &[JsValue], context: &mut Context) -> JsResult<JsValue> {
//     for (i, arg) in args.iter().enumerate() {
//         if i > 0 {
//             print!(" ");
//         }
//         print!(
//             "{}",
//             arg.to_string(context).unwrap().to_std_string_escaped()
//         );
//     }
//     println!(); // Add a newline at the end
//     io::stdout().flush().expect("Failed to flush stdout");
//     Ok(JsValue::undefined())
// }

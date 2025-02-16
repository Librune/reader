use boa_engine::{
    js_string, object::ObjectInitializer, property::Attribute, Context, JsArgs, JsResult, JsValue,
    NativeFunction,
};
use scraper::{Html, Selector};

pub fn demo(_: &JsValue, args: &[JsValue], context: &mut Context) -> JsResult<JsValue> {
    let html = args
        .get_or_undefined(0)
        .to_string(context)
        .unwrap()
        .to_std_string()
        .unwrap();
    let document = Html::parse_document(html.as_str());
    let selector = Selector::parse("li").unwrap();

    for element in document.select(&selector) {
        println!("Found: {}", element.text().collect::<String>());
    }
    Ok(JsValue::new(js_string!("Hello, World!")))
}

pub fn define_scraper(context: &mut Context) {
    let scraper = ObjectInitializer::new(context)
        .function(NativeFunction::from_fn_ptr(demo), js_string!("demo"), 0)
        .build();
    context
        .register_global_property(js_string!("scraper"), scraper, Attribute::all())
        .unwrap();
}

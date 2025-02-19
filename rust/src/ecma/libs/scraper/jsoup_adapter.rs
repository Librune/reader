use std::collections::HashMap;

use boa_engine::{
    class::{Class, ClassBuilder},
    js_string, Context, JsArgs, JsData, JsNativeError, JsResult, JsValue, NativeFunction,
};
use boa_gc::{Finalize, Trace};
use scraper::Html;

#[derive(Debug, Trace, Finalize, JsData)]
struct JScraper {
    html: String,
    attrs: HashMap<String, String>,
}

impl JScraper {
    fn text(this: &JsValue, _args: &[JsValue], _context: &mut Context) -> JsResult<JsValue> {
        if let Some(object) = this.as_object() {
            if let Some(scraper) = object.downcast_ref::<JScraper>() {
                let document = Html::parse_document(&scraper.html);
                let text = document.root_element().text().collect::<String>();
                return Ok(JsValue::String(text.into()));
            }
        }
        Err(JsNativeError::typ()
            .with_message("Invalid this value")
            .into())
    }
}

impl Class for JScraper {
    const NAME: &'static str = "Scraper";
    const LENGTH: usize = 1;
    fn data_constructor(
        _this: &JsValue,
        args: &[JsValue],
        context: &mut Context,
    ) -> JsResult<Self> {
        let html = args.get_or_undefined(0).to_string(context)?;
        let scraper = JScraper {
            html: html.to_std_string_escaped(),
            attrs: HashMap::new(),
        };
        Ok(scraper)
    }

    fn init(class: &mut ClassBuilder<'_>) -> JsResult<()> {
        class.method(
            js_string!("text"),
            0,
            NativeFunction::from_fn_ptr(Self::text),
        );
        Ok(())
    }
}

pub fn add_scraper(context: &mut Context) {
    context
        .register_global_class::<JScraper>()
        .expect("the JScraper builtin shouldn't exist");
}

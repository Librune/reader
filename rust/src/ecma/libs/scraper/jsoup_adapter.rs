use std::collections::HashMap;

use aes::cipher::generic_array::arr;
use boa_engine::{
    class::{Class, ClassBuilder},
    js_string,
    object::{self, builtins::JsArray, Object, ObjectInitializer},
    Context, JsArgs, JsData, JsNativeError, JsResult, JsValue, NativeFunction, NativeObject,
};
use boa_gc::{Finalize, Trace};
use scraper::{selector, Html, Selector};

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

    fn select(this: &JsValue, _args: &[JsValue], context: &mut Context) -> JsResult<JsValue> {
        let select_str = _args
            .get_or_undefined(0)
            .to_string(context)?
            .to_std_string_escaped();
        let selector = Selector::parse(&select_str)
            .map_err(|e| JsNativeError::typ().with_message(format!("Invalid selector: {}", e)))?;
        if let Some(object) = this.as_object() {
            if let Some(scraper) = object.downcast_ref::<JScraper>() {
                let document = Html::parse_document(&scraper.html);
                let elements = document.select(&selector);
                let array = JsArray::new(context);
                for element in elements {
                    let mut attrs = HashMap::new();
                    for (k, v) in element.value().attrs.iter() {
                        attrs.insert(k.local.to_string(), v.to_string());
                    }
                    let js_element = JScraper {
                        html: element.html(),
                        attrs,
                    };
                    let t = Class::from_data(js_element, context)?;
                    array.push(JsValue::from(t), context)?;
                }
                return Ok(JsValue::new(array));
            }
        }
        return Ok(JsValue::undefined());
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
        class
            .method(
                js_string!("text"),
                0,
                NativeFunction::from_fn_ptr(Self::text),
            )
            .method(
                js_string!("select"),
                1,
                NativeFunction::from_fn_ptr(Self::select),
            );
        Ok(())
    }
}

pub fn add_scraper(context: &mut Context) {
    context
        .register_global_class::<JScraper>()
        .expect("the JScraper builtin shouldn't exist");
}

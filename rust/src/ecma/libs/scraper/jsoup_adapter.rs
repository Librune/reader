use super::scraper_adapter::{JsDocument, JsElement};
use boa_engine::{
    js_error, js_string, object::ObjectInitializer, Context, JsError, JsResult, JsValue,
    NativeFunction,
};

// Document和Element的简单包装
struct JsDocumentWrapper(JsDocument);
struct JsElementWrapper(JsElement);

pub fn init_jsoup(context: &mut Context) -> JsResult<()> {
    // 注册全局parse函数
    context.register_global_builtin_callable(
        js_string!("parseHtml"),
        1,
        NativeFunction::from_fn_ptr(|_, args, context| {
            let html = args
                .get(0)
                .and_then(|v| v.as_string())
                .ok_or_else(|| js_error!("parseHtml requires HTML string"))?;

            let doc = JsDocument::parse(html.to_std_string_escaped().clone());
            let obj = context.object_prototype();

            // 添加select方法
            obj.set_method("select", 1, |_, args, context| {
                let selector = args
                    .get(0)
                    .and_then(|v| v.as_string())
                    .ok_or_else(|| js_error!("Selector string required", context))?;

                match doc.select(&selector) {
                    Ok(elements) => {
                        let array = context.array();
                        for (i, elem) in elements.into_iter().enumerate() {
                            let elem_obj = create_element_object(elem, context)?;
                            array.set_index(i as u32, elem_obj)?;
                        }
                        Ok(array.into())
                    }
                    Err(e) => Err(js_error!("Failed to select elements: {}", e)),
                }
            })?;

            Ok(obj.into())
        }),
    )?;

    Ok(())
}

fn create_element_object(element: JsElement, context: &mut Context) -> JsResult<JsValue> {
    let obj = context.intrinsics().constructors().object().prototype();

    // attr方法
    obj.set_method("attr", 1, move |_, args, context| {
        let name = args
            .get(0)
            .and_then(|v| v.as_string())
            .ok_or_else(|| js_error!("Attribute name required"))?;

        Ok(match element.attr(&name) {
            Some(value) => JsValue::String(value.into()),
            None => JsValue::Null,
        })
    })?;

    // text方法
    obj.set_method("text", 0, move |_, _, _| {
        Ok(JsValue::String(element.text().into()))
    })?;

    // html方法
    obj.set_method("html", 0, move |_, _, _| {
        Ok(JsValue::String(element.html().into()))
    })?;

    // select方法
    obj.set_method("select", 1, move |_, args, context| {
        let selector = args
            .get(0)
            .and_then(|v| v.as_string())
            .ok_or_else(|| js_error!("Selector string required"))?;

        match element.select(&selector) {
            Ok(elements) => {
                let array = context.array();
                for (i, elem) in elements.into_iter().enumerate() {
                    let elem_obj = create_element_object(elem, context)?;
                    array.set_index(i as u32, elem_obj)?;
                }
                Ok(array.into())
            }
            Err(e) => Err(js_error!("Failed to select elements: {}", e)),
        }
    })?;

    Ok(obj.into())
}

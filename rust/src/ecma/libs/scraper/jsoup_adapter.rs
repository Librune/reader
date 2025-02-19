use super::scraper_adapter::{JsDocument, JsElement};
use boa_engine::{
    object::{Object, ObjectInitializer},
    property::Attribute,
    value::ValueContext,
    Context, JsFunction, JsNativeError, JsObject, JsResult, JsValue,
};
use boa_gc::{Finalize, Trace};

// Document包装器
#[derive(Debug, Trace, Finalize)]
pub struct JsDocumentWrapper {
    inner: JsDocument,
}

impl JsDocumentWrapper {
    fn new(html: &str) -> Self {
        Self {
            inner: JsDocument::parse(html),
        }
    }
}

// Element包装器
#[derive(Debug, Trace, Finalize)]
pub struct JsElementWrapper {
    inner: JsElement,
}

impl JsElementWrapper {
    fn new(element: JsElement) -> Self {
        Self { inner: element }
    }
}

pub fn init_jsoup(context: &mut Context) -> JsResult<()> {
    // 创建Document原型对象
    let document_proto = context.object_prototype();

    // Document构造函数
    let document_constructor = JsFunction::new(
        context,
        |_, args, context| {
            let html = args
                .get(0)
                .ok_or_else(|| {
                    JsNativeError::typ().with_message("Document constructor requires HTML string")
                })?
                .to_string(context)?;

            let wrapper = JsDocumentWrapper::new(&html);
            let obj = Object::new(context);
            obj.define_property_or_throw(
                "inner",
                wrapper,
                Attribute::WRITABLE | Attribute::ENUMERABLE,
                context,
            )?;

            Ok(obj.into())
        },
        Some("Document"),
        1,
    )?;

    // Document原型方法
    let document_prototype = document_constructor.prototype(context)?;

    // select方法
    document_prototype.define_native_method(
        "select",
        1,
        |this, args, context| {
            let wrapper = this
                .as_object()
                .and_then(|obj| obj.get_property("inner").ok())
                .and_then(|val| val.as_object())
                .ok_or_else(|| JsNativeError::typ().with_message("Invalid Document instance"))?;

            let selector = args
                .get(0)
                .ok_or_else(|| JsNativeError::typ().with_message("Selector string required"))?
                .to_string(context)?;

            let doc_wrapper: &JsDocumentWrapper = wrapper
                .downcast_ref()
                .ok_or_else(|| JsNativeError::typ().with_message("Invalid Document instance"))?;

            match doc_wrapper.inner.select(&selector) {
                Ok(elements) => {
                    let array = context.construct_array()?;
                    for (i, elem) in elements.into_iter().enumerate() {
                        let element_wrapper = JsElementWrapper::new(elem);
                        let element_obj = create_element_object(element_wrapper, context)?;
                        array.set(i as u32, element_obj.into(), false, context)?;
                    }
                    Ok(array.into())
                }
                Err(e) => Err(JsNativeError::typ().with_message(&e).into()),
            }
        },
        context,
    )?;

    // 注册Document构造函数为全局对象
    context.register_global_property(
        "Document",
        document_constructor.into(),
        Attribute::WRITABLE | Attribute::ENUMERABLE | Attribute::CONFIGURABLE,
    )?;

    // 创建全局parse函数
    let parse_fn = JsFunction::new(
        context,
        |_, args, context| {
            let html = args
                .get(0)
                .ok_or_else(|| JsNativeError::typ().with_message("parseHtml requires HTML string"))?
                .to_string(context)?;

            let wrapper = JsDocumentWrapper::new(&html);
            let obj = Object::new(context);
            obj.define_property_or_throw(
                "inner",
                wrapper,
                Attribute::WRITABLE | Attribute::ENUMERABLE,
                context,
            )?;

            Ok(obj.into())
        },
        Some("parseHtml"),
        1,
    )?;

    // 注册全局parse函数
    context.register_global_property(
        "parseHtml",
        parse_fn.into(),
        Attribute::WRITABLE | Attribute::ENUMERABLE | Attribute::CONFIGURABLE,
    )?;

    Ok(())
}

// 创建Element对象的辅助函数
fn create_element_object(wrapper: JsElementWrapper, context: &mut Context) -> JsResult<JsObject> {
    let obj = Object::new(context);

    // 存储wrapper
    obj.define_property_or_throw(
        "inner",
        wrapper,
        Attribute::WRITABLE | Attribute::ENUMERABLE,
        context,
    )?;

    // attr方法
    obj.define_native_method(
        "attr",
        1,
        |this, args, context| {
            let wrapper = this
                .as_object()
                .and_then(|obj| obj.get_property("inner").ok())
                .and_then(|val| val.as_object())
                .ok_or_else(|| JsNativeError::typ().with_message("Invalid Element instance"))?;

            let name = args
                .get(0)
                .ok_or_else(|| JsNativeError::typ().with_message("Attribute name required"))?
                .to_string(context)?;

            let element_wrapper: &JsElementWrapper = wrapper
                .downcast_ref()
                .ok_or_else(|| JsNativeError::typ().with_message("Invalid Element instance"))?;

            Ok(match element_wrapper.inner.attr(&name) {
                Some(value) => JsValue::from(value),
                None => JsValue::null(),
            })
        },
        context,
    )?;

    // text方法
    obj.define_native_method(
        "text",
        0,
        |this, _args, context| {
            let wrapper = this
                .as_object()
                .and_then(|obj| obj.get_property("inner").ok())
                .and_then(|val| val.as_object())
                .ok_or_else(|| JsNativeError::typ().with_message("Invalid Element instance"))?;

            let element_wrapper: &JsElementWrapper = wrapper
                .downcast_ref()
                .ok_or_else(|| JsNativeError::typ().with_message("Invalid Element instance"))?;

            Ok(JsValue::from(element_wrapper.inner.text()))
        },
        context,
    )?;

    // html方法
    obj.define_native_method(
        "html",
        0,
        |this, _args, context| {
            let wrapper = this
                .as_object()
                .and_then(|obj| obj.get_property("inner").ok())
                .and_then(|val| val.as_object())
                .ok_or_else(|| JsNativeError::typ().with_message("Invalid Element instance"))?;

            let element_wrapper: &JsElementWrapper = wrapper
                .downcast_ref()
                .ok_or_else(|| JsNativeError::typ().with_message("Invalid Element instance"))?;

            Ok(JsValue::from(element_wrapper.inner.html()))
        },
        context,
    )?;

    // select方法
    obj.define_native_method(
        "select",
        1,
        |this, args, context| {
            let wrapper = this
                .as_object()
                .and_then(|obj| obj.get_property("inner").ok())
                .and_then(|val| val.as_object())
                .ok_or_else(|| JsNativeError::typ().with_message("Invalid Element instance"))?;

            let selector = args
                .get(0)
                .ok_or_else(|| JsNativeError::typ().with_message("Selector string required"))?
                .to_string(context)?;

            let element_wrapper: &JsElementWrapper = wrapper
                .downcast_ref()
                .ok_or_else(|| JsNativeError::typ().with_message("Invalid Element instance"))?;

            match element_wrapper.inner.select(&selector) {
                Ok(elements) => {
                    let array = context.construct_array()?;
                    for (i, elem) in elements.into_iter().enumerate() {
                        let element_wrapper = JsElementWrapper::new(elem);
                        let element_obj = create_element_object(element_wrapper, context)?;
                        array.set(i as u32, element_obj.into(), false, context)?;
                    }
                    Ok(array.into())
                }
                Err(e) => Err(JsNativeError::typ().with_message(&e).into()),
            }
        },
        context,
    )?;

    Ok(obj)
}

// 修正后的核心解析模块 scraper_adapter.rs
use scraper::{ElementRef, Html, Selector};
use std::collections::HashMap;

#[derive(Debug, Clone)]
pub struct JsElement {
    element: ElementRef<'static>, // 保持 static 生命周期标记
    attrs: HashMap<String, String>,
}

impl JsElement {
    pub fn new(element: ElementRef<'_>) -> Self {
        // 正确的属性获取方式
        let attrs = element
            .value()
            .attrs
            .iter()
            .map(|(k, v)| (k.local.to_string(), v.to_string()))
            .collect();

        // 安全转换生命周期（需要配合文档生命周期管理）
        let element =
            unsafe { std::mem::transmute::<ElementRef<'_>, ElementRef<'static>>(element) };

        Self { element, attrs }
    }

    // 保持原有方法不变
    pub fn attr(&self, name: &str) -> Option<&str> {
        self.attrs.get(name).map(|s| s.as_str())
    }

    pub fn text(&self) -> String {
        self.element.text().collect()
    }

    pub fn html(&self) -> String {
        self.element.html()
    }

    pub fn select(&self, selector: &str) -> Result<Vec<Self>, String> {
        let selector = Selector::parse(selector).map_err(|e| format!("Invalid selector: {}", e))?;
        Ok(self.element.select(&selector).map(Self::new).collect())
    }
}

// 文档包装需要管理 HTML 字符串生命周期
#[derive(Debug)]
pub struct JsDocument {
    _html: String, // 保持原始 HTML 的生命周期
    document: Html,
}

impl JsDocument {
    pub fn parse(html: &str) -> Self {
        Self {
            _html: html.to_string(), // 延长字符串生命周期
            document: Html::parse_document(html),
        }
    }

    pub fn select(&self, selector: &str) -> Result<Vec<JsElement>, String> {
        let selector = Selector::parse(selector).map_err(|e| format!("Invalid selector: {}", e))?;
        Ok(self
            .document
            .select(&selector)
            .map(JsElement::new)
            .collect())
    }
}

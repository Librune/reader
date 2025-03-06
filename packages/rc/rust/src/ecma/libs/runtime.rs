// use boa_engine::{property::Attribute, Context};
// use boa_runtime::Console;

// use super::{
//     // crypto::CryptoModule, modules::define_require, object::extend_object, reqwest::define_rq,
//     scraper::jsoup_adapter::add_scraper,
//     string::extend_string,
//     utils::define_utils,
// };

// /// Adds the custom runtime to the context.
// pub fn add_runtime(context: &mut Context) {
//     define_require(context);
//     let console = Console::init(context);
//     context
//         .register_global_property(Console::NAME, console, Attribute::all())
//         .expect("the console builtin shouldn't exist");
//     define_rq(context);
//     add_scraper(context);
//     // define_scraper(context);
//     define_utils(context);
//     CryptoModule::init(context).unwrap();
//     extend_string(context);
//     extend_object(context);
// }

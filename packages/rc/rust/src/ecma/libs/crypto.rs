use aes::cipher::block_padding::Pkcs7;
use aes::cipher::{BlockDecryptMut, KeyIvInit};
use base64::{engine::general_purpose::STANDARD as BASE64, Engine as _};
use boa_engine::object::ObjectInitializer;
use boa_engine::{js_error, js_string, Context, JsResult, JsValue, NativeFunction};
use lazy_static::lazy_static;
use sha2::{Digest, Sha256};
use std::collections::HashMap;
use std::error::Error;
use std::sync::Mutex;
use uuid::Uuid;

type Aes256CbcDec = cbc::Decryptor<aes::Aes256>;

// 加密模式
#[derive(Debug, Clone)]
enum CipherMode {
    Cbc,
}

// AES 类型
#[derive(Debug, Clone)]
enum AesType {
    Aes256,
}

// 填充模式
#[derive(Debug, Clone)]
enum PaddingType {
    NoPadding,
    Pkcs5,
    Pkcs7,
}

// 编码方式
#[derive(Debug, Clone)]
enum Encoding {
    Hex,
    Base64,
}

#[derive(Debug, Clone)]
struct CryptoOptions {
    cipher_mode: CipherMode,
    aes_type: AesType,
    padding_type: PaddingType,
    encoding: Encoding,
    key: Vec<u8>,
    key_derivation: String,
    iv: Option<Vec<u8>>,
}

impl Default for CryptoOptions {
    fn default() -> Self {
        Self {
            cipher_mode: CipherMode::Cbc,
            aes_type: AesType::Aes256,
            padding_type: PaddingType::Pkcs7,
            encoding: Encoding::Base64,
            key: vec![],
            key_derivation: "raw".to_string(),
            iv: None,
        }
    }
}

pub struct CryptoModule;

impl CryptoModule {
    pub fn init(context: &mut Context) -> JsResult<()> {
        let crypto = ObjectInitializer::new(context)
            .function(
                NativeFunction::from_fn_ptr(Self::decrypt),
                js_string!("decrypt"),
                2,
            )
            .function(
                NativeFunction::from_fn_ptr(Self::create_options),
                js_string!("createOptions"),
                1,
            )
            .build();

        context.register_global_property(js_string!("crypto"), crypto, Default::default())?;
        Ok(())
    }

    fn create_options(
        _this: &JsValue,
        args: &[JsValue],
        context: &mut Context,
    ) -> JsResult<JsValue> {
        if args.is_empty() {
            return Err(js_error!("error!"));
        }
        let options_obj = args[0]
            .as_object()
            .ok_or_else(|| js_error!("需要传入一个对象!"))?;

        let mut options = CryptoOptions::default();

        // 读取 cipher_mode
        if let Ok(key) = options_obj.get(js_string!("cipher_mode"), context) {
            let val_str = key.to_string(context)?.to_std_string_escaped();
            options.cipher_mode = match val_str.as_str() {
                "cbc" => CipherMode::Cbc,
                _ => return Err(js_error!("cipher_mode 只支持 cbc")),
            };
        }

        // 读取 aes_type
        if let Ok(key) = options_obj.get(js_string!("aes_type"), context) {
            let val_str = key.to_string(context)?.to_std_string_escaped();
            options.aes_type = match val_str.as_str() {
                "aes256" => AesType::Aes256,
                _ => return Err(js_error!("aes_type 只支持 aes128, aes192, aes256")),
            };
        }

        // 读取 padding_type
        if let Ok(key) = options_obj.get(js_string!("padding_type"), context) {
            let val_str = key.to_string(context)?.to_std_string_escaped();
            options.padding_type = match val_str.as_str() {
                "no_padding" => PaddingType::NoPadding,
                "pkcs5" => PaddingType::Pkcs5,
                "pkcs7" => PaddingType::Pkcs7,
                _ => return Err(js_error!("padding_type 只支持 no_padding, pkcs5, pkcs7")),
            };
        }

        // 读取 encoding
        if let Ok(key) = options_obj.get(js_string!("encoding"), context) {
            let val_str = key.to_string(context)?.to_std_string_escaped();
            options.encoding = match val_str.as_str() {
                "hex" => Encoding::Hex,
                "base64" => Encoding::Base64,
                _ => return Err(js_error!("encoding 只支持 hex, base64")),
            };
        }

        // 读取 key
        if let Ok(key) = options_obj.get(js_string!("key"), context) {
            let key_str = key.to_string(context)?.to_std_string_escaped();
            options.key = key_str.into_bytes();
        }

        // 读取 key_derivation
        if let Ok(key) = options_obj.get(js_string!("key_derivation"), context) {
            let val_str = key.to_string(context)?.to_std_string_escaped();
            options.key_derivation = val_str;
        }

        // 读取 iv
        if let Ok(iv) = options_obj.get(js_string!("iv"), context) {
            let iv_str = iv.to_string(context)?.to_std_string_escaped();
            options.iv = Some(
                iv_str
                    .chars()
                    .map(|c| c.to_digit(10).unwrap() as u8)
                    .collect(),
            );
        }

        let id = store_config(options);
        Ok(JsValue::String(js_string!(id)))
    }

    fn decrypt(_this: &JsValue, args: &[JsValue], context: &mut Context) -> JsResult<JsValue> {
        if args.len() < 2 {
            return Err(js_error!("参数不足!"));
        }
        let encrypted_data = args[0].to_string(context)?.to_std_string_escaped();
        let id = args[1].to_string(context)?.to_std_string_escaped();
        let config = get_config(&id).ok_or_else(|| js_error!("配置不存在!"))?;
        let result =
            decrypt(&encrypted_data, config).map_err(|e| js_error!(js_string!(e.to_string())))?;
        Ok(JsValue::from(js_string!(result)))
    }
}

// 配置存储
lazy_static! {
    static ref CONFIGS: Mutex<HashMap<String, CryptoOptions>> = Mutex::new(HashMap::new());
}

fn store_config(config: CryptoOptions) -> String {
    let id = Uuid::new_v4().to_string();
    CONFIGS.lock().unwrap().insert(id.clone(), config);
    id
}

fn get_config(id: &str) -> Option<CryptoOptions> {
    CONFIGS.lock().unwrap().get(id).cloned()
}

fn decrypt(encrypted_data: &str, options: CryptoOptions) -> Result<String, Box<dyn Error>> {
    let encrypted_bytes = match options.encoding {
        Encoding::Base64 => BASE64.decode(encrypted_data)?,
        Encoding::Hex => hex::decode(encrypted_data)?,
    };
    let key = derive_key(&options.key, &options.key_derivation)?;

    let decrypted = match options.cipher_mode {
        CipherMode::Cbc => {
            let iv = match options.iv {
                Some(ref v) => {
                    if v.len() >= 16 {
                        v[..16].to_vec()
                    } else {
                        vec![0u8; 16]
                    }
                }
                None => vec![0u8; 16],
            };
            match options.aes_type {
                AesType::Aes256 => {
                    let cipher = Aes256CbcDec::new_from_slices(&key, &iv)?;
                    let mut buffer = encrypted_bytes.clone();
                    cipher
                        .decrypt_padded_mut::<Pkcs7>(&mut buffer)
                        .map_err(|e| {
                            println!("解密错误: {:?}", e);
                            format!("解密失败: {}", e)
                        })?
                        .to_vec()
                }
            }
        }
    };

    let decrypted_str = String::from_utf8(decrypted)?;
    Ok(decrypted_str)
}

// 密钥派生函数
fn derive_key(key: &[u8], method: &str) -> Result<Vec<u8>, Box<dyn std::error::Error>> {
    Ok(match method {
        "sha256" => {
            let mut hasher = Sha256::new();
            hasher.update(key);
            hasher.finalize().to_vec()
        }
        "raw" => key.to_vec(),
        _ => return Err("不支持的派生方式".into()),
    })
}

# Reader

> 请注意，此分支只用来技术验证，实际成品并不会基于此分支构建。当前所包含的界面与功能并不完整，目前只能用于体验。

## Build Setup

首先你需要安装 Flutter 和 Rust 环境，具体请参考各自官网：

- [Flutter](https://flutter.dev/docs/get-started/install)
- [Rust](https://www.rust-lang.org/tools/install)

然后，你需要安装 [flutter_rust_bridge](https://cjycode.com/flutter_rust_bridge/quickstart)：

```bash
$ cargo install flutter_rust_bridge_codegen
```

```bash
# Clone this repository on boa branch
$ git clone https://github.com/zsakvo/reader.git -b boa
# Go into the repository and install dependencies
$ cd reader
$ flutter pub get
# Generate Rust bridge code
$ flutter_rust_bridge_codegen generate
# generate build_runner
$ dart run build_runner build
# build release app, example for macos
$ flutter build macos --release
```

## 关于书源

> 当前实现了一套简易的书源系统，支持使用 js 编写书源插件。不过由于暂时未经过充分验证，所以可能会存在未知 bug，如有问题请及时反馈。

**书源目前为单 js 文件，不支持导入外部模块。目前大致接口信息请参考以下内容。**

```typescript
// 书源基本信息
declare const name: string // 书源名称
declare const author: string // 书源作者
declare const version: string // 书源版本
declare const desc: string // 书源描述
declare const id: string // 书源唯一标识 使用 uuid v4 生成

// 表单定义
interface FormItem {
  type: 'input' | 'button' // 表单类型
  field: string // 表单字段名, 如果你设置了 button 类型，那么此字段的字符将会是你点击时执行的函数名。
  title: string // 表单字段标题
  placeholder?: string // 表单字段占位符
}

interface FormGroup {
  title: string // 表单组标题
  subtitle?: string // 表单组副标题
  form: FormItem[] // 表单内容
}

declare const forms: FormGroup[]

// 操作菜单
interface Action {
  icon: string // 菜单图标，未实现，可以暂时随意填写
  label: string // 菜单标题
  action: string // 菜单点击时执行的函数名
}

declare const actions: Action[]

// 环境变量
declare const __ENVS__: {
  [key: string]: string // 环境变量，你保存在本地的值可以通过此对象获取
}

// 请求工具
declare const rq: {
  post: (url: string, options: any) => any // post 请求
  get: (url: string, options: any) => any // get 请求
}

// XML转JSON工具
declare function xml2Json(xml: string): any // xml 转 json 工具

// 搜索相关
interface SearchParams {
  key: string // 搜索关键字
  page: number // 页码（未实现）
  count: number // 每页数量 （未实现）
}

interface BookInfo {
  bookId: string // 书籍唯一标识
  name: string //  书籍名称
  author: string // 书籍作者
  cover: string // 书籍封面 URL 地址
  description: string // 书籍简介
  creationStatus: string // 书籍状态，连载中为 "1"，其它为 "0"
  tag: string[] // 书籍标签
  update: string // 书籍更新时间
}

// 搜索书籍
declare function search(params: SearchParams): BookInfo[]

// 目录相关
interface CatalogParams {
  book_id: string // 书籍唯一标识
}

interface Chapter {
  title: string // 章节名称
  cid: string // 章节唯一标识
  isVip: boolean // 是否需要付费
  hasAccess: boolean // 是否已解锁
}

interface Volume {
  vid: string // 卷唯一标识
  title: string // 卷名称
  chapters: Chapter[] // 章节列表
}

// 获取目录信息
declare function catalog(params: CatalogParams): Volume[]

// 章节内容
interface ChapterParams {
  chapter_id: string // 章节唯一标识
  book_id: string // 书籍唯一标识
}

interface ChapterContent {
  content: string // 章节内容
}

// 获取章节内容
declare function chapter(params: ChapterParams): ChapterContent
```

应用内部提供的工具函数：

```typescript
    xml2Json(xml: string): Object // xml 转 object 工具
    rq.get(url: string, options: any): Object // get 请求
    rq.post(url: string, options: RqOptions): Object // post 请求
    RqOptions: {
        headers: {
            [key: string]: string
        }
        form?: {
            [key: string]: string
        } // post 请求表单
        body?: string // post 请求 string
        data?: {
            [key: string]: string
        } // post 请求 json
    }
    String.prototype.toMd5(): string // 字符串转 md5
    // 加密相关工具
    interface CryptoOptions {
      key: string;
      cipher_mode: 'cbc';
      aes_type: 'aes256';
      key_derivation: 'sha256';
      encoding: 'base64';
      padding_type: 'pkcs7';
      iv?: string;
    }

    declare const crypto: {
      createOptions(options: CryptoOptions): CryptoOptions;
      decrypt(encryptedData: string, options: CryptoOptions): string;
    }
```

- 请注意，在书源环境中，即使是网络请求 rq.get 和 rq.post 也是**同步**的，所以无需使用 async/await。
- 关于解密 crypto，目前作为验证只实现了 AES-256-CBC 解密，具体使用请参考上面的接口信息。暂时**不建议**使用此功能，后续会进行扩充和调整。

## License

GPL-3.0

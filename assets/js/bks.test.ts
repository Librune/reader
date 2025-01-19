// // 定义一个接口来约束 BookSource 类必须实现的属性和方法
// interface IBookSource {
//   name: string;
//   host: string;
//   author: string;
//   form: any[];

//   // 如果需要强制实现某些方法，可以在接口中声明
//   search?(keyword: string): Promise<any>; // 可选方法使用 ?
//   getChapterContent(chapterId: string): Promise<string>; // 必须实现的方法
// }

class Ciweimao {
  name = '刺猬猫阅读'
  host = 'https://app.happybooker.cn'
  author = 'zsakvo'
}

import 'package:contextual_menu/contextual_menu.dart';
import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader_macos/book_source_list/components/form_group.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class BookSourceDetail extends StatefulHookConsumerWidget {
  const BookSourceDetail({super.key, required this.model});
  final BookSourceModel model;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BookSourceDetailState();
}

class _BookSourceDetailState extends ConsumerState<BookSourceDetail> {
  final formKey = GlobalKey<ShadFormState>();

  Menu menu = Menu(
    items: [
      MenuItem(
        label: 'Copy',
        onClick: (_) {
          print('Clicked Copy');
        },
      ),
      MenuItem(label: 'Disabled item', disabled: true),
      MenuItem.checkbox(
        key: 'checkbox1',
        label: 'Checkbox1',
        checked: true,
        onClick: (menuItem) {
          print('Clicked Checkbox1');
          menuItem.checked = !(menuItem.checked == true);
        },
      ),
      MenuItem.separator(),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final model = widget.model;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 6,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 0, right: 12),
          child: Row(
            spacing: 10,
            children: [
              Image.asset("assets/png/browser.png", width: 50),
              SizedBox(
                height: 40,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(model.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text("适配新版 boa 运行时的 wenku8 插件", style: TextStyle(fontSize: 12, color: CupertinoColors.systemGrey2)),
                  ],
                ),
              ),
              Spacer(),
              popUpContextualMenu(_menu!, placement: Placement.bottomLeft),
            ],
          ),
        ),
        DivideredTag(label: "基本信息", color: CupertinoColors.systemBlue, padding: EdgeInsets.only(top: 8, bottom: 2)),
        Padding(
          padding: EdgeInsets.only(top: 0),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "作者：",
                  style: TextStyle(fontSize: 12, color: CupertinoColors.black, fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: model.author,
                  style: TextStyle(fontSize: 12, color: CupertinoColors.black.withValues(alpha: .5)),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 0),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "脚本ID：",
                  style: TextStyle(fontSize: 12, color: CupertinoColors.black, fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: model.uuid!,
                  style: TextStyle(fontSize: 12, color: CupertinoColors.black.withValues(alpha: .5)),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 0),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "安装时间：",
                  style: TextStyle(fontSize: 12, color: CupertinoColors.black, fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: "2025-03-15",
                  style: TextStyle(fontSize: 12, color: CupertinoColors.black.withValues(alpha: .5)),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 0),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "基础地址：",
                  style: TextStyle(fontSize: 12, color: CupertinoColors.black, fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: "http://app.wenku8.com/android.php",
                  style: TextStyle(fontSize: 12, color: CupertinoColors.black.withValues(alpha: .5)),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 0),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "用户代理：",
                  style: TextStyle(fontSize: 12, color: CupertinoColors.black, fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      "Mozilla/5.0 (Linux; Android 10; Pixel 4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.181 Mobile Safari/537.36",
                  style: TextStyle(fontSize: 12, color: CupertinoColors.black.withValues(alpha: .5)),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 0),
          child: Row(
            spacing: 8,
            children: [
              Expanded(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "是否启用：",
                        style: TextStyle(fontSize: 12, color: CupertinoColors.black, fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: "\n\n", style: TextStyle(height: 3, fontSize: 1)),
                      TextSpan(
                        text: "只会影响是否在搜索时使用。如果你的书架有书籍依赖于此源，即使禁用也会继续使用此源。",
                        style: TextStyle(fontSize: 12, color: CupertinoColors.black.withValues(alpha: .5)),
                      ),
                    ],
                  ),
                ),
              ),
              ShadSwitch(width: 36, height: 20, value: model.enabled, onChanged: (value) {}),
            ],
          ),
        ),
        // DivideredTag(label: "表单信息", color: CupertinoColors.systemIndigo, padding: EdgeInsets.only(top: 10, bottom: 0)),
        BookSourceFormGroup(groups: model.forms),

        // Transform.translate(
        //   offset: Offset(-4, 0),
        //   child: Padding(
        //     padding: EdgeInsets.only(top: 4),
        //     child: ShadForm(
        //       key: formKey,
        //       child: Column(
        //         spacing: 6,
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         mainAxisSize: MainAxisSize.min,
        //         children: [
        //           ShadInputFormField(
        //             id: '用户名',
        //             // label: const Text('用户名'),
        //             placeholder: const Text('输入用户名'),
        //             style: TextStyle(fontSize: 12),
        //             placeholderStyle: TextStyle(fontSize: 12),
        //             cursorHeight: 13,
        //             decoration: ShadDecoration(
        //               secondaryFocusedBorder: ShadBorder.fromBorderSide(
        //                 ShadBorderSide(color: CupertinoColors.transparent),
        //               ),
        //               border: ShadBorder.fromBorderSide(ShadBorderSide(color: CupertinoColors.systemGrey5)),
        //             ),
        //           ),
        //           ShadInputFormField(
        //             id: '用户名',
        //             placeholder: const Text('输入密码'),
        //             style: TextStyle(fontSize: 12),
        //             placeholderStyle: TextStyle(fontSize: 12),
        //             cursorHeight: 13,
        //             decoration: ShadDecoration(
        //               secondaryFocusedBorder: ShadBorder.fromBorderSide(
        //                 ShadBorderSide(color: CupertinoColors.transparent),
        //               ),
        //               border: ShadBorder.fromBorderSide(ShadBorderSide(color: CupertinoColors.systemGrey5)),
        //             ),
        //           ),
        //           ShadInputFormField(
        //             id: '用户名',
        //             placeholder: const Text('输入Cookies'),
        //             style: TextStyle(fontSize: 12),
        //             placeholderStyle: TextStyle(fontSize: 12),
        //             cursorHeight: 13,
        //             decoration: ShadDecoration(
        //               secondaryFocusedBorder: ShadBorder.fromBorderSide(
        //                 ShadBorderSide(color: CupertinoColors.transparent),
        //               ),
        //               border: ShadBorder.fromBorderSide(ShadBorderSide(color: CupertinoColors.systemGrey5)),
        //             ),
        //           ),
        //           Padding(
        //             padding: EdgeInsets.only(top: 6),
        //             child: ShadButton(
        //               height: 32,
        //               child: const Text('登录账号', style: TextStyle(fontSize: 12)),
        //               onPressed: () {},
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}

class DivideredTag extends StatelessWidget {
  const DivideredTag({super.key, required this.label, required this.color, this.padding = EdgeInsets.zero});
  final String label;
  final Color color;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        spacing: 2,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: color)),
          Container(margin: EdgeInsets.only(top: 4, bottom: 4), height: 1.2, color: CupertinoColors.systemGrey5),
        ],
      ),
    );
  }
}

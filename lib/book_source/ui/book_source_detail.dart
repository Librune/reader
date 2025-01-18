import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_js/flutter_js.dart';
import 'package:flutter_js/javascript_runtime.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:reader/app/ui/components/app_top_bar.dart';
import 'package:reader/app/ui/components/preference.dart';
import 'package:reader/app/ui/components/svg_btn.dart';
import 'package:reader/book_source/data/model/book_source.dart';

class BookSourceDetail extends HookConsumerWidget {
  const BookSourceDetail({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String? _quickjsVersion;

    Future<String> evalJS() async {
      final JavascriptRuntime javascriptRuntime = getJavascriptRuntime(forceJavascriptCoreOnAndroid: false);
      javascriptRuntime.setInspectable(true);
      javascriptRuntime.onMessage('getDataAsync', (args) async {
        await Future.delayed(const Duration(seconds: 1));
        final int count = args['count'];
        Random rnd = Random();
        final result = <Map<String, int>>[];
        for (int i = 0; i < count; i++) {
          result.add({'key$i': rnd.nextInt(100)});
        }
        return result;
      });
      javascriptRuntime.onMessage('asyncWithError', (_) async {
        await Future.delayed(const Duration(milliseconds: 100));
        return Future.error('Some error');
      });
      JsEvalResult jsResult = await javascriptRuntime.evaluateAsync(
        """
            if (typeof MyClass == 'undefined') {
              var MyClass = class  {
                constructor(id) {
                  this.id = id;
                }
                
                getId() { 
                  return this.id;
                }
              }
            }
            async function test() {
              var obj = new MyClass(1);
              var jsonStringified = JSON.stringify(obj);
              var value = Math.trunc(Math.random() * 100).toString();
              var asyncResult = await sendMessage("getDataAsync", JSON.stringify({"count": Math.trunc(Math.random() * 10)}));
              var err;
              try {
                await sendMessage("asyncWithError", "{}");
              } catch(e) {
                err = e.message || e;
              }
              return {"object": jsonStringified, "expression": value, "asyncResult": asyncResult, "expectedError": err};
            }
            test();
            """,
        sourceUrl: 'script.js',
      );
      javascriptRuntime.executePendingJob();
      JsEvalResult asyncResult = await javascriptRuntime.handlePromise(jsResult);
      return asyncResult.stringResult;
    }

    final execDistJs = useFuture<BookSourceModel>(useMemoized(() async {
      final javascriptRuntime = getJavascriptRuntime(forceJavascriptCoreOnAndroid: false);
      final distJs = await DefaultAssetBundle.of(context).loadString('assets/js/bks.test.js');
      final res =
          await javascriptRuntime.evaluateAsync("""JSON.stringify((() => {$distJs})())""", sourceUrl: 'bks.test.js');
      return BookSourceModel.fromJson(jsonDecode(res.stringResult));
    }));

    final colorScheme = Theme.of(context).colorScheme;

    return switch (execDistJs) {
      AsyncSnapshot(:final data?) => Scaffold(
          appBar: AppTopBar(title: data.name, actions: [
            SvgBtn(
              onPressed: () {},
              svgName: "ic_action_save",
              size: 22,
            ),
            PullDownButton(
              itemBuilder: (context) => data.actions.map<PullDownMenuItem>((action) {
                return PullDownMenuItem(
                  title: action['label'],
                  itemTheme: PullDownMenuItemTheme(
                    textStyle: TextStyle(color: colorScheme.onSurface, fontSize: 15),
                  ),
                  iconWidget: SvgPicture.asset(
                    "assets/svg/${action['icon']}.svg",
                    colorFilter: ColorFilter.mode(colorScheme.secondary, BlendMode.srcIn),
                  ),
                  onTap: () {},
                );
              }).toList(),
              // [
              //   PullDownMenuItem(
              //     title: 'Menu item',
              //     onTap: () {},
              //   ),
              //   PullDownMenuItem(
              //     title: 'Menu item 2',
              //     onTap: () {},
              //   ),
              // ],
              buttonBuilder: (context, showMenu) => SvgBtn(
                onPressed: showMenu,
                svgName: "ic_topbar_more",
                size: 22,
              ),
            )
            // ...data.actions.map<Widget>((action) {
            //   return IconButton(
            //     onPressed: () {},
            //     icon: SvgPicture.asset(
            //       "assets/svg/${action['icon']}.svg",
            //       colorFilter: ColorFilter.mode(colorScheme.onSurface, BlendMode.srcIn),
            //     ),
            //   );
            // })
          ]),
          body: ListView.separated(
              itemBuilder: (context, index) {
                final formGroup = data.forms[index];
                return PreferenceSection(
                    title: formGroup.title,
                    children: formGroup.form
                        .map((ele) => switch (ele.type) {
                              BookSourceFormItemType.toggle => PreferenceSwitch(
                                  value: false,
                                  onChanged: (value) {},
                                  title: ele.title,
                                  subtitle: ele.placeholder ?? "暂无说明",
                                  onTap: () {}),
                              BookSourceFormItemType.input => PreferenceInput(
                                  title: ele.title,
                                  subtitle: ele.placeholder ?? "暂无说明",
                                ),
                              _ => PreferenceTap(title: ele.title, subtitle: ele.placeholder ?? "暂无说明", onTap: () {})
                            })
                        .toList());
              },
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: 8,
                );
              },
              itemCount: data.forms.length),
        ),
      _ => Center(child: CircularProgressIndicator()),
    };
  }
}

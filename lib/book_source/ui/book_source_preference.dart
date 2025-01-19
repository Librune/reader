import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:reader/app/ui/components/app_top_bar.dart';
import 'package:reader/app/ui/components/preference.dart';
import 'package:reader/app/ui/components/svg_btn.dart';
import 'package:reader/book_source/data/model/book_source.dart';
import 'package:reader/book_source/provider/book_source_provider.dart';

class BookSourcePreference extends HookConsumerWidget {
  const BookSourcePreference({super.key, required this.model});
  final BookSourceModel model;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final _formKey = GlobalKey<FormBuilderState>();
    return Scaffold(
        appBar: AppTopBar(title: model.name, actions: [
          SvgBtn(
            onPressed: () {
              model.saveEnvs(_formKey);
            },
            svgName: "ic_action_save",
            size: 22,
          ),
          PullDownButton(
            itemBuilder: (context) => model.actions.map<PullDownMenuItem>((action) {
              return PullDownMenuItem(
                title: action['label'],
                itemTheme: PullDownMenuItemTheme(
                  textStyle: TextStyle(color: colorScheme.onSurface, fontSize: 15),
                ),
                iconWidget: SvgPicture.asset(
                  "assets/svg/${action['icon']}.svg",
                  colorFilter: ColorFilter.mode(colorScheme.secondary, BlendMode.srcIn),
                ),
                onTap: () {
                  model.action(action['action']);
                },
              );
            }).toList(),
            buttonBuilder: (context, showMenu) => SvgBtn(
              onPressed: showMenu,
              svgName: "ic_topbar_more",
              size: 22,
            ),
          )
        ]),
        body: FormBuilder(
          key: _formKey,
          initialValue: model.envs,
          child: ListView.separated(
              itemBuilder: (context, index) {
                final formGroup = model.forms[index];
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
                                  name: ele.field,
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
              itemCount: model.forms.length),
        ));
  }
}

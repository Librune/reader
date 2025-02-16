import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:reader/app/architecture/service/book_source.dart';
import 'package:reader/app/ui/components/app_top_bar.dart';
import 'package:reader/app/ui/components/preference.dart';
import 'package:reader/app/ui/components/svg_btn.dart';
import 'package:reader/book_source/data/model/book_source.dart';
import 'package:reader/book_source/usecase/bks_envs_usecase.dart';

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
              BksEnvsUsecase.save(_formKey, uuid: model.uuid);
            },
            svgName: "ic_action_save",
            size: 22,
          ),
          PullDownButton(
            itemBuilder: (context) => [
              ...model.actions.map<PullDownMenuItem>((action) {
                return PullDownMenuItem(
                  title: action['label'],
                  itemTheme: PullDownMenuItemTheme(
                    textStyle:
                        TextStyle(color: colorScheme.onSurface, fontSize: 15),
                  ),
                  iconWidget: SvgPicture.asset(
                    "assets/svg/${action['icon']}.svg",
                    colorFilter: ColorFilter.mode(
                        colorScheme.secondary, BlendMode.srcIn),
                  ),
                  onTap: () {
                    BookSourceService()
                        .action(uuid: model.uuid, act: action['action']);
                  },
                );
              }),
              PullDownMenuItem(
                title: "测试",
                itemTheme: PullDownMenuItemTheme(
                  textStyle:
                      TextStyle(color: colorScheme.onSurface, fontSize: 15),
                ),
                iconWidget: SvgPicture.asset(
                  "assets/svg/ic_btn_satellite.svg",
                  colorFilter:
                      ColorFilter.mode(colorScheme.secondary, BlendMode.srcIn),
                ),
                onTap: () {
                  // model.action(action['action']);
                  context.push("/book_source_test/${model.uuid}");
                },
              )
            ],
            buttonBuilder: (context, showMenu) => SvgBtn(
              onPressed: showMenu,
              svgName: "ic_topbar_more",
              size: 22,
            ),
          )
        ]),
        body: FormBuilder(
          key: _formKey,
          initialValue: BksEnvsUsecase.read(uuid: model.uuid),
          child: ListView.separated(
              itemBuilder: (context, index) {
                final formGroup = model.forms[index];
                return PreferenceSection(
                    title: formGroup.title,
                    subtitle: formGroup.subtitle,
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
                              BookSourceFormItemType.button => PreferenceButton(
                                  title: ele.title,
                                  subtitle: ele.placeholder ?? "暂无说明",
                                  onPressed: () {
                                    BksEnvsUsecase.syncValueToJs(_formKey,
                                            uuid: model.uuid)
                                        .then((_) async {
                                      await BookSourceService().action(
                                          uuid: model.uuid, act: ele.field);
                                    });
                                  },
                                ),
                              _ => PreferenceTap(
                                  title: ele.title,
                                  subtitle: ele.placeholder ?? "暂无说明",
                                  onTap: () {})
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

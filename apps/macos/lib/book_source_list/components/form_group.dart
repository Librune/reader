import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BookSourceFormGroup extends StatefulHookConsumerWidget {
  const BookSourceFormGroup({super.key, required this.groups});
  final List<BookSourceFormModel> groups;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BookSourceFormGroupState();
}

class _BookSourceFormGroupState extends ConsumerState<BookSourceFormGroup> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Column(children: [for (final group in widget.groups) Container()]));
  }
}

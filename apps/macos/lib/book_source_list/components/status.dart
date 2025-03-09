import 'package:flutter/cupertino.dart';

class BookSourceStatus extends StatelessWidget {
  const BookSourceStatus({super.key, this.enabled = false});
  final bool enabled;

  Color get _color => enabled ? CupertinoColors.activeGreen : CupertinoColors.systemGrey;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22,
      width: 60,
      decoration: BoxDecoration(
        color: _color.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(30.0),
        border: Border.all(color: _color.withValues(alpha: .8), width: 1.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 4,
        children: [
          Icon(enabled ? CupertinoIcons.check_mark : CupertinoIcons.xmark, size: 10, color: _color),
          Text(enabled ? '已启用' : '未启用', style: TextStyle(color: _color, fontSize: 10)),
        ],
      ),
    );
  }
}

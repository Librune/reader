import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ContentArea extends StatefulHookConsumerWidget {
  const ContentArea({super.key, required this.title, this.subtitle, required this.child});
  final String title;
  final String? subtitle;
  final Widget child;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ContentAreaState();
}

class _ContentAreaState extends ConsumerState<ContentArea> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: CupertinoColors.white,
      child: Column(
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 24, top: 26),
            child: Row(
              children: [
                RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: widget.title,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: CupertinoColors.black,
                          height: 1,
                        ),
                      ),
                      if (widget.subtitle != null) TextSpan(text: "\n\n", style: TextStyle(height: 10, fontSize: 1)),
                      if (widget.subtitle != null)
                        TextSpan(
                          text: widget.subtitle,
                          style: TextStyle(
                            fontSize: 11,
                            color: CupertinoColors.systemGrey.withValues(alpha: .8),
                            height: 1,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: widget.child),
        ],
      ),
    );
  }
}

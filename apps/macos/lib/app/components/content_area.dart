import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ContentArea extends StatefulHookConsumerWidget {
  const ContentArea({
    super.key,
    required this.title,
    this.subtitle,
    this.action,
    required this.child,
    this.padding,
    this.canPop = false,
  });
  final String title;
  final String? subtitle;
  final Widget? action;
  final EdgeInsets? padding;
  final bool? canPop;
  final Widget child;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ContentAreaState();
}

class _ContentAreaState extends ConsumerState<ContentArea> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: CupertinoColors.white,
      padding: widget.padding,
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 86,
            child: Stack(
              children: [
                Positioned(
                  left: 24,
                  right: 24,
                  top: 24,
                  child: Row(
                    spacing: 16,
                    children: [
                      if (widget.canPop!)
                        GestureDetector(
                          onTap: () {
                            context.pop();
                          },
                          child: Icon(
                            CupertinoIcons.arrow_left,
                            size: 28,
                            color: CupertinoColors.black,
                          ),
                        ),
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: CupertinoColors.black,
                          height: 1,
                        ),
                      ),
                      if (widget.action != null)
                        Expanded(child: widget.action!),
                    ],
                  ),
                ),
                if (widget.subtitle != null)
                  Positioned(
                    left: 24,
                    bottom: 12,
                    child: Text(
                      widget.subtitle!,
                      style: TextStyle(
                        fontSize: 11,
                        color: CupertinoColors.systemGrey.withValues(alpha: .8),
                        height: 1,
                      ),
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

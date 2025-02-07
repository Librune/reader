import 'package:flutter/material.dart';
import 'package:reader/reader/data/model/menu.dart';

class PersistentBottomSheet extends StatefulWidget {
  /// 内容 Widget
  final Widget child;

  /// 完全展开时的高度
  final double maxHeight;

  /// 完全隐藏时的高度（通常为 0）
  final double minHeight;

  /// 内边距
  final EdgeInsets padding;

  /// 拖拽隐藏回调
  final Function(bool triggeredByDrag)? onHide;

  /// sheet 类型
  final ReaderBottomSheet type;

  const PersistentBottomSheet({
    super.key,
    required this.child,
    required this.maxHeight,
    required this.type,
    this.minHeight = 0,
    this.padding = EdgeInsets.zero,
    this.onHide,
  });

  @override
  PersistentBottomSheetState createState() => PersistentBottomSheetState();
}

class PersistentBottomSheetState extends State<PersistentBottomSheet> with SingleTickerProviderStateMixin {
  /// 控制底部弹出组件高度的动画控制器，取值范围 0～1
  late AnimationController _animationController;

  /// 是否正在显示组件
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    // 初始状态设置为隐藏(0)
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: 0.0, // 0 表示完全隐藏，1 表示完全展开
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// 显示组件（展开到底部弹出组件的最大高度）
  void show() {
    setState(() {
      _isVisible = true;
    });
    _animateTo(1.0);
  }

  /// 隐藏组件（收起到底部）
  void hide({bool triggeredByDrag = false}) {
    _animateTo(0.0).then((_) {
      setState(() {
        _isVisible = false;
      });
      widget.onHide?.call(triggeredByDrag);
    });
  }

  void toggle() {
    if (_isVisible) {
      hide();
    } else {
      show();
    }
  }

  bool get isVisible => _isVisible;

  ReaderBottomSheet get type => widget.type;

  Future<void> _animateTo(double target) {
    return _animationController.animateTo(target, curve: Curves.easeOut);
  }

  /// 当前拖动时的偏移量，取决于动画控制器的 value 值
  double get _currentOffset {
    // 当 value == 1 时，偏移为 0（完全展开）；当 value == 0 时，偏移为整个 sheet 的高度（隐藏）
    return (1 - _animationController.value) * widget.maxHeight;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        height: widget.maxHeight,
        child: Offstage(
          offstage: !_isVisible,
          child: GestureDetector(
            // 通过垂直拖动手势更新动画控制器的 value，从而控制高度变化
            onVerticalDragUpdate: (details) {
              // 计算拖动量在 0～1 之间的变化比例
              double delta = details.primaryDelta! / widget.maxHeight;
              _animationController.value -= delta;
            },
            onVerticalDragEnd: (details) {
              // 根据拖动结束时的动画值决定展开还是收起
              if (_animationController.value < 0.5) {
                hide(triggeredByDrag: true);
              } else {
                show();
              }
            },
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _currentOffset),
                  child: child,
                );
              },
              child: Material(
                // 使用 Material 包裹以获得默认阴影和背景效果
                elevation: 12,
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Padding(
                      padding: widget.padding,
                      child: Column(
                        children: [
                          // 拖动指示器
                          Container(
                            width: 40,
                            height: 4,
                            margin: const EdgeInsets.only(top: 12, bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          // 内容区域，这里仅作为示例显示一个列表
                          Expanded(
                            child: widget.child,
                          )
                        ],
                      ),
                    )),
              ),
            ),
          ),
        ));
  }
}

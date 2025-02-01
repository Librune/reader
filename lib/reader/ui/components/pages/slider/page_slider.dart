import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PageSlider extends HookConsumerWidget with WidgetsBindingObserver {
  const PageSlider({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.onPageChanged,
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final void Function(int page)? onPageChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    // 用于记录拖动开始时的滚动位置
    final startDragOffset = useState<double?>(null);

    // 拖动开始时调用
    void handleDragStart(DragStartDetails details) {
      // 记录拖动开始时的滚动位置
      startDragOffset.value = scrollController.offset;
      // 如果需要，可以在此取消之前的滚动动画（animateTo 返回的 Future 无法直接取消，但新的动画会中断前一个动画）
    }

    // 拖动更新时调用
    void handleDragUpdate(DragUpdateDetails details) {
      final delta = details.primaryDelta ?? 0;
      // 实时更新滚动位置
      scrollController.jumpTo(scrollController.offset - delta);
    }

    // 拖动结束时调用
    void handleDragEnd(DragEndDetails details) {
      const threshold = 8.0; // 定义拖动距离的阈值
      final viewportWidth = MediaQuery.of(context).size.width;

      // 当前的滚动位置
      final currentOffset = scrollController.offset;
      // 拖动开始时的滚动位置（如果没有记录则默认为当前偏移）
      final initialOffset = startDragOffset.value ?? currentOffset;
      // 计算拖动的相对距离
      final dragDistance = currentOffset - initialOffset;

      // 根据初始偏移计算当前页
      int currentPage = (initialOffset / viewportWidth).round();
      int targetPage = currentPage;

      // 判断拖动距离是否超过阈值
      if (dragDistance.abs() > threshold) {
        // 如果拖动向左（当前偏移比初始值大），则移动到下一页
        if (dragDistance > 0) {
          targetPage = currentPage + 1;
        } else {
          targetPage = currentPage - 1;
        }
        // 限制页码范围
        targetPage = targetPage.clamp(0, itemCount - 1);
      } else {
        // 拖动不足阈值，则回到当前页
        targetPage = currentPage;
      }

      // 计算目标滚动偏移
      final targetOffset = targetPage * viewportWidth;

      // 使用 animateTo 平滑滚动到目标位置，duration 和 curve 可根据需要调整
      scrollController
          .animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      )
          .then((_) {
        // 动画完成后调用翻页回调
        if (onPageChanged != null) {
          onPageChanged!(targetPage);
        }
      });
    }

    return RawGestureDetector(
      behavior: HitTestBehavior.opaque,
      gestures: {
        HorizontalDragGestureRecognizer: GestureRecognizerFactoryWithHandlers<HorizontalDragGestureRecognizer>(
          () => HorizontalDragGestureRecognizer(),
          (instance) => instance
            ..onStart = handleDragStart
            ..onUpdate = handleDragUpdate
            ..onEnd = handleDragEnd,
        ),
      },
      child: CustomScrollView(
        controller: scrollController,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        slivers: [
          SliverMainAxisGroup(
            slivers: [_buildPageSliver()],
          )
        ],
      ),
    );
  }

  Widget _buildPageSliver() {
    return SliverFillViewport(
      delegate: SliverChildBuilderDelegate(
        (context, index) => itemBuilder(context, index),
        childCount: itemCount,
      ),
      viewportFraction: 1,
    );
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
  }
}

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/app/architecture/utils/log.dart';

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
    // 新增：记录当前页
    final currentPage = useRef(0);
    final screenWidth = MediaQuery.of(context).size.width;

    // 拖动开始时调用
    void handleDragStart(DragStartDetails details) {
      // 记录拖动开始时的滚动位置
      startDragOffset.value = scrollController.offset;
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
      // 当前的滚动位置
      final currentOffset = scrollController.offset;
      // 拖动开始时的滚动位置（如果没有记录则默认为当前偏移）
      final initialOffset = startDragOffset.value ?? currentOffset;
      // 计算拖动的相对距离
      final dragDistance = currentOffset - initialOffset;

      // 以当前页为基础
      int targetPage = currentPage.value;

      // 如果拖动距离超过阈值，则根据方向修改目标页
      if (dragDistance.abs() > threshold) {
        if (dragDistance > 0) {
          targetPage = currentPage.value + 1;
        } else {
          targetPage = currentPage.value - 1;
        }
        // 限制目标页范围
        targetPage = targetPage.clamp(0, itemCount - 1);
      }
      // 计算目标滚动偏移
      final targetOffset = targetPage * screenWidth;

      // 平滑滚动到目标位置
      scrollController
          .animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      )
          .then((_) {
        // 动画完成后更新当前页状态及回调
        currentPage.value = targetPage;
        if (onPageChanged != null) {
          onPageChanged!(targetPage);
        }
      });
    }

    // 点击事件处理
    void handleTapUp(TapUpDetails details) {
      // 判断点击位置：屏幕左侧和右侧各占 1/3
      if (details.localPosition.dx < screenWidth / 3) {
        // 点击左侧，翻到上一页
        final targetPage = (currentPage.value - 1).clamp(0, itemCount - 1);
        if (targetPage != currentPage.value) {
          scrollController
              .animateTo(
            targetPage * screenWidth,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          )
              .then((_) {
            currentPage.value = targetPage;
            if (onPageChanged != null) {
              onPageChanged!(targetPage);
            }
          });
        }
      } else if (details.localPosition.dx > screenWidth * 2 / 3) {
        // 点击右侧，翻到下一页
        final targetPage = (currentPage.value + 1).clamp(0, itemCount - 1);
        if (targetPage != currentPage.value) {
          scrollController
              .animateTo(
            targetPage * screenWidth,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          )
              .then((_) {
            currentPage.value = targetPage;
            if (onPageChanged != null) {
              onPageChanged!(targetPage);
            }
          });
        }
      }
    }

    return RawGestureDetector(
      behavior: HitTestBehavior.translucent,
      gestures: {
        TapGestureRecognizer: GestureRecognizerFactoryWithHandlers<TapGestureRecognizer>(
            () => TapGestureRecognizer(), (instance) => instance..onTapUp = handleTapUp),
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

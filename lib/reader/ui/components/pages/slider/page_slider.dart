import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/app/architecture/utils/log.dart';
import 'package:reader/reader/usecase/provider_usecase.dart';

class PageSlider extends HookConsumerWidget with WidgetsBindingObserver {
  const PageSlider({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.toggleMenu,
    this.onPageChanged,
    required this.controller, // 新增控制器参数
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final void Function() toggleMenu;
  final void Function(int page)? onPageChanged;
  final PageSliderController controller; // 控制器

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    // 用于记录拖动开始时的滚动位置
    final startDragOffset = useState<double?>(null);
    // 用 useRef 存储当前页（初始为 0）
    final currentPage = useRef(0);
    final screenWidth = MediaQuery.of(context).size.width;

    // 将控制器的重置和跳转方法赋值出去（仅在第一次 build 时执行）
    useEffect(() {
      // 重置方法：回到第 0 页
      controller._reset = () {
        currentPage.value = 0;
        scrollController.jumpTo(0);
        if (onPageChanged != null) {
          onPageChanged!(0);
        }
      };
      // 跳转方法：跳转到指定页
      controller._jumpToPage = (int page) {
        // 限制 page 范围
        final targetPage = page.clamp(0, itemCount - 1);
        scrollController.jumpTo(
          targetPage * screenWidth,
        );

        currentPage.value = targetPage;
        if (onPageChanged != null) {
          onPageChanged!(targetPage);
        }
      };
      // 清理时将 _reset 和 _jumpToPage 置空
      return () {
        controller._reset = null;
        controller._jumpToPage = null;
      };
    }, [controller, scrollController, screenWidth]);

    // 拖动开始时调用
    void handleDragStart(DragStartDetails details) {
      startDragOffset.value = scrollController.offset;
    }

    // 拖动更新时调用
    void handleDragUpdate(DragUpdateDetails details) {
      final delta = details.primaryDelta ?? 0;
      scrollController.jumpTo(scrollController.offset - delta);
    }

    // 拖动结束时调用
    void handleDragEnd(DragEndDetails details) {
      const threshold = 8.0;
      final currentOffset = scrollController.offset;
      final initialOffset = startDragOffset.value ?? currentOffset;
      final dragDistance = currentOffset - initialOffset;

      int targetPage = currentPage.value;
      if (dragDistance.abs() > threshold) {
        if (dragDistance > 0) {
          targetPage = currentPage.value + 1;
        } else {
          targetPage = currentPage.value - 1;
        }
        targetPage = targetPage.clamp(0, itemCount - 1);
      }
      final targetOffset = targetPage * screenWidth;

      scrollController
          .animateTo(
        targetOffset,
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

    // 点击事件处理
    void handleTapUp(TapUpDetails details) {
      if (details.localPosition.dx < screenWidth / 3) {
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
      } else {
        toggleMenu();
      }
    }

    return RawGestureDetector(
      behavior: HitTestBehavior.translucent,
      gestures: {
        TapGestureRecognizer: GestureRecognizerFactoryWithHandlers<TapGestureRecognizer>(
          () => TapGestureRecognizer(),
          (instance) => instance..onTapUp = handleTapUp,
        ),
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

/// 控制器类
class PageSliderController {
  /// 内部保存重置方法，由 PageSlider 初始化后赋值
  void Function()? _reset;

  /// 内部保存跳转方法，由 PageSlider 初始化后赋值
  void Function(int page)? _jumpToPage;

  /// 外部调用重置方法
  void reset() {
    if (_reset != null) {
      _reset!();
    }
  }

  /// 外部调用跳转到指定页面的方法
  void jumpToPage(int page) {
    if (_jumpToPage != null) {
      _jumpToPage!(page);
    }
  }
}

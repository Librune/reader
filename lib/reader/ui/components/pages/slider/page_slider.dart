import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/app/architecture/utils/log.dart';

class PageSlider extends StatefulHookConsumerWidget {
  const PageSlider({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.toggleMenu,
    this.onPageChanged,
    required this.controller,
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final void Function() toggleMenu;
  final void Function(int page)? onPageChanged;
  final PageSliderController controller;

  @override
  ConsumerState<PageSlider> createState() => _PageSliderState();
}

class _PageSliderState extends ConsumerState<PageSlider> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
  }

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    final startDragOffset = useState<double?>(null);
    final currentPage = useRef(0);
    final screenWidth = MediaQuery.of(context).size.width;

    useEffect(() {
      widget.controller._reset = () {
        currentPage.value = 0;
        scrollController.jumpTo(0);
        if (widget.onPageChanged != null) {
          widget.onPageChanged!(0);
        }
      };

      widget.controller._jumpToPage = (int page) {
        scrollController.jumpTo(
          page * screenWidth,
        );
        currentPage.value = page;
        if (widget.onPageChanged != null) {
          widget.onPageChanged!(page);
        }
      };

      return () {
        widget.controller._reset = null;
        widget.controller._jumpToPage = null;
      };
    }, [widget.controller, scrollController, screenWidth]);

    void handleDragStart(DragStartDetails details) {
      startDragOffset.value = scrollController.offset;
    }

    void handleDragUpdate(DragUpdateDetails details) {
      final delta = details.primaryDelta ?? 0;
      scrollController.jumpTo(scrollController.offset - delta);
    }

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
        targetPage = targetPage.clamp(0, widget.itemCount - 1);
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
        if (widget.onPageChanged != null) {
          widget.onPageChanged!(targetPage);
        }
      });
    }

    void handleTapUp(TapUpDetails details) {
      if (details.localPosition.dx < screenWidth / 3) {
        final targetPage = (currentPage.value - 1).clamp(0, widget.itemCount - 1);
        if (targetPage != currentPage.value) {
          scrollController
              .animateTo(
            targetPage * screenWidth,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          )
              .then((_) {
            currentPage.value = targetPage;
            if (widget.onPageChanged != null) {
              widget.onPageChanged!(targetPage);
            }
          });
        }
      } else if (details.localPosition.dx > screenWidth * 2 / 3) {
        final targetPage = (currentPage.value + 1).clamp(0, widget.itemCount - 1);
        if (targetPage != currentPage.value) {
          scrollController
              .animateTo(
            targetPage * screenWidth,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          )
              .then((_) {
            currentPage.value = targetPage;
            if (widget.onPageChanged != null) {
              widget.onPageChanged!(targetPage);
            }
          });
        }
      } else {
        widget.toggleMenu();
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
        (context, index) => widget.itemBuilder(context, index),
        childCount: widget.itemCount,
      ),
      viewportFraction: 1,
    );
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

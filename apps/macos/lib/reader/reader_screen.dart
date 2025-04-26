import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ReaderScreen extends StatefulHookConsumerWidget {
  const ReaderScreen({
    super.key,
    required this.uuid,
    required this.bid,
    required this.cid,
  });
  final String uuid;
  final String bid;
  final String cid;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends ConsumerState<ReaderScreen> {
  // Mock data for demonstration
  final String bookTitle = "三体";
  final String chapterTitle = "第一章 科学边界";
  final String authorName = "刘慈欣";
  final int totalChapters = 42;
  final int currentChapterIndex = 1;

  // 阅读设置状态
  bool _showSettings = false;
  bool _showTableOfContents = false;
  double _fontSize = 18;
  double _lineHeight = 1.5;
  Color _bgColor = const Color(0xFFF8F9FA);
  Color _textColor = const Color(0xFF1A1D1E);
  String _fontFamily = 'System';
  double _horizontalPadding = 240; // 更大的页面边距，适合桌面阅读
  double _maxContentWidth = 800; // 最大内容宽度

  // 模拟进度
  double _readingProgress = 0.0;

  // 模拟章节列表
  final List<Map<String, dynamic>> _chaptersList = List.generate(
    42,
    (index) => {
      'title': '第${index + 1}章 ${index == 0 ? '科学边界' : '章节标题 ${index + 1}'}',
      'id': 'c${index + 1}',
    },
  );

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    final _readerProvider = readerProvider(
      uuid: widget.uuid,
      bid: widget.bid,
      cid: widget.cid,
    );
    final reader = ref.watch(_readerProvider);
    final screenWidth = MediaQuery.of(context).size.width;

    return Material(
      color: _bgColor,
      child: Row(
        children: [
          // 左侧章节目录 (如果显示)
          if (_showTableOfContents)
            Container(
              width: 280,
              decoration: BoxDecoration(
                color:
                    _bgColor.computeLuminance() > 0.5
                        ? Color(0xFFF1F5F9)
                        : Color(0xFF1A1D1E),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: Offset(1, 0),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 目录标题栏
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '目录',
                          style: TextStyle(
                            color: _textColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          bookTitle,
                          style: TextStyle(
                            color: _textColor.withOpacity(0.7),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: _textColor.withOpacity(0.1),
                  ),

                  // 章节列表
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      itemCount: _chaptersList.length,
                      itemBuilder: (context, index) {
                        final chapter = _chaptersList[index];
                        final isCurrentChapter =
                            index + 1 == currentChapterIndex;

                        return Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isCurrentChapter
                                    ? _textColor.withOpacity(0.1)
                                    : Colors.transparent,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: ListTile(
                            dense: true,
                            title: Text(
                              chapter['title'],
                              style: TextStyle(
                                color: _textColor,
                                fontSize: 14,
                                fontWeight:
                                    isCurrentChapter
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () {
                              // 切换章节的逻辑
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

          // 主内容区域
          Expanded(
            child: Column(
              children: [
                // 顶部工具栏
                Container(
                  height: 48,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: _bgColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // 目录按钮
                      IconButton(
                        icon: Icon(
                          _showTableOfContents ? Icons.menu_open : Icons.menu,
                          color: _textColor,
                        ),
                        onPressed: () {
                          setState(() {
                            _showTableOfContents = !_showTableOfContents;
                          });
                        },
                        tooltip: '目录',
                      ),

                      // 标题
                      Text(
                        bookTitle,
                        style: TextStyle(
                          color: _textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        ' · ',
                        style: TextStyle(
                          color: _textColor.withOpacity(0.5),
                          fontSize: 16,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          chapterTitle,
                          style: TextStyle(
                            color: _textColor.withOpacity(0.8),
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      // 右侧工具按钮
                      IconButton(
                        icon: Icon(Icons.bookmark_border, color: _textColor),
                        onPressed: () {},
                        tooltip: '书签',
                      ),
                      IconButton(
                        icon: Icon(Icons.text_fields, color: _textColor),
                        onPressed: () {
                          setState(() {
                            _showSettings = !_showSettings;
                          });
                        },
                        tooltip: '阅读设置',
                      ),
                    ],
                  ),
                ),

                // 内容区域
                Expanded(
                  child: switch (reader) {
                    AsyncData(:final value) => Center(
                      child: Container(
                        constraints: BoxConstraints(maxWidth: _maxContentWidth),
                        child: SingleChildScrollView(
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                screenWidth <= 1200 ? 40 : _horizontalPadding,
                            vertical: 40,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                chapterTitle,
                                style: TextStyle(
                                  fontSize: _fontSize + 8,
                                  fontWeight: FontWeight.bold,
                                  color: _textColor,
                                  fontFamily: _fontFamily,
                                  height: _lineHeight,
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                '作者: $authorName',
                                style: TextStyle(
                                  fontSize: _fontSize - 2,
                                  color: _textColor.withOpacity(0.6),
                                  fontFamily: _fontFamily,
                                ),
                              ),
                              SizedBox(height: 40),
                              Text(
                                value,
                                style: TextStyle(
                                  fontSize: _fontSize,
                                  color: _textColor,
                                  fontFamily: _fontFamily,
                                  height: _lineHeight,
                                ),
                              ),
                              SizedBox(height: 60),
                            ],
                          ),
                        ),
                      ),
                    ),
                    AsyncLoading() => Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 32,
                            height: 32,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: _textColor.withOpacity(0.7),
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            '加载中...',
                            style: TextStyle(
                              color: _textColor.withOpacity(0.7),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AsyncError(:final error) => Center(
                      child: Container(
                        width: 400,
                        padding: EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color:
                              _bgColor.computeLuminance() > 0.5
                                  ? Color(0xFFF9F9F9)
                                  : Color(0xFF242424),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 48,
                              color: Colors.red.shade300,
                            ),
                            SizedBox(height: 16),
                            Text(
                              '加载失败',
                              style: TextStyle(
                                color: Colors.red.shade300,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              error.toString(),
                              style: TextStyle(
                                color: _textColor.withOpacity(0.7),
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: () {
                                ref.refresh(_readerProvider);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    _bgColor.computeLuminance() > 0.5
                                        ? Color(0xFF18181B)
                                        : Color(0xFFF1F5F9),
                                foregroundColor:
                                    _bgColor.computeLuminance() > 0.5
                                        ? Colors.white
                                        : Colors.black,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text('重试'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    _ => SizedBox.shrink(),
                  },
                ),

                // 底部控制栏
                Container(
                  height: 48,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: _bgColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 2,
                        offset: Offset(0, -1),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // 上一章
                      TextButton.icon(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          size: 16,
                          color: _textColor.withOpacity(0.7),
                        ),
                        label: Text(
                          '上一章',
                          style: TextStyle(
                            color: _textColor.withOpacity(0.7),
                            fontSize: 14,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                        ),
                        onPressed: () {},
                      ),

                      SizedBox(width: 16),

                      // 章节导航控件
                      Text(
                        '${currentChapterIndex}/${totalChapters}',
                        style: TextStyle(
                          color: _textColor.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),

                      SizedBox(width: 16),

                      // 下一章
                      TextButton.icon(
                        icon: Text(
                          '下一章',
                          style: TextStyle(
                            color: _textColor.withOpacity(0.7),
                            fontSize: 14,
                          ),
                        ),
                        label: Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: _textColor.withOpacity(0.7),
                        ),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                        ),
                        onPressed: () {},
                      ),

                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 24),
                          child: SliderTheme(
                            data: SliderThemeData(
                              trackHeight: 4,
                              thumbShape: RoundSliderThumbShape(
                                enabledThumbRadius: 6,
                              ),
                              overlayShape: RoundSliderOverlayShape(
                                overlayRadius: 14,
                              ),
                            ),
                            child: Slider(
                              value: _readingProgress,
                              onChanged: (value) {
                                setState(() {
                                  _readingProgress = value;
                                });
                              },
                              activeColor: Color(0xFF18181B),
                              inactiveColor: Color(0xFFE4E4E7),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 右侧设置面板（如果显示）
          if (_showSettings)
            Container(
              width: 320,
              decoration: BoxDecoration(
                color:
                    _bgColor.computeLuminance() > 0.5
                        ? Color(0xFFF1F5F9)
                        : Color(0xFF1A1D1E),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: Offset(-1, 0),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 设置面板标题栏
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '阅读设置',
                          style: TextStyle(
                            color: _textColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: _textColor),
                          onPressed: () {
                            setState(() {
                              _showSettings = false;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: _textColor.withOpacity(0.1),
                  ),

                  // 设置选项
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.all(16),
                      children: [
                        // 字体大小
                        Text(
                          '字体大小',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: _textColor,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              'A',
                              style: TextStyle(
                                fontSize: 14,
                                color: _textColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: SliderTheme(
                                data: SliderThemeData(
                                  trackHeight: 4,
                                  thumbShape: RoundSliderThumbShape(
                                    enabledThumbRadius: 6,
                                  ),
                                  overlayShape: RoundSliderOverlayShape(
                                    overlayRadius: 14,
                                  ),
                                ),
                                child: Slider(
                                  value: _fontSize,
                                  min: 14,
                                  max: 24,
                                  onChanged: (value) {
                                    setState(() {
                                      _fontSize = value;
                                    });
                                  },
                                  activeColor: Color(0xFF18181B),
                                  inactiveColor: Color(0xFFE4E4E7),
                                ),
                              ),
                            ),
                            Text(
                              'A',
                              style: TextStyle(
                                fontSize: 20,
                                color: _textColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24),

                        // 行高
                        Text(
                          '行高',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: _textColor,
                          ),
                        ),
                        SizedBox(height: 8),
                        SliderTheme(
                          data: SliderThemeData(
                            trackHeight: 4,
                            thumbShape: RoundSliderThumbShape(
                              enabledThumbRadius: 6,
                            ),
                            overlayShape: RoundSliderOverlayShape(
                              overlayRadius: 14,
                            ),
                          ),
                          child: Slider(
                            value: _lineHeight,
                            min: 1.0,
                            max: 2.0,
                            onChanged: (value) {
                              setState(() {
                                _lineHeight = value;
                              });
                            },
                            activeColor: Color(0xFF18181B),
                            inactiveColor: Color(0xFFE4E4E7),
                          ),
                        ),
                        SizedBox(height: 24),

                        // 页面宽度
                        Text(
                          '页面宽度',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: _textColor,
                          ),
                        ),
                        SizedBox(height: 8),
                        SliderTheme(
                          data: SliderThemeData(
                            trackHeight: 4,
                            thumbShape: RoundSliderThumbShape(
                              enabledThumbRadius: 6,
                            ),
                            overlayShape: RoundSliderOverlayShape(
                              overlayRadius: 14,
                            ),
                          ),
                          child: Slider(
                            value: _maxContentWidth,
                            min: 600,
                            max: 1200,
                            onChanged: (value) {
                              setState(() {
                                _maxContentWidth = value;
                              });
                            },
                            activeColor: Color(0xFF18181B),
                            inactiveColor: Color(0xFFE4E4E7),
                          ),
                        ),
                        SizedBox(height: 24),

                        // 页面边距
                        Text(
                          '页面边距',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: _textColor,
                          ),
                        ),
                        SizedBox(height: 8),
                        SliderTheme(
                          data: SliderThemeData(
                            trackHeight: 4,
                            thumbShape: RoundSliderThumbShape(
                              enabledThumbRadius: 6,
                            ),
                            overlayShape: RoundSliderOverlayShape(
                              overlayRadius: 14,
                            ),
                          ),
                          child: Slider(
                            value: _horizontalPadding,
                            min: 40,
                            max: 300,
                            onChanged: (value) {
                              setState(() {
                                _horizontalPadding = value;
                              });
                            },
                            activeColor: Color(0xFF18181B),
                            inactiveColor: Color(0xFFE4E4E7),
                          ),
                        ),
                        SizedBox(height: 24),

                        // 主题选择
                        Text(
                          '主题',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: _textColor,
                          ),
                        ),
                        SizedBox(height: 16),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            _buildThemeButton(
                              bgColor: Color(0xFFF8F9FA),
                              textColor: Color(0xFF1A1D1E),
                              isSelected: _bgColor == Color(0xFFF8F9FA),
                              label: '浅色',
                            ),
                            _buildThemeButton(
                              bgColor: Color(0xFFFEF3C7),
                              textColor: Color(0xFF78350F),
                              isSelected: _bgColor == Color(0xFFFEF3C7),
                              label: '纸质',
                            ),
                            _buildThemeButton(
                              bgColor: Color(0xFF18181B),
                              textColor: Color(0xFFE4E4E7),
                              isSelected: _bgColor == Color(0xFF18181B),
                              label: '深色',
                            ),
                            _buildThemeButton(
                              bgColor: Color(0xFFE7F5FF),
                              textColor: Color(0xFF0A4979),
                              isSelected: _bgColor == Color(0xFFE7F5FF),
                              label: '蓝色',
                            ),
                          ],
                        ),
                        SizedBox(height: 24),

                        // 字体选择
                        Text(
                          '字体',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: _textColor,
                          ),
                        ),
                        SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildFontButton(
                              'System',
                              isSelected: _fontFamily == 'System',
                            ),
                            _buildFontButton(
                              'serif',
                              isSelected: _fontFamily == 'serif',
                            ),
                            _buildFontButton(
                              'monospace',
                              isSelected: _fontFamily == 'monospace',
                            ),
                            _buildFontButton(
                              'PingFang SC',
                              isSelected: _fontFamily == 'PingFang SC',
                            ),
                            _buildFontButton(
                              'Helvetica Neue',
                              isSelected: _fontFamily == 'Helvetica Neue',
                            ),
                          ],
                        ),
                        SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildThemeButton({
    required Color bgColor,
    required Color textColor,
    required bool isSelected,
    required String label,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _bgColor = bgColor;
          _textColor = textColor;
        });
      },
      child: Container(
        width: 80,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Color(0xFF18181B) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Text(
              'Aa',
              style: TextStyle(
                color: textColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(label, style: TextStyle(color: textColor, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildFontButton(String fontName, {required bool isSelected}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _fontFamily = fontName;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF18181B) : Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          fontName,
          style: TextStyle(
            fontFamily: fontName,
            color: isSelected ? Colors.white : Colors.black,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

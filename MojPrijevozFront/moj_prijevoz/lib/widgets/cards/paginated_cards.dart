import 'package:flutter/material.dart';
import 'package:moj_prijevoz/common/mp_build_context_extension.dart';
import 'package:moj_prijevoz/common/providers/base_provider.dart';
import 'package:moj_prijevoz/common/resources/search_result.dart';
import 'package:moj_prijevoz/common/resources/search_objects/base_search_object.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';
import 'package:moj_prijevoz/widgets/cards/mp_card.dart';
import 'package:moj_prijevoz/common/widgets/texts/text_widgets.dart';
import 'package:moj_prijevoz/common/wrappers/load_until_ready_wrapper.dart';
import 'package:provider/provider.dart';

class PaginatedCards<
  TSearchObject extends BaseSearchObject,
  TResponse extends JsonResponse,
  TProvider extends BaseGetProvider<TResponse, TSearchObject>
>
    extends StatefulWidget {
  final TSearchObject searchObject;
  final void Function(TResponse?) onTap;
  final void Function(TResponse)? onLongPress;
  final void Function(TResponse)? onSecondaryTap;
  final List<Widget> Function(TResponse) children;
  final String Function(TResponse)? banner;
  final EdgeInsetsGeometry? padding;
  final String fallbackText;
  final PageController? pageController;

  final double? spacing;
  final MainAxisSize? mainAxisSize;
  final MainAxisAlignment? mainAxisAlignment;

  const PaginatedCards({
    super.key,
    required this.searchObject,
    required this.onTap,
    this.onLongPress,
    this.onSecondaryTap,
    required this.children,
    this.padding,
    required this.fallbackText,
    this.banner,
    this.spacing,
    this.mainAxisSize,
    this.mainAxisAlignment,
    this.pageController,
  });

  @override
  State<StatefulWidget> createState() =>
      _PaginatedCardsState<TSearchObject, TResponse, TProvider>();
}

class _PaginatedCardsState<
  TSearchObject extends BaseSearchObject,
  TResponse extends JsonResponse,
  TProvider extends BaseGetProvider<TResponse, TSearchObject>
>
    extends State<PaginatedCards<TSearchObject, TResponse, TProvider>> {
  final PageController _pageController = PageController(viewportFraction: 0.7);
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return LoadUntilReadyWrapper(buildFunction: _build, futureFunction: _init);
  }

  @override
  void dispose() {
    widget.pageController?.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<bool> _init() async {
    await context.read<TProvider>().fetchData(widget.searchObject);
    return true;
  }

  Future<void> _onPageChanged(
    int value,
    SearchResult<TResponse> searchResult,
  ) async {
    if (searchResult.items.isNotEmpty &&
        value ==
            widget.searchObject.pageSize * (widget.searchObject.page - 1) - 1 &&
        searchResult.hasMore) {
      await context.read<TProvider>().fetchData(widget.searchObject);
    }
    if (!mounted) return;
    setState(() {
      _currentPage = value;
    });
  }

  Widget _build(BuildContext context) {
    late Widget child;
    final searchResult = context.watch<TProvider>().searchResult;
    if (searchResult.items.isEmpty) {
      child = Center(child: TextTitleMedium(widget.fallbackText));
    } else {
      child = Column(
        children: [
          Flexible(
            fit: FlexFit.loose,
            child: PageView(
              controller: widget.pageController ?? _pageController,
              onPageChanged: (index) => _onPageChanged(index, searchResult),
              children: searchResult.items
                  .map((i) => _buildCard(context, i))
                  .toList(),
            ),
          ),
          SizedBox(height: 4),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(searchResult.items.length, (i) {
                final isActive = i == _currentPage;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: isActive ? 12 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isActive ? context.primaryColor : Colors.grey,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          ),
        ],
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(constraints: constraints, child: child);
      },
    );
  }

  Widget _buildCard(BuildContext context, TResponse i) {
    Widget child = MpCard(
      onTap: () => widget.onTap.call(i),
      onLongPress: () => widget.onLongPress?.call(i),
      onSecondaryTap: () => widget.onSecondaryTap?.call(i),
      padding: widget.padding,
      spacing: widget.spacing,
      mainAxisSize: widget.mainAxisSize,
      mainAxisAlignment: widget.mainAxisAlignment,
      children: widget.children.call(i),
    );
    if (widget.banner != null) {
      return Banner(
        color: context.primaryColor,
        message: widget.banner!.call(i),
        location: BannerLocation.topEnd,
        child: child,
      );
    }
    return child;
  }
}

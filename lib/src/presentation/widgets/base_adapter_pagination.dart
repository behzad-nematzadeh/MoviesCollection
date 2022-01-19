import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BaseAdapterPagination<T> extends StatefulWidget {
  final List<T>? items;
  final bool isLastPage;
  final bool isLoading;
  final bool Function() isRetryingNextPage;
  final bool isNetworkConnected;

  final void Function() onLoadNextPage;
  final Widget Function(BuildContext context, int index) onBuildItem;
  final Widget? footer;
  final VoidCallback Function(List<T> items)? onRefreshFooter;
  final VoidCallback onReloadItems;
  final void Function(bool isRetryingNextPage) onRetryLoadNextPage;

  const BaseAdapterPagination({
    required Key? key,
    required this.items,
    required this.isLastPage,
    required this.isLoading,
    required this.isRetryingNextPage,
    required this.isNetworkConnected,
    required this.onLoadNextPage,
    required this.onBuildItem,
    this.footer,
    this.onRefreshFooter,
    required this.onReloadItems,
    required this.onRetryLoadNextPage,
  });

  @override
  _BaseAdapterPaginationState createState() => _BaseAdapterPaginationState<T>();
}

class _BaseAdapterPaginationState<T> extends State<BaseAdapterPagination> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Theme.of(context).backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Visibility(
            visible: !widget.isNetworkConnected,
            child: Container(
              padding: const EdgeInsets.all(12.0),
              color: Colors.red,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.wifi_off, color: Colors.white, size: 16),
                  const SizedBox(width: 10),
                  Text(
                    'Check Network Connection',
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: widget.items!.isEmpty,
            child: Flexible(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.search_off, size: 100, color: Colors.white,),
                    const SizedBox(height: 15),
                    Text(
                      'Not Found Item',
                      style: TextStyle(color: Colors.white)
                    ),
                  ],
                ),
              ),
            ),
          ),
          Visibility(
            visible: widget.items!.isNotEmpty,
            child: Flexible(
              child: RefreshIndicator(
                color: Colors.black,
                backgroundColor: Colors.white,
                onRefresh: () async => widget.onReloadItems(),
                child: NotificationListener<ScrollNotification>(
                  onNotification: _handleScrollNotification,
                  child: ListView.builder(
                    //key: PageStorageKey<String>('controllerA'),
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: _scrollController,
                    itemBuilder: (context, index) {
                      if (index < widget.items!.length) {
                        return widget.onBuildItem(context, index);
                      } else if (!widget.isLastPage) {
                        //after 30 milliseconds goes to end
                        Timer(
                          const Duration(milliseconds: 30),
                          () {
                            _scrollController.jumpTo(
                                _scrollController.position.maxScrollExtent);
                          },
                        );

                        if (widget.isRetryingNextPage()) {
                          return _retrying(false);
                        } else {
                          return _loadingIndicator();
                        }
                      }
                      return const SizedBox.shrink();
                    },
                    itemCount: widget.items!.length +
                        ((widget.isLoading || widget.isRetryingNextPage())
                            ? 1
                            : 0),
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: widget.footer != null,
            child: widget.footer != null
                ? widget.footer!
                : const SizedBox.shrink(),
          )
        ],
      ),
    );
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification &&
        _scrollController.position.extentAfter == 0 &&
        !widget.isLastPage &&
        !widget.isRetryingNextPage()) {
      widget.onLoadNextPage();
    }

    return false;
  }

  Widget _loadingIndicator() {
    return Center(
      child: Container(
          padding: const EdgeInsets.all(16.0),
          height: 50,
          width: 50,
          child: const CircularProgressIndicator()),
    );
  }

  _retrying([bool isReloadData = true]) {
    return Center(
      child: SizedBox(
        height: 50,
        width: 160,
        child: InkWell(
          onTap: () {
            if (isReloadData) {
              widget.onReloadItems();
            } else {
              widget.onRetryLoadNextPage(false);
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.refresh, color: Colors.red, size: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Retry',
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

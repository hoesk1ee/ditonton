import 'package:core/core.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tv_series/tv_series.dart';

class WatchlistTvSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = 'watchlist-tv-series';

  const WatchlistTvSeriesPage({Key? key}) : super(key: key);

  @override
  State<WatchlistTvSeriesPage> createState() => _WatchlistTvSeriesPageState();
}

class _WatchlistTvSeriesPageState extends State<WatchlistTvSeriesPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<WatchlistTvSeriesNotifier>(
        context,
        listen: false,
      ).fetchWatchlistTvSeries(),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  void didPopNext() {
    Provider.of<WatchlistTvSeriesNotifier>(
      context,
      listen: false,
    ).fetchWatchlistTvSeries();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tv Series Watchlist')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<WatchlistTvSeriesNotifier>(
          builder: (context, data, child) {
            if (data.watchlistState == RequestState.Loading) {
              return Center(child: CircularProgressIndicator());
            } else if (data.watchlistState == RequestState.Loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = data.watchlistTvSeries[index];
                  return TvSeriesCardList(movie);
                },
                itemCount: data.watchlistTvSeries.length,
              );
            } else {
              return Center(
                key: Key('error_message'),
                child: Text(data.message),
              );
            }
          },
        ),
      ),
    );
  }
}

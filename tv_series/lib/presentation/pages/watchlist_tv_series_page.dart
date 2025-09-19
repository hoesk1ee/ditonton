import 'package:core/core.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tv_series/presentation/bloc/watchlist_tv_series/watchlist_tv_series_bloc.dart';
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
      () => context.read<WatchlistTvSeriesBloc>().add(FetchTvSeriesWatchlist()),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  // ignore: annotate_overrides
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
        child: BlocBuilder<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
          builder: (context, state) {
            if (state is WatchlistTvSeriesLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is WatchlistTvSeriesEmpty) {
              return Center(child: Text(state.message));
            } else if (state is WatchlistTvSeriesHasError) {
              return Center(
                key: Key('error_message'),
                child: Text(state.message),
              );
            } else if (state is WatchlistTvSeriesHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = state.tvSeries[index];
                  return TvSeriesCardList(movie);
                },
                itemCount: state.tvSeries.length,
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}

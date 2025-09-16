import 'package:core/core.dart';
import 'package:core/presentation/widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search/presentation/bloc/tv_series/tv_series_search_bloc.dart';

class SearchTvSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = "/search-tv-series";

  const SearchTvSeriesPage({Key? key}) : super(key: key);

  @override
  State<SearchTvSeriesPage> createState() => _SearchTvSeriesPageState();
}

class _SearchTvSeriesPageState extends State<SearchTvSeriesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (query) {
                context.read<TvSeriesSearchBloc>().add(OnQueryChanged(query));
              },
              decoration: InputDecoration(
                hintText: 'Search tv series name',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            SizedBox(height: 16),
            Text('Search Result', style: kHeading6),
            BlocBuilder<TvSeriesSearchBloc, TvSeriesSearchState>(
              builder: (context, state) {
                if (state is TvSeriesSearchInitial) {
                  return Expanded(
                    child: Center(
                      child: Text("Type in search box to find your TV Series!"),
                    ),
                  );
                } else if (state is TvSeriesSearchLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is TvSeriesSearchHasError) {
                  return Expanded(child: Center(child: Text(state.message)));
                } else if (state is TvSeriesSearchEmpty) {
                  return Expanded(child: Center(child: Text(state.message)));
                } else if (state is TvSeriesSearchHasData) {
                  final result = state.result;
                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (context, index) {
                        final tvSerial = result[index];
                        return TvSeriesCardList(tvSerial);
                      },
                      itemCount: result.length,
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:core/core.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/presentation/widgets/movie_card_list.dart';
import 'package:search/presentation/bloc/search/search_bloc.dart';

class SearchPage extends StatelessWidget {
  static const ROUTE_NAME = '/search';

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
                context.read<SearchBloc>().add(OnQueryChanged(query));
              },
              decoration: InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            SizedBox(height: 16),
            Text('Search Result', style: kHeading6),
            BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                if (state is SearchLoading) {
                  return Center(child: const CircularProgressIndicator());
                } else if (state is SearchHasData) {
                  final result = state.result;

                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (context, index) {
                        final movie = result[index];
                        return MovieCard(movie);
                      },
                      itemCount: result.length,
                    ),
                  );
                } else if (state is SearchError) {
                  return Expanded(child: Center(child: Text(state.message)));
                } else if (state is SearchEmpty) {
                  return Expanded(child: Center(child: Text("No Movie found")));
                } else if (state is SearchInitial) {
                  return Expanded(
                    child: Center(
                      child: Text(
                        "Start find your Movies by typing in the search box!",
                      ),
                    ),
                  );
                } else {
                  return Expanded(child: Container());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

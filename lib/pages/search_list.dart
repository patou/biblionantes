import 'package:biblionantes/bloc/search_book/search_book_bloc.dart';
import 'package:biblionantes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:biblionantes/widgets/book_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';

class SearchList extends StatefulWidget {
  const SearchList({Key? key}) : super(key: key);

  @override
  SearchListState createState() => SearchListState();
}

class SearchListState extends State<SearchList> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  late SearchBookBloc searchBookBloc;

  Widget _displayResultList() {
    return BlocBuilder<SearchBookBloc, SearchBookState>(
      builder: (context, state) {
        if (state is SearchBookErrorState) {
          return const Center(
            child: Text('An error occurred'),
          );
        }

        if (state is SearchBookLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is SearchBookWelcomeState) {
          return const Center(
            child: Text('Recherchez un livre'),
          );
        }

        if (state is SearchBookNotFoundState) {
          return const Center(
            child: Text('Pas de résultats trouvés'),
          );
        }

        if (state is SearchBookSucessState) {
          if (state.books.isEmpty) {
            return const Center(
              child: Text('Pas de résultats trouvés'),
            );
          }
          return Expanded(
              // wrap in Expanded
              child: ListView.builder(
            itemCount: state.hasReachedMax
                ? state.books.length
                : state.books.length + 1,
            scrollDirection: Axis.vertical,
            controller: _scrollController,
            shrinkWrap: true,
            itemBuilder: (_, index) {
              return index >= state.books.length
                  ? const BottomLoader()
                  : Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: GestureDetector(
                          onTap: () => context.pushRoute(DetailRoute(
                              id: state.books[index].id, action: 'reserve')),
                          child: BookCard(
                            book: state.books[index],
                            widget: available(state.books[index].available),
                          )),
                    );
            },
          ));
        }
        return const Center(
          child: Text('Erreur state not exist'),
        );
      },
    );
  }

  Widget? available(bool? available) {
    if (available != null) {
      return Text(
        available ? 'Disponible' : 'Non disponible',
        style: TextStyle(color: available ? Colors.green : Colors.red),
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return _displayResultList();
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    searchBookBloc = context.read<SearchBookBloc>();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      var state = searchBookBloc.state;
      if (state is SearchBookSucessState) {
        searchBookBloc.add(SearchBookLoadNext());
      }
    }
  }
}

class BottomLoader extends StatelessWidget {
  const BottomLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: const Center(
        child: SizedBox(
          width: 33,
          height: 33,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
          ),
        ),
      ),
    );
  }
}

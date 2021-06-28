import 'package:biblionantes/bloc/search_book/search_book_bloc.dart';
import 'package:flutter/material.dart';
import 'package:biblionantes/widgets/book_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchList extends StatefulWidget {
  SearchList();

  @override
  _SearchListState createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  late SearchBookBloc searchBookBloc;

  Widget _displayResultList() {
    return BlocBuilder<SearchBookBloc, SearchBookState>(
      builder: (context, state) {
        if (state is SearchBookErrorState) {
          return Center(
            child: Text('An error occurred'),
          );
        }

        if (state is SearchBookLoadingState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is SearchBookWelcomeState) {
          return Center(
            child: Text('Recherchez un livre'),
          );
        }

        if (state is SearchBookNotFoundState) {
          return Center(
            child: Text('Pas de résultats trouvés'),
          );
        }

        if (state is SearchBookSucessState) {
          if (state.books.isEmpty) {
            return Center(
              child: Text('Pas de résultats trouvés'),
            );
          }
          return Expanded( // wrap in Expanded
              child: ListView.builder(
                itemCount: state.hasReachedMax ? state.books.length : state.books.length + 1,
                scrollDirection: Axis.vertical,
                controller: _scrollController,
                shrinkWrap: true,
                itemBuilder: (_, index) {
                  return  index >= state.books.length
                      ? BottomLoader()
                      : Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: BookCard(book: state.books[index], widget: available(state.books[index].available),),
                  );
                },
              )
          );
        }
        return Center(
          child: Text('Erreur state not exist'),
        );
      },
    );

  }

  Widget? available(bool? available) {
    if (available != null) {
      return Text(available ? 'Disponible' : 'Non disponible', style: TextStyle(color: available ? Colors.green : Colors.red),);
    }
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
        searchBookBloc.add(
            SearchBookLoadNext());
      }
    }
  }
}

class BottomLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Center(
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
import 'package:biblionantes/repositories/search.dart';
import 'package:biblionantes/search_book/search_book_bloc.dart';
import 'package:flutter/material.dart';
import 'package:biblionantes/widgets/book_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPageStateful extends StatefulWidget {
  final SearchRepository searchRepository;

  SearchPageStateful({required this.searchRepository});

  @override
  _SearchPageStatefulState createState() => _SearchPageStatefulState();
}

class _SearchPageStatefulState extends State<SearchPageStateful> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  late SearchBookBloc searchBookBloc;

  Widget _displayResultList() {
    return BlocBuilder(
      bloc: searchBookBloc,
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
                    child: BookCard(book: state.books[index]),
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

  Widget _renderSearchField() {
    return SearchWidget(onSearch: (search) {
      searchBookBloc.add(SearchBookTextSearched(search: search));
    }, onClear: () {
      searchBookBloc.add(SearchBookTextCleared());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recherche de livre'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            _renderSearchField(),
            SizedBox(height: 20),
            _displayResultList(),
          ])
      )
    );
  }

  @override
  void initState() {
    super.initState();
    searchBookBloc = SearchBookBloc(searchRepository: widget.searchRepository);
    _scrollController.addListener(_onScroll);
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

class SearchWidget extends StatefulWidget {

  void Function(String) onSearch;
  void Function() onClear;
  @override
  _SearchWidgetState createState() => _SearchWidgetState();

  SearchWidget({Key? key, required this.onSearch, required this.onClear}) : super(key: key);
}

class _SearchWidgetState extends State<SearchWidget> {
  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onSubmitted: (search) {
        widget.onSearch(search);
      },
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search),
        suffixIcon: _controller.text.length > 0
            ? GestureDetector(
          onTap: () {
            _controller.clear();
            widget.onClear();
          }, // removes the content in the field
          child: Icon(Icons.clear_rounded),
        )
            : null,
      ),
    );
  }

  @override
  void initState() {
    _controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
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
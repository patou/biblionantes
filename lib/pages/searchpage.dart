import 'package:biblionantes/models/book.dart';
import 'package:biblionantes/repositories/search.dart';
import 'package:flutter/material.dart';
import 'package:biblionantes/widgets/book_card.dart';

class SearchPageStateful extends StatefulWidget {
  final SearchRepository searchRepository;

  SearchPageStateful({@required this.searchRepository})
      : assert(searchRepository != null);

  @override
  _SearchPageStatefulState createState() => _SearchPageStatefulState();
}

class _SearchPageStatefulState extends State<SearchPageStateful> {
  List<Book> _books;
  bool _isError = false;
  bool _isLoading = false;
  bool _isSearch = false;


  Widget _displayResultList() {
    if (_isError) {
      return Center(
        child: Text('An error occurred'),
      );
    }

    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (!_isSearch) {
      return Center(
        child: Text('Recherchez un livre'),
      );
    }

    if (_books.isEmpty) {
      return Center(
        child: Text('Pas de résultats trouvés'),
      );
    }

    return Expanded( // wrap in Expanded
        child: ListView.builder(
          itemCount: _books.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (_, index) {
            return Container(
              margin: EdgeInsets.only(bottom: 10),
              child: BookCard(book: _books[index]),
            );
          },
        )
    );
  }

  Widget _renderSearchField() {
    return SearchWidget(onSearch: (search) {
      _fetchSearch(search);
    }, onClear: () {
      setState(() {
        _isError = false;
        _isLoading = false;
        _isSearch = false;
        _books = null;
      });
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

  void _fetchSearch(String search) async {
    setState(() {
      _isError = false;
      _isLoading = true;
      _isSearch = true;
      _books = null;
    });
    try {
      final books = await widget.searchRepository.search(search);
      setState(() {
        _isError = false;
        _isLoading = false;
        _isSearch = true;
        _books = books;
      });
    } catch (e) {
      setState(() {
        _isError = true;
        _isLoading = false;
        _isSearch = false;
        _books = null;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }
}

class SearchWidget extends StatefulWidget {

  void Function(String) onSearch;
  void Function() onClear;
  @override
  _SearchWidgetState createState() => _SearchWidgetState();

  SearchWidget({Key key, void Function(String) this.onSearch, void Function() this.onClear}) : super(key: key);
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
}
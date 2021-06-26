import 'package:biblionantes/pages/search_list.dart';
import 'package:biblionantes/search_book/search_book_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchBookBloc>(
      create: (context) => SearchBookBloc(searchRepository: context.read()),
      child: Scaffold(
          appBar: AppBar(
            title: Text('Recherche de livre'),
            centerTitle: true,
          ),
          body: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                  children: [
                    SearchWidget(),
                    SizedBox(height: 20),
                    SearchList()
                  ])
          )
      ),
    );
  }
}

class SearchWidget extends StatefulWidget {

  @override
  _SearchWidgetState createState() => _SearchWidgetState();

  SearchWidget({Key? key}) : super(key: key);
}

class _SearchWidgetState extends State<SearchWidget> {
  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onSubmitted: (search) {
        context.read<SearchBookBloc>().add(SearchBookTextSearched(search: search));
      },
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search),
        suffixIcon: _controller.text.length > 0
            ? GestureDetector(
          onTap: () {
            _controller.clear();
            context.read<SearchBookBloc>().add(SearchBookTextCleared());
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
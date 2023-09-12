import 'package:auto_route/annotations.dart';
import 'package:biblionantes/bloc/search_book/search_book_bloc.dart';
import 'package:biblionantes/pages/search_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchBookBloc>(
      create: (context) => SearchBookBloc(searchRepository: context.read()),
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Recherche de livre'),
            centerTitle: true,
          ),
          body: const Padding(
              padding: EdgeInsets.all(20),
              child: Column(children: [
                SearchWidget(),
                SizedBox(height: 20),
                SearchListPage()
              ]))),
    );
  }
}

class SearchWidget extends StatefulWidget {
  @override
  SearchWidgetState createState() => SearchWidgetState();

  const SearchWidget({Key? key}) : super(key: key);
}

class SearchWidgetState extends State<SearchWidget> {
  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onSubmitted: (search) {
        context
            .read<SearchBookBloc>()
            .add(SearchBookTextSearched(search: search));
      },
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText: "Recherche par nom, auteur, ...",
        suffixIcon: _controller.text.isNotEmpty
            ? GestureDetector(
                onTap: () {
                  _controller.clear();
                  context.read<SearchBookBloc>().add(SearchBookTextCleared());
                }, // removes the content in the field
                child: const Icon(Icons.clear_rounded),
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

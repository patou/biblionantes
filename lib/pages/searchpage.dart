import 'package:flutter/material.dart';
import 'package:biblionantes/models/Beer.dart';
import 'package:biblionantes/repositories/beer_repository.dart';
import 'package:biblionantes/widgets/book_card.dart';

class SearchPageStateful extends StatefulWidget {
  final BeersRepository beersRepository;

  SearchPageStateful({@required this.beersRepository})
      : assert(beersRepository != null);

  @override
  _SearchPageStatefulState createState() => _SearchPageStatefulState();
}

class _SearchPageStatefulState extends State<SearchPageStateful> {
  List<Beer> _beers;
  bool _isError = false;
  bool _isLoading = true;

  Widget _displayBody() {
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

    return ListView.builder(
      itemCount: _beers.length,
      itemBuilder: (_, index) {
        return Container(
          margin: EdgeInsets.only(bottom: 10),
          child: BookCard(beer: _beers[index]),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Punk API'),
        centerTitle: true,
      ),
      body: _displayBody(),
    );
  }

  void _fetchBeers() async {
    try {
      final beers = await widget.beersRepository.getBeers();
      setState(() {
        _isError = false;
        _isLoading = false;
        _beers = beers;
      });
    } catch (e) {
      setState(() {
        _isError = true;
        _isLoading = false;
        _beers = null;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchBeers();
  }
}
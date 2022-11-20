// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:http/http.dart' as http;

// Project imports:
import 'package:infixedu/utils/CustomAppBarWidget.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/utils/model/Book.dart';
import 'package:infixedu/utils/widget/BookRowLayout.dart';

class BookListScreen extends StatefulWidget {
  @override
  _BookListState createState() => _BookListState();
}

class _BookListState extends State<BookListScreen> {
  Future<BookList> books;
  String _token;
  @override
  void initState() {
    super.initState();
    Utils.getStringValue('token').then((value) {
      setState(() {
        _token = value;
      });
    })
      ..then((value) {
        setState(() {
          books = getAllBooks();
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'Book List'),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<BookList>(
          future: books,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.books.length > 0) {
                return ListView.builder(
                  itemCount: snapshot.data.books.length,
                  itemBuilder: (context, index) {
                    return BookListRow(snapshot.data.books[index]);
                  },
                );
              } else {
                return Utils.noDataWidget();
              }
            } else {
              return Center(child: CupertinoActivityIndicator());
            }
          },
        ),
      ),
    );
  }

  Future<BookList> getAllBooks() async {
    final response = await http.get(Uri.parse(InfixApi.bookList),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      return BookList.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to load');
    }
  }
}

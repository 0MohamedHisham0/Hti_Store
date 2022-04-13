import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class SearchUsersScreen extends StatelessWidget {
  const SearchUsersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // The search area here
          title: Container(
            decoration: BoxDecoration(
              color: HexColor("CFCEDF"),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Wrap(children: [
              Container(
                decoration: BoxDecoration(
                    color: HexColor("CFCEDF"),
                    borderRadius: BorderRadius.circular(8)),
                child: Center(
                  child: TextField(
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            /* Clear the search field */
                          },
                        ),
                        hintText: 'بحث...',
                        border: InputBorder.none),
                  ),
                ),
              ),
            ]),
          )),
    );
  }
}

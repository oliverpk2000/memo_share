import 'package:flutter/material.dart';
import 'package:memo_share/pages/home.dart';

class FilterTag extends StatefulWidget {
  const FilterTag({super.key, required this.filterFunction});

  final Function filterFunction;

  @override
  State<FilterTag> createState() => _FilterTagState();
}

class _FilterTagState extends State<FilterTag> {
  String dropdownValue = tags.first;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      height: 400,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DropdownButton(
              value: dropdownValue,
              items: tags
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  dropdownValue = value!;
                });
              }),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: FloatingActionButton(
              onPressed: () {
                widget.filterFunction(dropdownValue);
                Navigator.pop(context);
              },
              backgroundColor: Colors.blueGrey,
              child: const Icon(
                Icons.filter_alt,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}

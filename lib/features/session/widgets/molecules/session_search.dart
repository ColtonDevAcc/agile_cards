import 'package:agile_cards/features/session/widgets/atoms/search_session_bottom_sheet.dart';
import 'package:flutter/material.dart';

class SearchButton extends StatelessWidget {
  const SearchButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.search),
      onPressed: () => showModalBottomSheet(
        context: context,
        builder: (context) => const SearchSessionBottomSheet(),
      ),
    );
  }
}

import 'package:agile_cards/pages/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:stacked_card_carousel/stacked_card_carousel.dart';

class AgileCardSelector extends StatelessWidget {
  const AgileCardSelector({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StackedCardCarousel(
      spaceBetweenItems: 200,
      items: [
        for (final shirt in tShirtSizes)
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
            child: Container(
              alignment: Alignment.center,
              width: 200,
              height: 200,
              child: Text(shirt),
            ),
          ),
      ],
    );
  }
}

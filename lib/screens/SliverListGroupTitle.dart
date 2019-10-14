import 'package:flutter/material.dart';
import 'package:hasskit/model/Entity.dart';
import 'package:hasskit/utils/Style.dart';

class SliverListGroupTitle extends StatelessWidget {
  const SliverListGroupTitle({@required this.entities, this.title});
  final List<Entity> entities;
  final String title;

  @override
  Widget build(BuildContext context) {
    if (entities.length < 1) {
      return SliverList(
        delegate: SliverChildListDelegate(
          [
            Container(),
          ],
        ),
      );
    }
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Container(
            padding: EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Text(
              title,
              style: Styles.textEntityGroupType,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

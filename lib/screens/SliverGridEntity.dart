import 'package:flutter/material.dart';
import 'package:hasskit/model/entity.dart';
import 'package:hasskit/model/provider_data.dart';

import 'EntityButton.dart';

class SliverGridEntity extends StatelessWidget {
  const SliverGridEntity(
      {@required this.entities,
      @required this.childAspectRatio,
      @required this.crossAxisCount});

  final List<Entity> entities;
  final int crossAxisCount;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    if (entities.length < 1) {
      return SliverList(
        delegate: SliverChildListDelegate(
          [Container()],
        ),
      );
    }
    return SliverPadding(
      padding: EdgeInsets.only(left: 12, right: 12),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 3,
          crossAxisSpacing: 3,
          childAspectRatio: childAspectRatio,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            var entity = entities[index];
            return EntityButton(
              entity: entities[index],
              onTapCallback: () {
                providerData.toggleStatus(entity);
              },
              onLongPressCallback: () {
                providerData.toggleStatus(entity);
              },
            );
          },
          childCount: entities.length,
        ),
      ),
    );
  }
}

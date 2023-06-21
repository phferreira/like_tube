import 'package:flutter/material.dart';
import 'package:like_tube/app/core/types/query_type.dart';

import 'package:like_tube/app/modules/home/presenter/widgets/video_item_widget.dart';

class GridListsWidget extends StatefulWidget {
  final ListVideo gridList;

  const GridListsWidget({
    super.key,
    required this.gridList,
  });

  @override
  _GridListsWidgetState createState() => _GridListsWidgetState();
}

class _GridListsWidgetState extends State<GridListsWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: GridView.builder(
        itemCount: widget.gridList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          mainAxisSpacing: 10,
          crossAxisSpacing: 20,
        ),
        itemBuilder: (context, index) => VideoItemWidget(
          video: widget.gridList[index],
        ),
      ),
    );
  }
}

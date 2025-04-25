
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecommendedCard extends StatelessWidget {
  const RecommendedCard({Key? key, required this.index}) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16)),
              child: Image.network(
                'https://cetide-1325039295.cos.ap-chengdu.myqcloud.com/dfc2e3e1-2c63-44b3-8fee-1990d564a10c.jpeg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'User $index发布了一个动态',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '时间：10:00 AM',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
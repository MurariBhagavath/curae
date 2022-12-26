import 'package:curae/components/size_components.dart';
import 'package:curae/styles.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10, top: 2),
      width: double.infinity,
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: primaryTextColor,
            radius: 26,
            child: FaIcon(icon),
          ),
          buildWidth(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title),
                Text(
                  subtitle,
                  style: TextStyle(color: secondaryTextColor),
                  softWrap: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

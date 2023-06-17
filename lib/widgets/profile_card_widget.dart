import 'package:flutter/material.dart';

class ProfileCardWidget extends StatelessWidget {
  const ProfileCardWidget({
    Key? key,
    required this.title,
    required this.icon,
    this.endIcon = Icons.edit,
    required this.onPress,
    this.isEndIcon = true,
    this.textColor,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final IconData endIcon;
  final VoidCallback onPress;
  final bool isEndIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).focusColor,
      ),
      child: ListTile(
        onTap: onPress,
        leading: Icon(icon, color: isEndIcon? Theme.of(context).primaryColor : Colors.red),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.apply(color: textColor)
        ),
        trailing: isEndIcon ? Icon(endIcon) : null,
      ),
    );
  }
}
import 'package:flutter/material.dart';

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.blue.withOpacity(0.1),
      ),
      child: ListTile(
        onTap: onPress,
        leading: Icon(icon, color: Colors.blueAccent),
        title: Text(title,
            style:
            Theme.of(context).textTheme.bodyLarge?.apply(color: textColor)),
        trailing: endIcon
            ? const Icon(Icons.edit)
            : null,
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:provider/provider.dart';

import '../../provider/my_provider.dart';

import '../sign/log_screen.dart';

class Profile extends StatefulWidget {
  const Profile({
    Key? key,
  }) : super(key: key);

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((_) =>
    //     Provider.of<MyPro>(context, listen: false).;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Consumer<MyPro>(
      builder: (ctx, val, _) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.01, vertical: size.height * 0.02),
              child: Column(children: [
                SizedBox(
                  width: size.width * 0.5,
                  height: size.height * 0.3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: SvgPicture.asset('assets/images/login.svg'),
                  )
                ),
                SizedBox(height: size.height * 0.02),
                Text("User Name", style: Theme.of(context).textTheme.headlineSmall),

                SizedBox(height: size.height * 0.02),

                ProfileMenuWidget(
                  title: "Email",
                  icon: Icons.mail,
                  onPress: () {},
                ),
                ProfileMenuWidget(
                  title: "Emergency Contact",
                  icon: Icons.phone,
                  onPress: () {},
                ),

                ProfileMenuWidget(
                  title: "Password",
                  icon: Icons.lock_outline,
                  onPress: () {},
                ),

                const Divider(),
                SizedBox(height: size.height * 0.02),

                ProfileMenuWidget(
                  title: "Logout",
                  icon: Icons.logout,
                  endIcon: false,
                  textColor: Colors.red,
                  onPress: () {
                    val.logout();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => const LogScreen()));
                  },
                ),

                const Divider(),
                SizedBox(height: size.height * 0.02),

                ProfileMenuWidget(
                  title: "Remove Account",
                  icon: Icons.delete,
                  endIcon: false,
                  textColor: Colors.red,
                  onPress: () {
                    val.logout();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => const LogScreen()));
                  },
                ),
              ]),
            ),
          ),
        );
      }
    );
  }
}

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
    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 48,
        height: 0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.blue.withOpacity(0.1),
        ),
        child: Icon(icon, color: Colors.blueAccent),
      ),
      title: Text(title,
          style:
              Theme.of(context).textTheme.bodyLarge?.apply(color: textColor)),
      trailing: endIcon
          ? Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(300),
                color: Colors.grey.withOpacity(0.1),
              ),
              child: const Icon(Icons.chevron_right,
                  size: 18.0, color: Colors.grey))
          : null,
    );
  }
}

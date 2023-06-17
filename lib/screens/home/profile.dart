import 'package:app2m/screens/sign/log_screen.dart';
import 'package:app2m/widgets/alert_confirm.dart';
import 'package:app2m/widgets/dialog_edit_mail.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../provider/my_provider.dart';

import '../../widgets/dialog_edit_password.dart';
import '../../widgets/dialog_edit_phone.dart';
import '../../widgets/profile_card_widget.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {



  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Consumer<MyPro>(
      builder: (ctx, val, _) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(size.height * 0.02),
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.03),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () => val.toggleIsDark(),
                        icon: Icon(val.isDark?
                            Icons.light_mode :Icons.dark_mode,
                          color: Theme.of(context).shadowColor,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: size.height * 0.02),

                  SizedBox(
                      width: size.height * 0.25,
                      height: size.height * 0.25,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Hero(
                            tag: val.user.userName,
                            child: Image.asset('assets/images/old_avatar.jpg', fit: BoxFit.cover,)),
                      )
                  ),

                  SizedBox(height: size.height * 0.01),
                  Text(val.user.userName, style: Theme.of(context).textTheme.titleLarge),
                  SizedBox(height: size.height * 0.02),

                  ProfileCardWidget(
                    title: val.user.email,
                    icon: Icons.mail,
                    onPress: () {
                      showDialog(context: context, builder: (_) => EditMailWidget());
                    },
                  ),

                  ProfileCardWidget(
                    title: val.user.userPN,
                    icon: Icons.phone,
                    endIcon: Icons.arrow_forward_ios,
                    onPress: () {
                      showDialog(context: context, builder: (_) => EditPhoneWidget());
                    },
                  ),

                  ProfileCardWidget(
                    title: "Password",
                    icon: Icons.lock_outline,
                    onPress: () {
                      showDialog(context: context, builder: (_) => EditPasswordWidget());
                    },
                  ),

                  const Divider(thickness: 1),

                  ProfileCardWidget(
                    title: "Logout",
                    icon: Icons.logout,
                    isEndIcon: false,
                    textColor: Colors.red,
                    onPress: () {
                      showDialog(context: context, builder: (_) => AlertConfirmWidget(
                          title: 'Logout', onPress: (){
                        Navigator.pop(context);
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => const LogScreen()));
                        val.logout();
                        val.toast(context, "You Have Logged Out", isRed: true);
                        val.moveIndex(0);
                      }));
                    },
                  ),

                  const Divider(thickness: 1,),

                  ProfileCardWidget(
                    title: "Remove Account",
                    icon: Icons.delete,
                    isEndIcon: false,
                    textColor: Colors.red,
                    onPress: () {
                      showDialog(context: context, builder: (_) => AlertConfirmWidget(title: 'Remove Account', onPress: (){
                        Navigator.pop(context);
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => const LogScreen()));
                        val.deleteUser();
                        val.toast(context, "Account Has Removed", isRed: true);
                        val.moveIndex(0);
                      }));
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
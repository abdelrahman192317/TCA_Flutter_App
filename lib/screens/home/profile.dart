import 'package:app2m/widgets/dialog_edit_profile.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../provider/my_provider.dart';

import '../../widgets/profile_card_widget.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);



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
                  SizedBox(height: size.height * 0.04),

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

                  ProfileMenuWidget(
                    title: val.user.email,
                    icon: Icons.mail,
                    onPress: () {
                      showDialog(
                          context: context,
                          builder: (_) => EditWidget(
                            title: 'Email',
                            type: 0,
                            icon: const Icon(Icons.mail),
                            textInputType: TextInputType.emailAddress,
                      ));
                    },
                  ),
                  ProfileMenuWidget(
                    title: val.user.userPN,
                    icon: Icons.phone,
                    onPress: () {
                      showDialog(
                          context: context,
                          builder: (_) => EditWidget(
                            title: 'Emergency Contact',
                            type: 1,
                            icon: const Icon(Icons.phone),
                            textInputType: TextInputType.phone,
                      ));
                    },
                  ),

                  ProfileMenuWidget(
                    title: "Password",
                    icon: Icons.lock_outline,
                    onPress: () {
                      showDialog(
                        context: context,
                        builder: (_) => EditWidget(
                          title: 'Password',
                          type: 2,
                          icon: const Icon(Icons.lock),
                          textInputType: TextInputType.visiblePassword,
                        )
                      );
                    },
                  ),

                  const Divider(thickness: 1),

                  ProfileMenuWidget(
                    title: "Logout",
                    icon: Icons.logout,
                    endIcon: false,
                    textColor: Colors.red,
                    onPress: () {
                      showDialog(
                          context: context,
                          builder: (_) => EditWidget(title: 'Logout', type: 3));
                    },
                  ),

                  const Divider(thickness: 1,),

                  ProfileMenuWidget(
                    title: "Remove Account",
                    icon: Icons.delete,
                    endIcon: false,
                    textColor: Colors.red,
                    onPress: () {
                      showDialog(
                          context: context,
                          builder: (_) => EditWidget(title: 'Remove Account', type: 4,
                      ));
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

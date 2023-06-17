import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:provider/provider.dart';

import 'package:app2m/provider/my_provider.dart';



class EditPasswordWidget extends StatelessWidget {

  EditPasswordWidget({Key? key}) : super(key: key);

  final _oldPassController = TextEditingController();
  final _newPassController = TextEditingController();
  final _confirmPassController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context){
    final size = MediaQuery.of(context).size;

    return Consumer<MyPro> (
      builder: (ctx, val, child) => WillPopScope(
        onWillPop: () async {
          val.reset();
          return true;
        },
        child: Dialog(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(size.height * 0.02),
            child: Form(
              key: _formKey,
              child: val.forget?
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('You Received an Email With Reset Password Way', softWrap: true,style: Theme.of(context).textTheme.titleLarge,textAlign: TextAlign.center,),

                  SizedBox(height: size.height * 0.02,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          val.reset();
                          Navigator.pop(context);
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                ],
              ) :
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Edit Your Password', style: Theme.of(context).textTheme.titleLarge),
                  SizedBox(height: size.height * 0.02,),

                  //Old Password
                  TextFormField(
                    controller: _oldPassController,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15))),
                        labelText: 'Old Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        hintText: 'Enter Your Old Password',
                        suffixIcon: IconButton(
                            onPressed: () => val.toggleOldObscureText(),
                            icon: Icon(val.oldObscureText? CupertinoIcons.eye_solid : CupertinoIcons.eye_slash_fill)
                        )
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: val.oldObscureText,
                    validator: (value) => value == null || value.isEmpty ?
                    'Please enter the password' : value.length<6 ?
                    'the minimum length is 6 character': val.user.password != value ?
                    'Wrong Password' : null,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          val.toggleForget();
                          val.resetPw(val.user.email);
                        },
                        child: const Text('Forget Password'),
                      ),
                    ],
                  ),

                  SizedBox(height: size.height * 0.01,),

                  //new password
                  TextFormField(
                    controller: _newPassController,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15))),
                        labelText: 'New Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        hintText: 'Enter Your New Password',
                        suffixIcon: IconButton(
                            onPressed: () => val.toggleObscureText(),
                            icon: Icon(val.obscureText? CupertinoIcons.eye_solid : CupertinoIcons.eye_slash_fill)
                        )
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: val.obscureText,
                    validator: (value) => value == null || value.isEmpty ?
                    'Please enter the password' : value.length<6 ?
                    'the minimum length is 6 character': null,
                  ),

                  SizedBox(height: size.height * 0.02,),

                  //password
                  TextFormField(
                    controller: _confirmPassController,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15))),
                        labelText: 'Confirm Password',
                        hintText: 'Confirm Your New Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                            onPressed: () => val.toggleRegisterCObscureText(),
                            icon: Icon(val.registerCObscureText?
                            CupertinoIcons.eye_solid : CupertinoIcons.eye_slash_fill)
                        )
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: val.registerCObscureText,
                    validator: (value) => value == null || value.isEmpty ?
                    'Please confirm the password' : value.length < 6 ?
                    'the minimum length is 6 character' : _newPassController.text != value ?
                    'Password Not Match ' : null,
                  ),

                  SizedBox(height: size.height * 0.01),

                  if (val.errorMessage != null)
                    Text(val.errorMessage!,style: const TextStyle(color: Colors.red)),

                  SizedBox(height: size.height * 0.01),

                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
                          child: SizedBox(
                              height: size.height * 0.07,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  elevation: 0,
                                  backgroundColor: Theme.of(context).focusColor,
                                  foregroundColor: Theme.of(context).primaryColor,
                                ),
                                onPressed: () {
                                  val.reset();
                                  Navigator.pop(context);
                                },
                                child: const Text('cancel'),
                              )
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
                          child: SizedBox(
                            height: size.height * 0.07,
                            child: ElevatedButton(
                              onPressed: (){
                                if (_formKey.currentState!.validate()) {
                                  val.updatePass(_newPassController.text);
                                  val.reset();
                                  val.toast(context, "Password Changed Successfully");
                                  Navigator.pop(context);
                                }
                              },
                              child: const Text('Edit'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
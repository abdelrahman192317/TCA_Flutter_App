import 'package:app2m/screens/sign/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';

import 'package:provider/provider.dart';
import 'package:app2m/provider/my_provider.dart';

import 'log_screen.dart';
import '../home/home_screen.dart';
import '../../models/user_model.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emergencyContactController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _cPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emergencyContactController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _cPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Consumer<MyPro>(
        builder: (ctx, val, _) => WillPopScope(
          onWillPop: () async{
            val.reset();
            return true;
          },
          child: Scaffold(
            body: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: size.height * 0.02),

                    IconButton(
                      onPressed: (){
                        val.reset();
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => const LogScreen())
                        );
                      },
                      icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).shadowColor,),
                    ),
                    SizedBox(
                        height: size.height * 0.4,
                        width: size.width,
                        child: Lottie.asset('assets/lottie/register.json')
                    ),

                    Padding(
                      padding: EdgeInsets.all(size.height * 0.01),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //name
                            TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(15))
                                ),
                                labelText: 'Name',
                                labelStyle: Theme.of(context).textTheme.bodySmall,
                                prefixIcon: Icon(Icons.person, color: Theme.of(context).primaryColor,),
                              ),
                              keyboardType: TextInputType.name,
                              validator: (value) => value == null || value.isEmpty ? 'Please enter your name' : null,
                            ),

                            SizedBox(height: size.height * 0.02,),

                            //Emergency contact
                            TextFormField(
                              controller: _emergencyContactController,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(15))
                                ),
                                labelText: 'Emergency contact',
                                labelStyle: Theme.of(context).textTheme.bodySmall,
                                prefixIcon: Icon(Icons.phone, color: Theme.of(context).primaryColor,),
                              ),
                              keyboardType: TextInputType.phone,
                              validator: (value) => value == null || value.isEmpty ? 'Please enter your emergency contact' : null,
                            ),

                            SizedBox(height: size.height * 0.02,),

                            //mail
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(15))
                                ),
                                labelText: 'Email',
                                labelStyle: Theme.of(context).textTheme.bodySmall,
                                prefixIcon: Icon(Icons.mail, color: Theme.of(context).primaryColor,),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) => value == null || value.isEmpty ? 'Please enter your email' : null,
                            ),

                            SizedBox(height: size.height * 0.02,),

                            //password
                            TextFormField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                  border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(15))),
                                  labelText: 'Password',
                                  labelStyle: Theme.of(context).textTheme.bodySmall,
                                  prefixIcon: Icon(Icons.lock_outline, color: Theme.of(context).primaryColor,),
                                  suffixIcon: IconButton(
                                      onPressed: () => val.toggleObscureText(),
                                      icon: Icon(val.obscureText?
                                      CupertinoIcons.eye_solid : CupertinoIcons.eye_slash_fill
                                        , color: Theme.of(context).primaryColor,)
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
                              controller: _cPasswordController,
                              decoration: InputDecoration(
                                  border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(15))),
                                  labelText: 'Confirm Password',
                                  labelStyle: Theme.of(context).textTheme.bodySmall,
                                  prefixIcon: Icon(Icons.lock_outline, color: Theme.of(context).primaryColor,),
                                  suffixIcon: IconButton(
                                      onPressed: () => val.toggleRegisterCObscureText(),
                                      icon: Icon(val.registerCObscureText?
                                      CupertinoIcons.eye_solid : CupertinoIcons.eye_slash_fill
                                        , color: Theme.of(context).primaryColor,)
                                  )
                              ),
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: val.registerCObscureText,
                              validator: (value) => value == null || value.isEmpty ?
                              'Please confirm the password' : value.length<6 ?
                              'the minimum length is 6 character': null,
                            ),

                            SizedBox(height: size.height * 0.02,),

                            if (val.errorMessage != null)
                              Text(val.errorMessage!,
                                style: const TextStyle(color: Colors.red)
                              ),

                            SizedBox(height: size.height * 0.02,),

                            //register
                            SizedBox(
                              width: size.width,
                              height: size.height * 0.08,
                              child: ElevatedButton(
                                onPressed: val.isLoading ? null : (){
                                  if (_formKey.currentState!.validate()) {
                                    if(_passwordController.text == _cPasswordController.text){
                                      val.register(user: User(
                                          userName: _nameController.text,
                                          userPN: _emergencyContactController.text,
                                          email: _emailController.text,
                                          password: _passwordController.text
                                      )).then((value) {
                                        val.reset();
                                        Navigator.pushReplacement(context,
                                            MaterialPageRoute(builder: (
                                                context) => const HomeScreen()));
                                        val.toast(context, "Register Successfully");
                                      }).catchError((e){val.setErrorMessage(e.toString());});
                                    }else {
                                      val.setErrorMessage('password not match');
                                    }
                                  }
                                },
                                child: val.isLoading ? const CircularProgressIndicator() : const Text('Register'),
                              ),
                            ),


                            SizedBox(height: size.height * 0.02,),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('already have an account,'),
                                TextButton(onPressed: (){
                                  val.reset();
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context) => const LoginScreen()));
                                  }, child: const Text('login'))
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }
}

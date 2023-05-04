import 'package:app2m/screens/sign/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';

import 'package:provider/provider.dart';
import 'package:app2m/provider/my_provider.dart';

import 'log_screen.dart';
import '../home/home_screen.dart';
import '../../models/user_models.dart';

class SignScreen extends StatefulWidget {
  const SignScreen({Key? key}) : super(key: key);

  @override
  State<SignScreen> createState() => _SignScreenState();
}

class _SignScreenState extends State<SignScreen> {

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
        builder: (ctx, val, _) => Scaffold(
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height * 0.02),

                  IconButton(
                    onPressed: (){
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => const LogScreen())
                      );
                    },
                    icon: const Icon(Icons.arrow_back_ios),
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
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(15))
                              ),
                              labelText: 'Name',
                              prefixIcon: Icon(Icons.person),
                            ),
                            keyboardType: TextInputType.name,
                            validator: (value) => value == null || value.isEmpty ? 'Please enter your name' : null,
                          ),

                          SizedBox(height: size.height * 0.02,),

                          //Emergency contact
                          TextFormField(
                            controller: _emergencyContactController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(15))
                              ),
                              labelText: 'Emergency contact',
                              prefixIcon: Icon(Icons.phone),
                            ),
                            keyboardType: TextInputType.phone,
                            validator: (value) => value == null || value.isEmpty ? 'Please enter your emergency contact' : null,
                          ),

                          SizedBox(height: size.height * 0.02,),

                          //mail
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(15))
                              ),
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.mail),
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
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                    onPressed: () => val.toggleRegisterObscureText(),
                                    icon: Icon(val.registerObscureText?
                                    CupertinoIcons.eye_slash_fill: CupertinoIcons.eye_solid)
                                )
                            ),
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: val.registerObscureText,
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
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                    onPressed: () => val.toggleRegisterCObscureText(),
                                    icon: Icon(val.registerCObscureText?
                                    CupertinoIcons.eye_slash_fill: CupertinoIcons.eye_solid)
                                )
                            ),
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: val.registerCObscureText,
                            validator: (value) => value == null || value.isEmpty ?
                            'Please confirm the password' : value.length<6 ?
                            'the minimum length is 6 character': null,
                          ),

                          SizedBox(height: size.height * 0.02,),

                          if (val.registerErrorMessage != null)
                            Text(val.registerErrorMessage!,
                              style: const TextStyle(color: Colors.red)
                            ),

                          SizedBox(height: size.height * 0.02,),

                          //register
                          SizedBox(
                            width: size.width,
                            height: size.height * 0.08,
                            child: ElevatedButton(
                              onPressed: val.registerIsLoading ? null : (){
                                if (_formKey.currentState!.validate()) {
                                  if(_passwordController.text == _cPasswordController.text){
                                    val.register(user: User(
                                        userName: _nameController.text,
                                        userPN: _emergencyContactController.text,
                                        email: _emailController.text,
                                        password: _passwordController.text
                                    )).then((value) {
                                      val.nullRegisterErrorMessage();
                                      Navigator.pushReplacement(context,
                                          MaterialPageRoute(builder: (
                                              context) => const HomeScreen()));
                                    }).catchError((e){val.setRegisterErrorMessage(e.toString());});
                                  }else {
                                    val.setRegisterErrorMessage('password not mach');
                                  }
                                }
                              },
                              child: val.registerIsLoading ? const CircularProgressIndicator() : const Text('Register'),
                            ),
                          ),


                          SizedBox(height: size.height * 0.02,),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('already have an account,'),
                              TextButton(onPressed: (){
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
        )
    );
  }
}

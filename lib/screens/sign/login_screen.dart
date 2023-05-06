import 'package:app2m/screens/sign/register.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';

import 'package:provider/provider.dart';

import '../../provider/my_provider.dart';

import '../home/home_screen.dart';
import 'log_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
                  child: Lottie.asset('assets/lottie/login.json')
                ),

                Padding(
                  padding: EdgeInsets.all(size.height * 0.01),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                                  onPressed: () => val.toggleObscureText(),
                                  icon: Icon(val.obscureText? CupertinoIcons.eye_solid : CupertinoIcons.eye_slash_fill)
                              ),
                          ),
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: val.obscureText,
                          validator: (value) => value == null || value.isEmpty ?
                          'Please enter the password' : value.length<6 ?
                          'the minimum length is 6 character': null,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: (){
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) => const HomeScreen())
                                );
                              },
                              child: const Text('Forget Password'),
                            ),
                          ],
                        ),

                        SizedBox(height: size.height * 0.02,),

                        if (val.errorMessage != null)
                          Text(val.errorMessage!,
                              style: const TextStyle(color: Colors.red)
                          ),

                        SizedBox(height: size.height * 0.02,),

                        //login
                        SizedBox(
                          width: size.width,
                          height: size.height * 0.08,
                          child: ElevatedButton(
                            onPressed: val.isLoading ? null : (){
                              if (_formKey.currentState!.validate()) {
                                val.sign(email: _emailController.text, password: _passwordController.text)
                                    .then((value) {
                                  val.reset();
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context) => const HomeScreen()));
                                }).catchError((e){val.setErrorMessage(e.toString());});
                              }
                            },
                            child: val.isLoading ? const CircularProgressIndicator() : const Text('Login'),
                          ),
                        ),

                        SizedBox(height: size.height * 0.02,),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('don\'nt have an account,'),
                            TextButton(onPressed: (){
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) => const SignScreen()));
                            }, child: const Text('Create Account'))
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

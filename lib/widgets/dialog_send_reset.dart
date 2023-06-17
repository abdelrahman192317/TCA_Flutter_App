import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:provider/provider.dart';

import 'package:app2m/provider/my_provider.dart';

class ForgetPasswordWidget extends StatelessWidget {

  ForgetPasswordWidget({Key? key}) : super(key: key);

  final _controller = TextEditingController();

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
          child: Padding(
            padding: EdgeInsets.all(size.height * 0.02),
            child: Form(
              key: _formKey,
              child: val.forget?
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      'You Received an Email With Reset Password Way',
                      softWrap: true,
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center
                    )
                  ),
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
              )
                  :
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Send Reset Password Mail', style: Theme.of(context).textTheme.titleLarge),
                  SizedBox(height: size.height * 0.02,),

                  TextFormField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.mail),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => value == null || value.isEmpty ? 'Please Enter your Email' : null,
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
                                  val.resetPw(_controller.text).then((_) {
                                    val.nullErrorMessage();
                                    val.toast(context, "Mail Is Send to Your Email");
                                    val.toggleForget();
                                  }).catchError((e){val.setErrorMessage(e.toString());});
                                }
                              },
                              child: const Text('Send'),
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
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:app2m/provider/my_provider.dart';

class EditMailWidget extends StatelessWidget {

  EditMailWidget({Key? key}) : super(key: key);

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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Edit Your Email', style: Theme.of(context).textTheme.titleLarge),
                  SizedBox(height: size.height * 0.02,),

                  TextFormField(
                    controller: _controller,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      labelText: 'Email',
                      hintText: val.user.email,
                      prefixIcon: const Icon(Icons.mail),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => value == null || value.isEmpty ? 'Please Enter The New Email' : null,
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
                                  val.updateMail(_controller.text);
                                  Navigator.pop(context);
                                  val.reset();
                                  val.toast(context, "Email Changed Successfully");
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
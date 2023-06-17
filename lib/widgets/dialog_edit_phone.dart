import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:provider/provider.dart';

import 'package:app2m/provider/my_provider.dart';
import 'package:url_launcher/url_launcher.dart';



class EditPhoneWidget extends StatelessWidget {

  EditPhoneWidget({Key? key}) : super(key: key);

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
              child: !val.forget?
              Padding(
                padding: EdgeInsets.all(size.height * 0.02),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              val.toggleForget();
                            },
                            child: Container(
                              height: size.height * 0.07,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(20)),
                                color: Theme.of(context).focusColor,
                              ),

                              child: Icon(Icons.edit, color: Theme.of(context).primaryColor,),
                            ),
                          ),
                        ),
                        SizedBox(width: size.width * 0.03),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              launchUrl(Uri.parse('tel:+2${val.user.userPN}'));
                              val.reset();
                            },
                            child: Container(
                              height: size.height * 0.07,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(20)),
                                color: Theme.of(context).focusColor,
                              ),
                              child: Icon(Icons.phone, color: Theme.of(context).primaryColor,),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            val.reset();
                            Navigator.pop(context);
                          },
                          child: const Text('cancel'),
                        ),
                      ],
                    ),
                  ],
                ),
              )
                  :
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Edit The Emergency Call', style: Theme.of(context).textTheme.titleLarge),
                  SizedBox(height: size.height * 0.02,),

                  TextFormField(
                    controller: _controller,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      labelText: 'Phone',
                      hintText: val.user.userPN,
                      prefixIcon: const Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) => value == null || value.isEmpty ? 'Please Enter The New Emergency Call' : null,
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
                                  val.updatePN(_controller.text);
                                  val.reset();
                                  val.toast(context, "Emergency Call Changed Successfully");
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
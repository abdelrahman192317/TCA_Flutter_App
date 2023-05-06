import 'package:app2m/provider/my_provider.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';



class EditWidget extends StatelessWidget {
  final String title;
  final Icon? icon;
  final int type;
  final TextInputType? textInputType;
  //final _controller = TextEditingController();

  EditWidget({Key? key, required this.title, required this.type, this.icon, this.textInputType}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context){
    final size = MediaQuery.of(context).size;

    return Consumer<MyPro> (
      builder: (ctx, val, child) => Dialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        elevation: 10,
        child: Padding(
          padding: EdgeInsets.all(size.height * 0.02),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                SizedBox(height: size.height * 0.02,),
                if(type < 3)TextFormField(
                  //controller: val.controller,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                    labelText: title,
                    prefixIcon: icon,
                  ),
                  keyboardType: textInputType,
                  validator: (value) => value == null || value.isEmpty ? 'Please enter your data' : null,
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
                            height: size.height * 0.06,
                            child: TextButton(
                              onPressed: () {
                                val.nullErrorMessage();
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancel'),
                            )
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
                        child: SizedBox(
                          height: size.height * 0.06,
                          child: ElevatedButton(
                            onPressed: (){
                              if (_formKey.currentState!.validate()) {
                                try{

                                  Navigator.of(context).pop();
                                  val.nullErrorMessage();
                                }catch(e){
                                  val.setErrorMessage(e.toString());
                                }
                              }
                            },
                            child: const Text('OK'),
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
    );
  }
}
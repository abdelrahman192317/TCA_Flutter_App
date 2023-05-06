import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../provider/my_provider.dart';

import '../../models/doctor_models.dart';


class AddDoctor extends StatefulWidget {
  const AddDoctor({Key? key}) : super(key: key);

  @override
  State<AddDoctor> createState() => _AddDoctorState();
}

class _AddDoctorState extends State<AddDoctor> {

  final _formKey = GlobalKey<FormState>();

  final _phoneNumberController = TextEditingController();
  final _typeController = TextEditingController();
  final _locationController = TextEditingController();
  final _dateTime = DateTime.now();

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _typeController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Consumer<MyPro>(
        builder: (ctx, val, _) => Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(size.height * 0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height * 0.02),

                  IconButton(
                    onPressed: (){
                      val.nullErrorMessage();
                      val.falsePickers();
                      val.setIsNewDoc(true);
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios),
                  ),

                  Padding(
                    padding: EdgeInsets.all(size.height * 0.01),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          SizedBox(height: size.height * 0.04),
                          const Text('Adding Doctor Date', style: TextStyle(fontSize: 30),),

                          SizedBox(height: size.height * 0.02),
                          const Text('please enter the required data', style: TextStyle(fontSize: 15, color: Colors.grey),),

                          SizedBox(height: size.height * 0.04),
                          Autocomplete<String>(
                            optionsBuilder: (TextEditingValue textEditingValue) {
                              if (textEditingValue.text == '') {
                                return const Iterable<String>.empty();
                              }
                              return val.dNList.where((String dName) {
                                return dName.contains(textEditingValue.text.toLowerCase());
                              });
                            },
                            onSelected: (String selection) {
                              val.setIsNewDoc(false);
                              val.setDN(selection);
                            },
                            optionsMaxHeight: size.height * 0.2,
                            fieldViewBuilder: (BuildContext context,
                                TextEditingController tEC,
                                FocusNode focusNode,
                                onFieldSubmitted) {
                              return TextFormField(
                                controller: tEC,
                                focusNode: focusNode,
                                onChanged: (String value) {
                                  if(val.dN == value) {
                                    val.setIsNewDoc(false);
                                  } else{
                                    val.setIsNewDoc(true);
                                    val.setDN(value);
                                  }
                                },
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(15))
                                  ),
                                  labelText: 'Doctor Name',
                                  prefixIcon: Icon(Icons.person),
                                ),
                                keyboardType: TextInputType.name,
                                validator: (value) => value == null || value.isEmpty ? 'Please enter doctor name' : null,
                              );
                            },
                            optionsViewBuilder: (BuildContext context,
                                AutocompleteOnSelected<String> onSelected,
                                Iterable<String> options) {
                              return Align(
                                alignment: Alignment.topLeft,
                                child: Card(
                                  child: SizedBox(
                                    width: size.width * 0.89,
                                    height: size.height * 0.3,
                                    child: ListView(
                                      children: options.map((String option) => GestureDetector(
                                          onTap: () => onSelected(option),
                                          child: Padding(
                                            padding: EdgeInsets.all(size.height * 0.01),
                                            child: Text(option),
                                          ))).toList(),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),

                          if(val.isNewDoc) ...[
                          SizedBox(height: size.height * 0.02,),
                          //phone number
                          TextFormField(
                            controller: _phoneNumberController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(15))
                              ),
                              labelText: 'Phone Number',
                              prefixIcon: Icon(Icons.phone),
                            ),
                            keyboardType: TextInputType.phone,
                            validator: (value) => value == null || value.isEmpty ? 'Please enter phone number' : null,
                          ),

                          SizedBox(height: size.height * 0.02,),
                          //type
                          TextFormField(
                            controller: _typeController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(15))
                              ),
                              labelText: 'Doctor Type',
                              prefixIcon: Icon(Icons.medical_services_rounded),
                            ),
                            keyboardType: TextInputType.text,
                            validator: (value) => value == null || value.isEmpty ? 'Please enter doctor type' : null,
                          ),

                          SizedBox(height: size.height * 0.02,),
                          //location
                          TextFormField(
                            controller: _locationController,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(15))),
                                labelText: 'Location',
                                prefixIcon: Icon(Icons.location_city),
                            ),
                            keyboardType: TextInputType.streetAddress,
                            validator: (value) => value == null || value.isEmpty ? 'Please enter location' : null,
                          ),
                          ],

                          SizedBox(height: size.height * 0.02),
                          //date and time
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
                                  child: SizedBox(
                                    height: size.height * 0.07,
                                    child: ElevatedButton.icon(
                                      onPressed: () => val.selectDate(context),
                                      icon: const Icon(Icons.calendar_today),
                                      label: Text(
                                          val.isDatePicked
                                              ? '${val.selectedDate.day}/${val.selectedDate.month}'
                                              : 'start Date'
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
                                  child: SizedBox(
                                    height: size.height * 0.07,
                                    child: ElevatedButton.icon(
                                      onPressed: () => val.selectTime(context),
                                      icon: const Icon(Icons.access_time_outlined),
                                      label: Text(
                                          val.isTimePicked
                                              ? val.selectedTime.format(context)
                                              : 'start Time'
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: size.height * 0.06),
                          if (val.errorMessage != null)
                            Text(val.errorMessage!,style: const TextStyle(color: Colors.red)),

                          SizedBox(height: size.height * 0.02),
                          //adding or cancel
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
                                  child: SizedBox(
                                      height: size.height * 0.08,
                                      child: TextButton(
                                        onPressed: () {
                                          val.nullErrorMessage();
                                          val.falsePickers();
                                          val.setIsNewDoc(true);
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
                                    height: size.height * 0.08,
                                    child: ElevatedButton(
                                      onPressed: (){
                                        if (_formKey.currentState!.validate()) {
                                          if(val.isTimePicked){
                                            val.isNewDoc? val.addDDs(dds: DoctorDates(
                                                doctorName: val.dN,
                                                phoneNumber: _phoneNumberController.text,
                                                type: _typeController.text,
                                                location: _locationController.text,
                                                dateTime: val.selectedDate
                                            )) : val.addDD(val.selectedDate);
                                              val.nullErrorMessage();
                                              val.falsePickers();
                                              Navigator.pop(context);
                                          }else{
                                            val.setErrorMessage('choose an image');
                                          }
                                        }
                                      },
                                      child: const Text('Add'),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
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

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

  final _nameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _typeController = TextEditingController();
  final _locationController = TextEditingController();
  final _dateController = DateTime.now();

  @override
  void dispose() {
    _nameController.dispose();
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
            child: Container(
              padding: EdgeInsets.all(size.height * 0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height * 0.02),

                  IconButton(
                    onPressed: (){
                      Navigator.pop(context);
                      val.nullErrorMessage();
                      val.falsePickers();
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
                              return val.dNList.where((String option) => true);
                            },
                            onSelected: (String selection) {
                              val.setIsNewDoc(true);
                              val.setDN(selection);
                            },
                            fieldViewBuilder: (BuildContext context,
                                TextEditingController tEC,
                                FocusNode focusNode,
                                onFieldSubmitted) {
                              return TextFormField(
                                controller: tEC,
                                focusNode: focusNode,
                                onChanged: (String value) {
                                  val.setDN(value);
                                  //onFieldSubmitted();
                                },
                                onFieldSubmitted: val.setDN(tEC.text),
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(15))
                                  ),
                                  labelText: 'Name',
                                  prefixIcon: Icon(Icons.person),
                                ),
                                keyboardType: TextInputType.name,
                                validator: (value) => value == null || value.isEmpty ? 'Please enter your name' : null,
                              );
                            },
                            optionsViewBuilder: (BuildContext context,
                                AutocompleteOnSelected<String> onSelected,
                                Iterable<String> options) {
                              return Align(
                                alignment: Alignment.topCenter,
                                child: Card(
                                  child: SizedBox(
                                    height: size.height * 0.3,
                                    child: ListView(
                                      children: options.map((String option) => GestureDetector(
                                        onTap: () => onSelected(option),
                                        child: Text(option)
                                      )).toList(),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),

                          SizedBox(height: size.height * 0.04),

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
                                          Navigator.pop(context);
                                          val.nullErrorMessage();
                                          val.falsePickers();
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
                                            val.addDDs(dds: DoctorDates(
                                                doctorName: _nameController.text,
                                                phoneNumber: _phoneNumberController.text,
                                                type: _typeController.text,
                                                location: _locationController.text,
                                                dateTime: _dateController
                                            ));
                                            Navigator.pop(context);
                                            val.nullErrorMessage();
                                            val.falsePickers();
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

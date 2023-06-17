import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
        builder: (ctx, val, _) => WillPopScope(
          onWillPop: () async{
            val.nullErrorMessage();
            val.falsePickers();
            val.setIsNewDoc(true);
            return true;
          },
          child: Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(size.height * 0.02),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: size.height * 0.03),

                    IconButton(
                      onPressed: (){
                        val.nullErrorMessage();
                        val.falsePickers();
                        val.setIsNewDoc(true);
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).shadowColor,),
                    ),

                    Padding(
                      padding: EdgeInsets.all(size.height * 0.01),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            SizedBox(height: size.height * 0.02),
                            Text('Adding Doctor Date', style: Theme.of(context).textTheme.titleLarge),

                            SizedBox(height: size.height * 0.02),
                            const Text('please enter the required data', style: TextStyle(fontSize: 15, color: Colors.grey),),

                            SizedBox(height: size.height * 0.04),
                            Autocomplete<String>(
                              optionsBuilder: (TextEditingValue textEditingValue) {
                                if (textEditingValue.text == '') {
                                  return const Iterable<String>.empty();
                                }
                                return val.doctorsNamesList.where((String dName) {
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
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(15))
                                    ),
                                    labelText: 'Doctor Name',
                                    labelStyle: Theme.of(context).textTheme.bodySmall,
                                    prefixIcon: Icon(Icons.person, color: Theme.of(context).primaryColor,),
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
                                              padding: EdgeInsets.all(size.width * 0.01),
                                              child: ListTile(
                                                leading: CircleAvatar(
                                                  radius: 18,
                                                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                                                  child: Icon(Icons.person, color: Theme.of(context).primaryColor,),
                                                ),
                                                title: Text(option),
                                              ),
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
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(15))
                                ),
                                labelText: 'Phone Number',
                                labelStyle: Theme.of(context).textTheme.bodySmall,
                                prefixIcon: Icon(Icons.phone, color: Theme.of(context).primaryColor,),
                              ),
                              keyboardType: TextInputType.phone,
                              validator: (value) => value == null || value.isEmpty ? 'Please enter phone number' : null,
                            ),

                            SizedBox(height: size.height * 0.02,),
                            //type
                            TextFormField(
                              controller: _typeController,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(15))
                                ),
                                labelText: 'Doctor Type',
                                labelStyle: Theme.of(context).textTheme.bodySmall,
                                prefixIcon: Icon(Icons.medical_services_rounded, color: Theme.of(context).primaryColor,),
                              ),
                              keyboardType: TextInputType.text,
                              validator: (value) => value == null || value.isEmpty ? 'Please enter doctor type' : null,
                            ),

                            SizedBox(height: size.height * 0.02,),
                            //location
                            TextFormField(
                              controller: _locationController,
                              decoration: InputDecoration(
                                  border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(15))),
                                  labelText: 'Location',
                                labelStyle: Theme.of(context).textTheme.bodySmall,
                                  prefixIcon: Icon(Icons.location_city, color: Theme.of(context).primaryColor,),
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
                                  child: SizedBox(
                                    height: size.height * 0.08,
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                        backgroundColor: Theme.of(context).hintColor,
                                        elevation: 0,
                                        side: BorderSide(color: Theme.of(context).primaryColor.withOpacity(0.6), ),
                                        foregroundColor: Theme.of(context).primaryColor,
                                      ),
                                      onPressed: () => val.selectDate(context),
                                      icon: Icon(Icons.calendar_today, color: Theme.of(context).primaryColor,),
                                      label: Text(
                                        val.isDatePicked
                                            ? DateFormat('MM/dd').format(val.selectedDate)
                                            : 'start Date',
                                        style: Theme.of(context).textTheme.bodyMedium,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: size.width * 0.03),
                                Expanded(
                                  child: SizedBox(
                                    height: size.height * 0.08,
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                        backgroundColor: Theme.of(context).hintColor,
                                        elevation: 0,
                                        side: BorderSide(color: Theme.of(context).primaryColor.withOpacity(0.6), ),
                                        foregroundColor: Theme.of(context).primaryColor,
                                      ),
                                      onPressed: () => val.selectTime(context),
                                      icon: Icon(Icons.access_time, color: Theme.of(context).primaryColor,),
                                      label: Text(
                                        val.isTimePicked
                                            ? val.selectedTime.format(context)
                                            : 'start Time',
                                        style: Theme.of(context).textTheme.bodyMedium,
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
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                            elevation: 0,
                                            backgroundColor: Theme.of(context).focusColor,
                                            foregroundColor: Theme.of(context).primaryColor,
                                          ),
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
                                                dateTime: val.selectedDate,
                                                notificationsHandler: val.notificationsHandler
                                              )) : val.addDD(val.selectedDate);

                                              val.nullErrorMessage();
                                              val.falsePickers();
                                              val.setIsNewDoc(true);
                                              Navigator.pop(context);
                                              val.toast(context, "Doctor Date Added Successfully");
                                            }else{
                                              val.setErrorMessage('please select time');
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
          ),
        )
    );
  }
}

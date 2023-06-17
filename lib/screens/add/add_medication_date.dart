import 'package:app2m/widgets/choose_source.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

import '../../provider/my_provider.dart';

import '../../models/medication_models.dart';


class AddMedication extends StatefulWidget {
  const AddMedication({Key? key}) : super(key: key);

  @override
  State<AddMedication> createState() => _AddMedicationState();
}

class _AddMedicationState extends State<AddMedication> {

  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _typeController = TextEditingController();
  final _dNameController = TextEditingController();

  final _repeatInDayOTPController = TextEditingController();
  final _daysNumOTPController = TextEditingController();


  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _typeController.dispose();
    _dNameController.dispose();
    _repeatInDayOTPController.dispose();
    _daysNumOTPController.dispose();
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
            return true;
          },
          child: Scaffold(
            body: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: size.height * 0.03),

                    IconButton(
                      onPressed: (){
                        Navigator.pop(context);
                        val.nullErrorMessage();
                        val.falsePickers();
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

                            Text('Adding Medication Date', style: Theme.of(context).textTheme.titleLarge),

                            SizedBox(height: size.height * 0.01),

                            const Text('please enter the required data', style: TextStyle(fontSize: 15, color: Colors.grey),),

                            SizedBox(height: size.height * 0.05),

                            Center(
                              child: InkWell(
                                onTap: () {
                                  showDialog(context: context, builder: (_) => const ChooseSourceWidget());
                                },
                                child: SizedBox(
                                    width: size.height * 0.25,
                                    height: size.height * 0.25,
                                    child: Stack(
                                        children: [
                                          SizedBox(
                                            width: size.height * 0.25,
                                            height: size.height * 0.25,
                                            child: ClipRRect(
                                                borderRadius: BorderRadius.circular(500),
                                                child: val.isImagePicked ?
                                                Image.file(val.image,fit: BoxFit.cover,) :
                                                Image.asset('assets/images/drugs1.jpg',fit: BoxFit.cover,)
                                            ),
                                          ),
                                          Align(
                                              alignment: AlignmentDirectional.bottomEnd,
                                              child: CircleAvatar(
                                                radius: 27,
                                                child: Icon(val.isImagePicked ? Icons.edit: Icons.add)
                                              )
                                          )
                                        ]
                                    ),
                                ),
                              ),
                            ),

                            SizedBox(height: size.height * 0.04),

                            //name
                            TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(15))
                                ),
                                labelText: 'Medication Name',
                                labelStyle: Theme.of(context).textTheme.bodySmall,
                                prefixIcon: Icon(Icons.medical_information, color: Theme.of(context).primaryColor,),
                              ),
                              keyboardType: TextInputType.name,
                              validator: (value) => value == null || value.isEmpty ? 'Please enter medication name' : null,
                            ),

                            SizedBox(height: size.height * 0.02,),

                            //desc
                            TextFormField(
                              controller: _descController,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(15))
                                ),
                                labelText: 'Description',
                                labelStyle: Theme.of(context).textTheme.bodySmall,
                                prefixIcon: Icon(Icons.insert_drive_file_outlined, color: Theme.of(context).primaryColor,),
                              ),
                              keyboardType: TextInputType.text,
                              validator: (value) => value == null || value.isEmpty ? 'Please enter Description' : null,
                            ),

                            SizedBox(height: size.height * 0.02,),

                            //type
                            TextFormField(
                              controller: _typeController,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(15))
                                ),
                                labelText: 'Medication Type',
                                labelStyle: Theme.of(context).textTheme.bodySmall,
                                prefixIcon: Icon(Icons.medical_services_rounded, color: Theme.of(context).primaryColor,),
                              ),
                              keyboardType: TextInputType.text,
                              validator: (value) => value == null || value.isEmpty ? 'Please enter medication type' : null,
                            ),

                            SizedBox(height: size.height * 0.02,),

                            //doctor name
                            TextFormField(
                              controller: _dNameController,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(15))),
                                labelText: 'Doctor Name',
                                labelStyle: Theme.of(context).textTheme.bodySmall,
                                prefixIcon: Icon(Icons.person, color: Theme.of(context).primaryColor,),
                              ),
                              onFieldSubmitted: (val) => FocusScope.of(context).nextFocus(),
                              keyboardType: TextInputType.name,
                              validator: (value) => value == null || value.isEmpty ? 'Please enter doctor\'s name' : null,
                            ),

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
                                      icon: Icon(Icons.calendar_today, color: Theme.of(context).primaryColor),
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
                                      icon: Icon(Icons.access_time, color: Theme.of(context).primaryColor),
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

                            SizedBox(height: size.height * 0.02),

                            //numbers
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: size.height * 0.08,
                                    child: TextFormField(
                                      controller: _daysNumOTPController,
                                      keyboardType: TextInputType.number,
                                      validator: (value) => value == null || value.isEmpty || int.parse(value) == 0 ? 'Please Enter non Zero Number' : null,
                                      style: Theme.of(context).textTheme.bodyMedium,
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        errorBorder: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(20))
                                        ),
                                        border: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(20))),
                                        hintText: 'number of days',
                                        hintStyle: Theme.of(context).textTheme.bodySmall,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: size.width * 0.03),
                                Expanded(
                                  child: SizedBox(
                                    height: size.height * 0.08,
                                    child: TextFormField(
                                      controller: _repeatInDayOTPController,
                                      keyboardType: TextInputType.number,
                                      validator: (value) => value == null || value.isEmpty || int.parse(value) == 0 ? 'Please Enter non Zero Number' :
                                      int.parse(value) > 24 ? 'Please Enter Number less than 25': null,
                                      style: Theme.of(context).textTheme.bodyMedium,
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        errorBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(20))
                                        ),
                                        border: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(20))
                                        ),
                                        hintText: 'repeats count in day',
                                        hintStyle: Theme.of(context).textTheme.bodySmall,
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

                            //add or cancel
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
                                            if(val.isTimePicked && val.isImagePicked){
                                              val.addMDs(mds: MedicationDates(
                                                medicineName: _nameController.text,
                                                desc: _descController.text,
                                                type: _typeController.text,
                                                imageUrl: val.image.path,
                                                doctorName: _dNameController.text,
                                                startDateTime: val.selectedDate,
                                                daysNum: int.parse(_daysNumOTPController.text),
                                                repeatInDay: int.parse(_repeatInDayOTPController.text),
                                                notificationsHandler: val.notificationsHandler
                                              ));
                                              val.nullErrorMessage();
                                              val.falsePickers();
                                              Navigator.pop(context);
                                              val.toast(context, "Medication Date Added Successfully");
                                            }else{
                                              val.setErrorMessage('Image or Time not Entered');
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
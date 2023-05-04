import 'package:flutter/material.dart';

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

                          const Text('Adding Medication Date', style: TextStyle(fontSize: 30),),

                          SizedBox(height: size.height * 0.02),

                          const Text('please enter the required data', style: TextStyle(fontSize: 15, color: Colors.grey),),

                          SizedBox(height: size.height * 0.04),

                          Center(
                            child: InkWell(
                              onTap: () => val.getImage(),
                              child: SizedBox(
                                  width: size.width * 0.4,
                                  height: size.height * 0.25,
                                  child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(100),
                                          child: val.isImagePicked ? Image.file(val.image,fit: BoxFit.contain,) :
                                          Image.asset('assets/images/drugs.jpg',fit: BoxFit.contain,)
                                        ),
                                        Align(
                                            alignment: AlignmentDirectional.bottomEnd,
                                            child: CircleAvatar(
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
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(15))
                              ),
                              labelText: 'Medication Name',
                              prefixIcon: Icon(Icons.medical_information),
                            ),
                            keyboardType: TextInputType.name,
                            validator: (value) => value == null || value.isEmpty ? 'Please enter medication name' : null,
                          ),

                          SizedBox(height: size.height * 0.02,),

                          //desc
                          TextFormField(
                            controller: _descController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(15))
                              ),
                              labelText: 'Description',
                              prefixIcon: Icon(Icons.insert_drive_file_outlined),
                            ),
                            keyboardType: TextInputType.text,
                            validator: (value) => value == null || value.isEmpty ? 'Please enter Description' : null,
                          ),

                          SizedBox(height: size.height * 0.02,),

                          //type
                          TextFormField(
                            controller: _typeController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(15))
                              ),
                              labelText: 'Medication Type',
                              prefixIcon: Icon(Icons.medical_services_rounded),
                            ),
                            keyboardType: TextInputType.text,
                            validator: (value) => value == null || value.isEmpty ? 'Please enter medication type' : null,
                          ),

                          SizedBox(height: size.height * 0.02,),

                          //location
                          TextFormField(
                            controller: _dNameController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(15))),
                              labelText: 'Doctor Name',
                              prefixIcon: Icon(Icons.person),
                            ),
                            keyboardType: TextInputType.name,
                            validator: (value) => value == null || value.isEmpty ? 'Please enter doctor\'s name' : null,
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

                          SizedBox(height: size.height * 0.02),

                          //numbers
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
                                  child: SizedBox(
                                    height: size.height * 0.08,
                                    child: TextFormField(
                                      controller: _daysNumOTPController,
                                      keyboardType: TextInputType.number,
                                      validator: (value) => value == null || value.isEmpty ? 'Please enter number' : null,
                                      style: Theme.of(context).textTheme.bodyMedium,
                                      textAlign: TextAlign.center,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(15))),
                                        hintText: 'number of days',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
                                  child: SizedBox(
                                    height: size.height * 0.08,
                                    child: TextFormField(
                                      controller: _repeatInDayOTPController,
                                      keyboardType: TextInputType.number,
                                      validator: (value) => value == null || value.isEmpty ? 'Please enter number' : null,
                                      style: Theme.of(context).textTheme.bodyMedium,
                                      textAlign: TextAlign.center,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(15))),
                                        hintText: 'repeats count in day',
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

                          //add or cancel
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
                                            ));
                                            Navigator.pop(context);
                                            val.nullErrorMessage();
                                            val.falsePickers();
                                          }else{
                                            val.setErrorMessage('complete the required');
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
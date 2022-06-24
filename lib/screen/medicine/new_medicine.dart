import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:golden_ager/core/common_widget/custom_drop_down_form_field.dart';
import 'package:golden_ager/core/common_widget/custom_text_form_field.dart';
import 'package:golden_ager/core/constant/age_icon_icons.dart';
import 'package:golden_ager/core/constant/constant.dart';
import 'package:golden_ager/provider/auth_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/common_widget/custom_text.dart';
import '../../core/common_widget/custom_wide_buttom.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class NewMedicineScreen extends StatefulWidget {
  const NewMedicineScreen({Key? key}) : super(key: key);

  @override
  State<NewMedicineScreen> createState() => _NewMedicineScreenState();
}

class _NewMedicineScreenState extends State<NewMedicineScreen> {
  final GlobalKey<FormState> form = GlobalKey<FormState>();

  String? name, dose, pillDosage;

  int? shape = 1, color = 0xffD1325E;
  DateTime? startAt, endAt;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Add New Medicine', style: Constant.appBarTextStyle)),
      body: Form(
        key: form,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomFormField(
                    onChanged: (value) {
                      name = value;
                    },
                    hintText: 'name',
                    prefix:
                        Icon(Icons.person, color: Constant.primaryDarkColor)),
                CustomFormField(
                  hintText: 'Pill Dosage',
                  onChanged: (value) {
                    pillDosage = value;
                  },
                  prefix: Transform.rotate(
                    angle: -pi / 4,
                    child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100)),
                        child: SvgPicture.asset('assets/images/bill1.svg',
                            width: 5,
                            height: 5,
                            color: Constant.primaryDarkColor)),
                  ),
                ),
                CustomDropDownFormField(
                  onChanged: (value) {
                    dose = value;
                  },
                  prefixIcon: Icon(AgeIcon.liquidMedical,
                      color: Constant.primaryDarkColor),
                  title: 'Dose',
                  items: [1, 2, 3, 4]
                      .map(
                        (e) => DropdownMenuItem(
                          child: Center(
                              child: Text(
                            '$e time' + (e > 1 ? 's' : ''),
                            style: Constant.mediumTextStyle,
                          )),
                          value: '$e',
                        ),
                      )
                      .toList(),
                  iconSize: 24,
                ),
                DateSelectWidget(
                  startOnChanged: (DateTime value) {
                    startAt = value;
                  },
                  endOnChanged: (DateTime value) {
                    endAt = value;
                  },
                ),
                ShapeSelectWidget(onChanged: (int value) {
                  shape = value;
                }),
                ColorSelectWidget(onChanged: (Color value) {
                  color = value.value;
                }),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: Consumer<AuthProvider>(
                    builder: (context, auth, child) => auth.isLoadingAddMedicine
                        ? Center(child: CircularProgressIndicator())
                        : CustomWideButton(
                            child: const Center(
                              child: CustomText(
                                text: 'Add medicine',
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            radius: 10.0,
                            height: 40,
                            width: 130,
                            color: Constant.primaryDarkColor,
                            onTap: () async {
                              if (!form.currentState!.validate()) {
                                Constant.showToast(
                                  message: 'all field are required',
                                  color: Colors.red,
                                );
                              } else {
                                final bool status = await auth.addMedicine(
                                    name: name!,
                                    pillDosage: pillDosage!,
                                    shape: shape ?? 1,
                                    color: color!,
                                    dose: int.parse(dose!),
                                    startAt: startAt!,
                                    endAt: endAt!);
                                if (status) {
                                  Constant.showToast(
                                    message:
                                        'medicine has been added successfully',
                                    color: Colors.green,
                                  );
                                  Navigator.pop(context);
                                } else {
                                  Constant.showToast(
                                    message: 'Error happend',
                                    color: Colors.red,
                                  );
                                }
                              }
                            }),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ShapeSelectWidget extends StatefulWidget {
  const ShapeSelectWidget({Key? key, required this.onChanged})
      : super(key: key);
  final Function onChanged;

  @override
  State<ShapeSelectWidget> createState() => _ShapeSelectWidgetState();
}

class _ShapeSelectWidgetState extends State<ShapeSelectWidget> {
  int index = 1;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Shape",
              textAlign: TextAlign.start,
              style: Constant.mediumTextStyle,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [1, 2, 3, 4]
                    .map(
                      (e) => GestureDetector(
                        onTap: () => setState(() {
                          index = e;
                          widget.onChanged(e);
                        }),
                        child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: e == index
                                    ? Colors.blue[100]
                                    : Colors.transparent),
                            child: SvgPicture.asset('assets/images/bill$e.svg',
                                color: Constant.primaryColor)),
                      ),
                    )
                    .toList()),
          ],
        ));
  }
}

class ColorSelectWidget extends StatefulWidget {
  const ColorSelectWidget({Key? key, required this.onChanged})
      : super(key: key);
  final Function onChanged;

  @override
  State<ColorSelectWidget> createState() => _ColorSelectWidgetState();
}

class _ColorSelectWidgetState extends State<ColorSelectWidget> {
  Color pickedColor = Color(0xffD1325E);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Color",
                  textAlign: TextAlign.start,
                  style: Constant.mediumTextStyle,
                ),
                IconButton(
                    icon: Icon(
                      Icons.color_lens_sharp,
                    ),
                    onPressed: () {
// raise the [showDialog] widget
                      showDialog(
                        builder: (context) => AlertDialog(
                          title: const Text('Pick a color!',
                              style: Constant.mediumTextStyle),
                          content: SingleChildScrollView(
                            child: ColorPicker(
                              pickerColor: pickedColor,
                              onColorChanged: (Color color) {
                                setState(() => pickedColor = color);
                                print(color.value);
                                widget.onChanged(color);
                              },
                            ),
                          ),
                          actions: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Constant.primaryDarkColor),
                                child: Text(
                                  'Got it',
                                  style: Constant.mediumTextStyle
                                      .copyWith(color: Colors.white),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                          ],
                        ),
                        context: context,
                      );
                    })
              ],
            ),
            Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: pickedColor, borderRadius: BorderRadius.circular(16)),
              margin: const EdgeInsets.symmetric(vertical: 8),
            )
          ],
        ));
  }
}

class DateSelectWidget extends StatefulWidget {
  const DateSelectWidget(
      {Key? key, required this.startOnChanged, required this.endOnChanged})
      : super(key: key);

  final Function startOnChanged;

  final Function endOnChanged;

  @override
  State<DateSelectWidget> createState() => _DateSelectWidgetState();
}

class _DateSelectWidgetState extends State<DateSelectWidget> {
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();

  Future<void> _selectDate(bool isStart) async {
    if (Platform.isIOS) {
      showModalBottomSheet(
          context: context,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15))),
          builder: (BuildContext context) {
            return CupertinoDatePicker(
              initialDateTime: isStart
                  ? DateTime.now()
                  : DateTime.now().add(Duration(days: 1)),
              maximumDate: DateTime.now().add(Duration(days: 360)),
              minimumDate: isStart
                  ? DateTime.now()
                  : DateTime.now().add(Duration(days: 1)),
              mode: CupertinoDatePickerMode.date,
              // backgroundColor: Colors.white,
              onDateTimeChanged: (picked) {
                setState(() {
                  if (isStart) {
                    widget.startOnChanged(picked);
                    startDateController.text =
                        " ${DateFormat('dd/MM/yyyy').format(picked)}";
                  } else {
                    widget.endOnChanged(picked);
                    endDateController.text =
                        " ${DateFormat('dd/MM/yyyy').format(picked)}";
                  }
                });
              },
            );
          });
    } else {
      final picked = await showDatePicker(
          useRootNavigator: false,
          context: context,
          initialDate:
              isStart ? DateTime.now() : DateTime.now().add(Duration(days: 1)),
          firstDate:
              isStart ? DateTime.now() : DateTime.now().add(Duration(days: 1)),
          lastDate: DateTime.now().add(Duration(days: 360)),
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: ThemeData.light().copyWith(
                colorScheme: ColorScheme.dark(
                  primary: Constant.primaryColor,
                  onPrimary: Colors.white,
                  surface: Colors.white,
                  onSurface: Constant.primaryDarkColor,
                ),
                dialogBackgroundColor: Colors.white,
              ),
              child: child!,
            );
          });

      if (picked != null) {
        setState(() {
          if (isStart) {
            widget.startOnChanged(picked);
            startDateController.text =
                " ${DateFormat('dd/MM/yyyy').format(picked)}";
          } else {
            widget.endOnChanged(picked);
            endDateController.text =
                " ${DateFormat('dd/MM/yyyy').format(picked)}";
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          Expanded(
            child: CustomFormField(
              prefix: GestureDetector(
                  onTap: () async => await _selectDate(true),
                  child: Icon(
                    Icons.calendar_month_rounded,
                    color: Constant.primaryColor,
                  )),
              readOnly: true,
              hintText: "start date",
              controller: startDateController,
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: CustomFormField(
                prefix: GestureDetector(
                    onTap: () async => await _selectDate(false),
                    child: Icon(
                      Icons.calendar_month_rounded,
                      color: Constant.primaryColor,
                    )),
                readOnly: true,
                hintText: "end date",
                controller: endDateController),
          )
        ],
      ),
    );
  }
}

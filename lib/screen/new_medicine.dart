import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:golden_ager/core/common_widget/custom_drop_down_form_field.dart';
import 'package:golden_ager/core/common_widget/custom_text_form_field.dart';
import 'package:golden_ager/core/constant/age_icon_icons.dart';
import 'package:golden_ager/core/constant/constant.dart';
import 'package:intl/intl.dart';

class NewMedicineScreen extends StatelessWidget {
  NewMedicineScreen({Key? key}) : super(key: key);
  final GlobalKey<FormState> form = GlobalKey<FormState>();

  final startController = TextEditingController();
  final endController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Add New Medicine', style: Constant.appBarTextStyle)),
      body: Form(
        key: form,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomFormField(
                  hintText: 'name',
                  prefix: Icon(Icons.person, color: Constant.primaryDarkColor)),
              CustomFormField(
                hintText: 'Pill Dosage',
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
                  prefixIcon: Icon(AgeIcon.liquidMedical,
                      color: Constant.primaryDarkColor),
                  title: 'Dose',
                  items: const [
                    DropdownMenuItem(
                      child: Center(
                          child: Text(
                        '1 time',
                        style: Constant.mediumTextStyle,
                      )),
                      value: '1',
                    ),
                    DropdownMenuItem(
                      child: Center(
                          child: Center(
                        child: Text(
                          '2 times',
                          style: Constant.mediumTextStyle,
                        ),
                      )),
                      value: '2',
                    ),
                    DropdownMenuItem(
                      child: Center(
                          child: Text(
                        '3 times',
                        style: Constant.mediumTextStyle,
                      )),
                      value: '3',
                    )
                  ]),
              DateSelectWidget(),
              ShapeSelectWidget(),
              ColorSelectWidget()
            ],
          ),
        ),
      ),
    );
  }
}

class ShapeSelectWidget extends StatefulWidget {
  const ShapeSelectWidget({Key? key}) : super(key: key);

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
  const ColorSelectWidget({Key? key}) : super(key: key);

  @override
  State<ColorSelectWidget> createState() => _ColorSelectWidgetState();
}

class _ColorSelectWidgetState extends State<ColorSelectWidget> {
  List<int> colors = [
    0xffD1325E,
    0xffF1C125,
    0xff2165B1,
    0xff66AC61,
    0xffC472C1,
    0xffEA8877
  ];
  int color = 0;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Color",
              textAlign: TextAlign.start,
              style: Constant.mediumTextStyle,
            ),
            Container(
                height: 155,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisSpacing: 8,
                            childAspectRatio: 2 / 1,
                            crossAxisCount: 3,
                            crossAxisSpacing: 8),
                    itemCount: 6,
                    itemBuilder: (contrxt, i) => GestureDetector(
                          onTap: () {
                            setState(() => color = colors[i]);
                          },
                          child: Container(
                              height: 75,
                              decoration: BoxDecoration(
                                  color: Color(colors[i]),
                                  border: Border.all(
                                      width: 3,
                                      color: color == colors[i]
                                          ? Constant.primaryColor
                                          : Colors.transparent),
                                  borderRadius: BorderRadius.circular(16))),
                        )))
          ],
        ));
  }
}

class DateSelectWidget extends StatefulWidget {
  const DateSelectWidget({Key? key}) : super(key: key);

  @override
  State<DateSelectWidget> createState() => _DateSelectWidgetState();
}

class _DateSelectWidgetState extends State<DateSelectWidget> {
  DateTime? startSelectedDay;
  DateTime? endSelectedDay;
  Future<void> _selectDate(bool isStart) async {
    if (Platform.isIOS) {
      showModalBottomSheet(
          context: context,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15))),
          builder: (BuildContext context) {
            return CupertinoDatePicker(
              initialDateTime: DateTime.now(),
              maximumDate: DateTime.now().add(Duration(days: 7)),
              minimumDate: DateTime.now(),
              mode: CupertinoDatePickerMode.date,
              // backgroundColor: Colors.white,
              onDateTimeChanged: (picked) {
                setState(() {
                  if (isStart) {
                    startSelectedDay = picked;
                  } else {
                    endSelectedDay = picked;
                  }
                });
              },
            );
          });
    } else {
      await showDatePicker(
          useRootNavigator: false,
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(Duration(days: 7)),
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: ThemeData.light().copyWith(
                colorScheme: ColorScheme.dark(
                  primary: Theme.of(context).primaryColor,
                  onPrimary: Colors.white,
                  surface: Theme.of(context).primaryColor,
                  onSurface: Colors.black,
                ),
                dialogBackgroundColor: Colors.white,
              ),
              child: child!,
            );
          }).then((picked) {
        if (picked != null) {
          setState(() {
            if (isStart) {
              startSelectedDay = picked;
            } else {
              endSelectedDay = picked;
            }
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () async {
                await _selectDate(true);
              },
              child: Text(
                startSelectedDay == null
                    ? "start date"
                    : "start date : ${DateFormat('dd/MM/yyyy').format(startSelectedDay!)}",
                style: Constant.normalTextStyle,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
              child: GestureDetector(
            onTap: () async => await _selectDate(false),
            child: Text(
              endSelectedDay == null
                  ? "end date"
                  : "end date : ${DateFormat('dd/MM/yyyy').format(endSelectedDay!)}",
              style: Constant.normalTextStyle,
            ),
          ))
        ],
      ),
    );
  }
}

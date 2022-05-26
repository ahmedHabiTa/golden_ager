import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:golden_ager/core/constant/constant.dart';
import 'package:golden_ager/models/medicine.dart';
import 'package:golden_ager/screen/new_medicine.dart';

import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';

class MedicineReminderScreen extends StatefulWidget {
  const MedicineReminderScreen({Key? key}) : super(key: key);

  @override
  State<MedicineReminderScreen> createState() => _MedicineReminderScreenState();
}

class _MedicineReminderScreenState extends State<MedicineReminderScreen> {
  final Medicine medicine = Medicine(
      name: 'Lisinopril',
      pillDosage: '150 mg',
      shape: '1',
      color: 0xffD1325E,
      dose: 3,
      startAt: DateTime.now(),
      endAt: DateTime.now().add(Duration(days: 7)));
  void createMedicine() {
    Map<String, Map<String, bool>> isDone = {};
    int condition = medicine.endAt.difference(medicine.startAt).inDays;
    final int hours = 24 ~/ medicine.dose;
    for (var i = 0; i < condition; i++) {
      isDone[DateFormat('yMd')
          .format(medicine.startAt.add(Duration(days: i)))] = {};
      for (var j = 0; j < medicine.dose; j++) {
        isDone[DateFormat('yMd')
                .format(medicine.startAt.add(Duration(days: i)))]!
            .addAll({(hours * j).toString(): false});
      }
    }
    medicine.isDone = isDone;
    print(medicine);
  }

  @override
  void initState() {
    super.initState();
    createMedicine();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        "Medicine Reminder",
        style: Constant.appBarTextStyle,
      )),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Constant.navigateTo(
                context: context, routeName: NewMedicineScreen());
          },
          backgroundColor: Constant.primaryColor,
          child: Icon(Icons.add, color: Colors.white)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WeekDays(),
          ProgresBar(),
          Expanded(
              child: ListView.builder(
                  itemCount: 2,
                  itemBuilder: (context, index) =>
                      MedicineItem(medicine: medicine)))
        ],
      ),
    );
  }
}

class MedicineItem extends StatefulWidget {
  const MedicineItem({
    Key? key,
    required this.medicine,
  }) : super(key: key);
  final Medicine medicine;
  @override
  State<MedicineItem> createState() => _MedicineItemState();
}

class _MedicineItemState extends State<MedicineItem> {
  late Map<String, bool> isdoneDay;
  late Medicine medicine;
  @override
  void initState() {
    super.initState();
    medicine = widget.medicine;
    isdoneDay =
        widget.medicine.isDone![DateFormat('yMd').format(DateTime.now())]!;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: Constant.accentColorLight),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Transform.rotate(
                angle: 90,
                child: Container(
                    decoration: BoxDecoration(
                        color: Color(widget.medicine.color),
                        borderRadius: BorderRadius.circular(100)),
                    child: SvgPicture.asset(
                        'assets/images/bill${widget.medicine.shape}.svg',
                        color: Colors.white)),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(widget.medicine.name, style: Constant.headLineTextStyle),
                  Text(widget.medicine.pillDosage,
                      style: Constant.normalTextStyle
                          .copyWith(color: Constant.primaryDarkColor)),
                  Text('9:00 am',
                      style: Constant.headLineTextStyle.copyWith(fontSize: 18))
                ],
              ),
              Container(
                  decoration: BoxDecoration(
                      border:
                          isdoneDay.values.every(((element) => element == true))
                              ? Border.all(color: Colors.green, width: 3)
                              : Border.all(color: Colors.transparent, width: 3),
                      borderRadius: BorderRadius.circular(100)),
                  child: isdoneDay.values.every(((element) => element == true))
                      ? Icon(Icons.done, size: 50, color: Colors.green)
                      : SizedBox(width: 50))
            ],
          ),
          if (!isdoneDay.values.every(((element) => element == true)))
            Divider(),
          if (!isdoneDay.values.every(((element) => element == true)))
            SizedBox(
                height: 50,
                child: Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: isdoneDay.keys
                            .map((key) => GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isdoneDay[key] = true;
                                    });
                                  },
                                  child: Text(
                                    key,
                                    style: Constant.mediumTextStyle,
                                  ),
                                ))
                            .toList()),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: isdoneDay.values
                            .map((val) => GestureDetector(
                                  child: Text(
                                    val ? "done" : "take",
                                    style: val
                                        ? Constant.mediumTextStyle
                                            .copyWith(color: Colors.green)
                                        : Constant.mediumTextStyle,
                                  ),
                                ))
                            .toList()),
                  ],
                ))
        ],
      ),
    );
  }
}

class ProgresBar extends StatelessWidget {
  const ProgresBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text(
          'Today Activities',
          style: Constant.headLineTextStyle,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                child: LinearPercentIndicator(
                  lineHeight: 10.0,
                  percent: 2 / 3,
                  barRadius: Radius.circular(20),
                  backgroundColor: Constant.accentColorLight,
                  progressColor: Constant.primaryColor,
                ),
              ),
              Text(
                "2/3 Med",
                style: Constant.normalTextStyle,
              ),
            ],
          ),
        )
      ]),
    );
  }
}

class WeekDays extends StatefulWidget {
  const WeekDays({Key? key}) : super(key: key);

  @override
  State<WeekDays> createState() => _WeekDaysState();
}

class _WeekDaysState extends State<WeekDays> {
  int _index = 0;
  int? empIndex;
  int? timeIndex;
  String? displayTime;
  DateTime? _selectedDay;
  List<Map<String, Object>> get commingWeekDays {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().add(
        Duration(days: index),
      );

      return {'day': weekDay};
    }).toList();
  }

  @override
  void initState() {
    _index = 0;
    _selectedDay = commingWeekDays[0]['day'] as DateTime?;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 100,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 8, childAspectRatio: 2 / 1, crossAxisCount: 1),
            scrollDirection: Axis.horizontal,
            itemCount: commingWeekDays.length,
            itemBuilder: (contrxt, i) => GestureDetector(
                  onTap: () {
                    setState(() {
                      _index = i;
                    });
                  },
                  child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: _index == i
                              ? Constant.primaryColor
                              : Constant.accentColorLight,
                          borderRadius: BorderRadius.circular(32)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat.d()
                                .format(commingWeekDays[i]['day'] as DateTime),
                            textAlign: TextAlign.center,
                            style: Constant.normalTextStyle.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color:
                                    _index == i ? Colors.white : Colors.black),
                          ),
                          Text(
                            DateFormat.E()
                                .format(commingWeekDays[i]['day'] as DateTime),
                            textAlign: TextAlign.center,
                            style: Constant.normalTextStyle.copyWith(
                                color:
                                    _index == i ? Colors.white : Colors.black),
                          ),
                        ],
                      )),
                )));
  }
}

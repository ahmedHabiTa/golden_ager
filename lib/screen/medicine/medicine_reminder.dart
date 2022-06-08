import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:golden_ager/core/constant/constant.dart';
import 'package:golden_ager/models/medicine.dart';
import 'package:golden_ager/provider/auth_provider.dart';

import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

import 'new_medicine.dart';

class MedicineReminderScreen extends StatefulWidget {
  const MedicineReminderScreen({Key? key}) : super(key: key);

  @override
  State<MedicineReminderScreen> createState() => _MedicineReminderScreenState();
}

class _MedicineReminderScreenState extends State<MedicineReminderScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      context.read<AuthProvider>().selectedDate = DateTime.now();
      context.read<AuthProvider>().getDisplayMedcines(DateTime.now());
      context.read<AuthProvider>().getTodayActivity();
    });
  }

  @override
  Widget build(BuildContext context) {
    final medicines = context.watch<AuthProvider>().displayMedcines;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Medicine Reminder",
          style: Constant.semieBoldTextStyle,
        ),
        actions: [
          IconButton(
              onPressed: () {
                Constant.navigateTo(
                    context: context, routeName: NewMedicineScreen());
              },
              icon: Icon(
                Icons.add,
                color: Constant.primaryColor,
              ))
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WeekDays(),
          if (medicines.isNotEmpty) ProgresBar(),
          if (medicines.isNotEmpty)
            Expanded(
                child: ListView.builder(
                    itemCount: medicines.length + 1,
                    itemBuilder: (context, index) => index == medicines.length
                        ? SizedBox(height: 20)
                        : MedicineItem(medicine: medicines[index]))),
          if (medicines.isEmpty)
            Expanded(
                child: Center(
                    child: Text("you have no medicine this day",
                        style: Constant.mediumTextStyle)))
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

  @override
  Widget build(BuildContext context) {
    isdoneDay = widget.medicine.isDone![
        DateFormat('yMd').format(context.read<AuthProvider>().selectedDate)]!;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: Constant.accentColorLight),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
            Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(widget.medicine.name, style: Constant.semieBoldTextStyle),
                Text(widget.medicine.pillDosage,
                    style: Constant.normalTextStyle
                        .copyWith(color: Constant.primaryDarkColor)),
              ],
            ),
            Spacer(),
            Container(
                decoration: BoxDecoration(
                    border:
                        isdoneDay.values.every(((element) => element == true))
                            ? Border.all(color: Colors.green, width: 3)
                            : Border.all(color: Colors.transparent, width: 3),
                    borderRadius: BorderRadius.circular(100)),
                child: isdoneDay.values.every(((element) => element == true))
                    ? Icon(Icons.done, size: 40, color: Colors.green)
                    : SizedBox(width: 40))
          ],
        ),
        if (!isdoneDay.values.every(((element) => element == true)) &&
            context.read<AuthProvider>().selectedDate.day == DateTime.now().day)
          Divider(),
        if (!isdoneDay.values.every(((element) => element == true)) &&
            context.read<AuthProvider>().selectedDate.day == DateTime.now().day)
          TakeAndDoneWidget(
            medicine: widget.medicine,
          )
      ]),
    );
  }
}

class ProgresBar extends StatelessWidget {
  const ProgresBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ratio = context.read<AuthProvider>().todayActivity;
    if (DateTime.now().day == context.read<AuthProvider>().selectedDate.day) {
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
                    percent: (ratio[0] ?? 0) + .0,
                    barRadius: Radius.circular(20),
                    backgroundColor: Constant.accentColorLight,
                    progressColor: Constant.primaryColor,
                  ),
                ),
                Text(
                  "${ratio[1]} / ${ratio[2]} Med",
                  style: Constant.normalTextStyle,
                ),
              ],
            ),
          )
        ]),
      );
    } else {
      return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          child: SizedBox());
    }
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
  List<DateTime> get commingWeekDays {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().add(
        Duration(days: index),
      );

      return weekDay;
    }).toList();
  }

  @override
  void initState() {
    _index = 0;
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
            itemBuilder: (context, i) => GestureDetector(
                  onTap: () {
                    setState(() {
                      _index = i;
                    });
                    context
                        .read<AuthProvider>()
                        .getDisplayMedcines(commingWeekDays[i]);
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
                            DateFormat.d().format(commingWeekDays[i]),
                            textAlign: TextAlign.center,
                            style: Constant.normalTextStyle.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color:
                                    _index == i ? Colors.white : Colors.black),
                          ),
                          Text(
                            DateFormat.E().format(commingWeekDays[i]),
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

class TakeAndDoneWidget extends StatefulWidget {
  const TakeAndDoneWidget({Key? key, required this.medicine}) : super(key: key);
  final Medicine medicine;
  @override
  State<TakeAndDoneWidget> createState() => _TakeAndDoneWidgetState();
}

class _TakeAndDoneWidgetState extends State<TakeAndDoneWidget> {
  String getDisplayTime(String time) {
    String timeResult = '';
    int timeInt = int.parse(time);
    if (timeInt == 0) {
      timeResult = "12 am";
    } else if (timeInt < 12) {
      timeResult = time + " am";
    } else if (timeInt == 12) {
      timeResult = time + " pm";
    } else {
      int replace = timeInt - 12;
      timeResult = time.replaceRange(0, 2, replace.toString()) + " pm";
    }
    return timeResult;
  }

  late Map<String, bool> isdoneDay;
  late List isdoneDayList;

  @override
  Widget build(BuildContext context) {
    isdoneDay = widget.medicine.isDone![
        DateFormat('yMd').format(context.read<AuthProvider>().selectedDate)]!;
    isdoneDayList = isdoneDay.keys.map((e) => int.parse(e)).toList();
    isdoneDayList.sort();
    return SizedBox(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: isdoneDayList
                .map((key) => Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isdoneDay[key.toString()] = true;
                            });
                          },
                          child: Text(
                            getDisplayTime(key.toString()),
                            style: Constant.mediumTextStyle,
                          ),
                        ),
                        isdoneDay[key.toString()]!
                            ? Padding(
                                padding: const EdgeInsets.all(11.0),
                                child: Text("done",
                                    style: Constant.mediumTextStyle
                                        .copyWith(color: Colors.green)),
                              )
                            : ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    isdoneDay[key.toString()] = true;
                                  });
                                  context
                                      .read<AuthProvider>()
                                      .toggleTakeMedicine(
                                          widget.medicine, key.toString());
                                },
                                style: Constant.buttonStyle,
                                child: Text(
                                  "take",
                                  style: Constant.mediumTextStyle
                                      .copyWith(color: Colors.white),
                                ),
                              )
                      ],
                    ))
                .toList()));
  }
}

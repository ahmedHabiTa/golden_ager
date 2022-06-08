import 'package:flutter/material.dart';
import 'package:golden_ager/core/constant/constant.dart';
import 'package:golden_ager/models/request.dart';
import 'package:golden_ager/provider/requests_provider.dart';
import 'package:provider/provider.dart';

import '../../models/notification.dart';

class RequestsItem extends StatefulWidget {
  final Request? request;
  final String userPerview;
  const RequestsItem({Key? key, this.request, required this.userPerview})
      : super(key: key);

  @override
  State<RequestsItem> createState() => _RequestsItemState();
}

class _RequestsItemState extends State<RequestsItem> {
  final Map<String, Color> colorByStatus = {
    "waiting": Colors.amber,
    "accepted": Colors.green,
    "declined": Colors.red
  };

  Padding infoListTile(
    String text1,
    String text2, {
    Color color = Constant.primaryColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
      child: Row(children: [
        Text(text1,
            style: TextStyle(
                color: Constant.primaryColor,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        Text(text2,
            style: TextStyle(
                color: color, fontSize: 18, fontWeight: FontWeight.bold))
      ]),
    );
  }

  late Map<String, List<Widget>> perview;
  @override
  void initState() {
    super.initState();
    perview = {
      "patient": [
        infoListTile(
            widget.request!.requestType == "doctor"
                ? "doctor name : "
                : "mentor name : ",
            widget.request!.requestType == "doctor"
                ? widget.request!.doctor!.name
                : widget.request!.mentor!.name),
        infoListTile(
            "age : ",
            widget.request!.requestType == "doctor"
                ? widget.request!.doctor!.age
                : widget.request!.mentor!.age),
        infoListTile(
            "gender : ",
            widget.request!.requestType == "doctor"
                ? widget.request!.doctor!.gender
                : widget.request!.mentor!.gender),
        infoListTile("status : ", widget.request!.status,
            color: colorByStatus[widget.request!.status]!),
        if (widget.request!.status == "waiting" &&
            widget.request!.requestType == 'mentor')
          DoctorTakeActionRow(request: widget.request!)
      ],
      "doctor": [
        infoListTile("patient name : ", widget.request!.patient.name),
        infoListTile("age : ", widget.request!.patient.age),
        infoListTile("gender : ", widget.request!.patient.gender),
        infoListTile("status : ", widget.request!.status,
            color: colorByStatus[widget.request!.status]!),
        if (widget.request!.status == "waiting")
          DoctorTakeActionRow(request: widget.request!)
      ],
      "mentor": [
        infoListTile("patient name : ", widget.request!.patient.name),
        infoListTile("age : ", widget.request!.patient.age),
        infoListTile("gender : ", widget.request!.patient.gender),
        infoListTile("status : ", widget.request!.status,
            color: colorByStatus[widget.request!.status]!),
      ]
    };
  }

  @override
  void didUpdateWidget(covariant RequestsItem oldWidget) {
    setState(() {
      perview = {
        "patient": [
          infoListTile(
              widget.request!.requestType == "doctor"
                  ? "doctor name : "
                  : "mentor name : ",
              widget.request!.requestType == "doctor"
                  ? widget.request!.doctor!.name
                  : widget.request!.mentor!.name),
          infoListTile(
              "age : ",
              widget.request!.requestType == "doctor"
                  ? widget.request!.doctor!.age
                  : widget.request!.mentor!.age),
          infoListTile(
              "gender : ",
              widget.request!.requestType == "doctor"
                  ? widget.request!.doctor!.gender
                  : widget.request!.mentor!.gender),
          infoListTile("status : ", widget.request!.status,
              color: colorByStatus[widget.request!.status]!),
          if (widget.request!.status == "waiting" &&
              widget.request!.requestType == 'mentor')
            DoctorTakeActionRow(request: widget.request!)
        ],
        "doctor": [
          infoListTile("patient name : ", widget.request!.patient.name),
          infoListTile("age : ", widget.request!.patient.age),
          infoListTile("gender : ", widget.request!.patient.gender),
          infoListTile("status : ", widget.request!.status,
              color: colorByStatus[widget.request!.status]!),
          if (widget.request!.status == "waiting")
            DoctorTakeActionRow(request: widget.request!)
        ],
        "mentor": [
          infoListTile("patient name : ", widget.request!.patient.name),
          infoListTile("age : ", widget.request!.patient.age),
          infoListTile("gender : ", widget.request!.patient.gender),
          infoListTile("status : ", widget.request!.status,
              color: colorByStatus[widget.request!.status]!),
        ]
      };
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.all(8),
        elevation: 5,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(children: [
          Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Constant.primaryColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16))),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  "Request to be Mentor",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              )),
          ...perview[widget.userPerview]!
        ]));
  }
}

class DoctorTakeActionRow extends StatelessWidget {
  const DoctorTakeActionRow({Key? key, required this.request})
      : super(key: key);
  final Request request;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.green,
          ),
          onPressed: () async {
            if (request.requestType == "doctor") {
              await context.read<RequestsProvider>().changeDoctorRequestStatus(
                  context: context, request: request, status: 'accepted');
            } else {
              await context.read<RequestsProvider>().changeMentorRequestStatus(
                  context: context, request: request, status: 'accepted');
            }
          },
          child: Text("Accept",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.red,
          ),
          onPressed: () async {
            if (request.requestType == "doctor") {
              await context.read<RequestsProvider>().changeDoctorRequestStatus(
                  context: context, request: request, status: 'declined');


            } else {
              await context.read<RequestsProvider>().changeMentorRequestStatus(
                  context: context, request: request, status: 'declined');
            }
          },
          child: Text("Decline",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}

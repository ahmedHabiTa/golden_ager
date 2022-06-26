import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:golden_ager/core/common_widget/custom_wide_container.dart';
import 'package:golden_ager/core/constant/age_icon_icons.dart';
import 'package:golden_ager/provider/auth_provider.dart';
import 'package:provider/provider.dart';

import '../../../core/common_widget/custom_text.dart';
import '../../../core/constant/Constant.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import 'SelectBondedDevicePage.dart';

class HealthDataContainer extends StatefulWidget {
  const HealthDataContainer({Key? key}) : super(key: key);

  @override
  State<HealthDataContainer> createState() => _HealthDataContainerState();
}

class _HealthDataContainerState extends State<HealthDataContainer> {
  Future<void> _startChat(BluetoothDevice server) async {
    try {
      connection = await BluetoothConnection.toAddress(server.address);

      if (connection != null) {
        setState(() {
          isConnecting = connection!.isConnected;
        });
        connection!.input!.listen(_onDataReceived);
      }
    } catch (error) {
      isConnecting = false;
      setState(() {});
    }
  }

  @override
  void dispose() {
    connection?.dispose();
    super.dispose();
  }

  List<Color> colors = [
    Colors.red,
    Constant.primaryColor,
  ];
  List<Map<String, dynamic>> texts = [
    {
      "index": 0,
      "title": "Heart Rate",
      "icon": Icons.heart_broken,
    },
    {
      "index": 1,
      "title": "Body Temp",
      "icon": AgeIcon.temperature,
    },
  ];
  BluetoothDevice? selectedDevice;
  @override
  Widget build(BuildContext context) {
    final healthData = context.watch<AuthProvider>().patient!.healthData;
    return Container(
      width: double.infinity,
      height: Constant.height(context) * 0.6,
      color: const Color(0xFFc6dffc),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          Row(
            children: [
              SizedBox(width: 15),
              CustomText(
                text: 'Health Data',
                color: Constant.primaryDarkColor,
                fontSize: 28,
                fontWeight: FontWeight.w400,
              ),
              Spacer(),
              if (isConnected)
                TextButton(
                    onPressed: () {
                      _sendMessage("S");
                    },
                    child: Text(
                      "Refresh",
                      style: Constant.normalTextStyle,
                    )),
              GestureDetector(
                onTap: () async {
                  selectedDevice = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return const SelectBondedDevicePage(
                            checkAvailability: false);
                      },
                    ),
                  );
                  if (selectedDevice != null) {
                    _startChat(selectedDevice!);
                  } else {
                    print('Connect -> no device selected');
                  }

                  setState(() {});
                },
                child: Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: Constant.primaryDarkColor,
                  size: 25,
                ),
              ),
              SizedBox(width: 15),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: Constant.height(context) * 0.4,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _customContainer(
                  context: context,
                  icon: texts[0]['icon'],
                  title: texts[0]['title'],
                  firstText: healthData!.heartData.last + " bpm",
                  secondText: "Lowest " +
                      (healthData.heartData.lowest == "l"
                          ? "0"
                          : healthData.heartData.lowest) +
                      " bpm",
                  thirdText: "Highest " + healthData.heartData.highest + " bpm",
                  color: colors[0],
                ),
                _customContainer(
                  context: context,
                  icon: texts[1]['icon'],
                  title: texts[1]['title'],
                  firstText: healthData.tempData.temp.trim() + " C",
                  secondText: healthData.tempData.status,
                  thirdText: "",
                  color: colors[1],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _customContainer({
    required BuildContext context,
    IconData? icon,
    required String title,
    required String firstText,
    required String secondText,
    required String thirdText,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: CustomWideContainer(
        width: Constant.width(context) * 0.7,
        height: Constant.height(context),
        radius: 20.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 8),
              Row(
                children: [
                  icon != null
                      ? Icon(
                          icon,
                          color: Colors.white,
                          size: 25,
                        )
                      : Container(),
                  const Spacer(),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: CustomText(
                      text: title,
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 15),
                ],
              ),
              const SizedBox(height: 8),
              CustomText(
                text: firstText,
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
              const SizedBox(height: 8),
              CustomText(
                text: secondText,
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
              const SizedBox(height: 8),
              CustomText(
                text: thirdText,
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
        ),
        onTap: () {},
        containerColor: color,
      ),
    );
  }

  final String _messageBuffer = '';
  bool isConnecting = false;
  bool get isConnected => (connection?.isConnected ?? false);
  void _onDataReceived(Uint8List data) {
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    for (var byte in data) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    }
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;
    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    // Create message if there is new line character
    String dataString = String.fromCharCodes(buffer);
    if (dataString.contains("-")) {
      context.read<AuthProvider>().updateHelthData(dataString);
    }
    print(dataString);
  }

  BluetoothConnection? connection;
  static const clientID = 0;
  void _sendMessage(String text) async {
    text = text.trim();
    if (text.isNotEmpty) {
      try {
        connection!.output.add(Uint8List.fromList(utf8.encode(text + "\r\n")));
        await connection!.output.allSent;
      } catch (e) {
        // Ignore error, but notify state
      }
    }
  }
}

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}

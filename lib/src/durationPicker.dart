import 'package:cupertino_new_calendar/src/spacer.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'colors.dart';

class DurationPicker extends StatelessWidget {
  final int? hours;
  final int? minutes;
  final ValueChanged<int>? onChangedHours;
  final ValueChanged<int>? onChangedMinutes;
  final bool? isBorder;
  final bool isInfiniteLoop;
  final bool isCalenderUse;

  const DurationPicker(
      {Key? key,
      @required this.onChangedHours,
      @required this.onChangedMinutes,
      @required this.hours,
      @required this.minutes,
      this.isBorder = true,
      this.isInfiniteLoop = false,
      this.isCalenderUse = false,
      })
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    var ht = MediaQuery.of(context).size.height;
    var wid = MediaQuery.of(context).size.width;
    var orientation = MediaQuery.of(context).orientation;
    bool isPortrait = (orientation == Orientation.portrait) ? true : false;
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: isBorder! ? Border.all(color: greyColor) : null,
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: isPortrait ? (ht * 0.06) : (ht * 0.1),
              width: isPortrait ? (wid * 0.8) : (wid * 0.7),
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NumberPicker(
                  axis: Axis.vertical,
                  infiniteLoop: isInfiniteLoop,
                  minValue: isCalenderUse ? 1 : 00,
                  maxValue: 12,
                  step: 1,
                  // itemHeight: 50,
                  itemWidth: 30,
                  selectedTextStyle: const TextStyle(
                      fontSize: 22.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w700),
                  value: hours!,
                  onChanged: onChangedHours!,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    // border: Border.all(color: Colors.black26),
                  ),
                ),
                // hSpace(5),
                const Text("hours"),
                hSpace(10),
                NumberPicker(
                    axis: Axis.vertical,
                    infiniteLoop: isInfiniteLoop,
                    minValue: 00,
                    maxValue: 59,
                    step: 1,
                    // itemHeight: 50,
                    itemWidth: 40,
                    selectedTextStyle: const TextStyle(
                        fontSize: 22.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w700),
                    value: isCalenderUse ? minutes! : (hours! == 12 ? 0 : minutes!),
                    onChanged: onChangedMinutes!,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      // border: Border.all(color: Colors.black26),
                    )),
                hSpace(5),
                const Text("minutes"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

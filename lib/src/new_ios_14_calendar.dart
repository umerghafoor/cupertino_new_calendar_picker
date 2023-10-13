import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'constants.dart';
import 'durationPicker.dart';

class CustomCalendar extends StatefulWidget {

  final bool isOneHourLater;
  const CustomCalendar({super.key, this.isOneHourLater = false});

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  DateTime? _selectedDate;
  DateTime? returnDate;
  bool? isYearSelected;
  bool? isTimeSelected;
  bool? isAM;
  int? selectedHours;
  int? selectedMinutes;
  List<String> monthNames = repeatMonthNames;



  @override
  void initState() {
    if(widget.isOneHourLater) {
      _selectedDate = DateTime.now()
          .add(Duration(hours: 1, minutes: 1 - DateTime.now().minute % 1));
    } else {
      _selectedDate = DateTime.now();
    }
    isYearSelected = false;
    isTimeSelected = false;
    isAM = _selectedDate!.hour < 12;
    selectedHours = _selectedDate!.hour % 12 == 0 ? 12 : _selectedDate!.hour % 12;
    selectedMinutes = _selectedDate!.minute;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    var orientation = MediaQuery.of(context).orientation;
    bool isPortrait = (orientation == Orientation.portrait) ? true : false;

    if (isPortrait) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }

    Widget calendarBody = isYearSelected!
        ? SizedBox(
      height: screenHeight * (isPortrait ? 0.29 : 0.55),
      child: CupertinoDatePicker(
        initialDateTime: _selectedDate,
        minimumYear: DateTime.now().year,
        maximumYear: 2100,
        mode: CupertinoDatePickerMode.monthYear,
        // maximumDate: ,
        onDateTimeChanged: (DateTime value) {
          _selectedDate = DateTime(value.year, value.month, value.day,
              selectedHours!, selectedMinutes!);
          _selectedDate = timePickerMode(_selectedDate!, selectedHours!, selectedMinutes!, isAM!);
          returnDate = _selectedDate;
          print("_selectedDate====$_selectedDate");
          setState(() {});
        },
      ),
    )
        : isTimeSelected!
        ? SizedBox(
      height: screenHeight * (isPortrait ? 0.29 : 0.55),
      child: DurationPicker(
        isCalenderUse: true,
        isInfiniteLoop: true,
        isBorder: false,
        hours: selectedHours,
        minutes: selectedMinutes,
        onChangedHours: (int value) {
          selectedHours = value;
          _selectedDate = timePickerMode(_selectedDate!, selectedHours!, selectedMinutes!, isAM!);
          returnDate = _selectedDate;
          // print("24hours===${_selectedDate.getTime24()}");
          print("_selectedDate===$_selectedDate");
          setState(() {});
        },
        onChangedMinutes: (int value) {
          selectedMinutes = value;
          // _selectedDate = DateTime(
          //     _selectedDate!.year,
          //     _selectedDate!.month,
          //     _selectedDate!.day,
          //     // 24,
          //     selectedHours!,
          //     selectedMinutes!);
          _selectedDate = timePickerMode(_selectedDate!, selectedHours!, selectedMinutes!, isAM!);
          returnDate = _selectedDate;
          // print("24hours===${_selectedDate.getTime24()}");
          print("_selectedDate===$_selectedDate");
          setState(() {});
        },
      ),
    )
        : Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: 7, // 7 days a week, 6 weeks maximum
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
          ),
          itemBuilder: (BuildContext context, int index) {
            return Center(
              child: Text(
                weekDayName[index].toUpperCase(),
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade400),
              ),
            );
          },
        ),
        GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: 7 * 6, // 7 days a week, 6 weeks maximum
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: isPortrait ? 1 : 1.3,
            crossAxisCount: 7,
          ),
          itemBuilder: (context, index) {
            final day = index -
                DateTime(_selectedDate!.year, _selectedDate!.month, 1)
                    .weekday +
                2;

            return GestureDetector(
              onTap: () {
                if (day > 0 &&
                    day <=
                        DateTime(_selectedDate!.year,
                            _selectedDate!.month + 1, 0)
                            .day) {
                  setState(() {
                    _selectedDate = DateTime(
                        _selectedDate!.year, _selectedDate!.month, day);
                    _selectedDate = timePickerMode(_selectedDate!,
                        selectedHours!, selectedMinutes!, isAM!);
                    returnDate = _selectedDate;
                    print("_selectedDate=====$_selectedDate");
                  });
                }
              },
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    color: day <= 0 ||
                        day >
                            DateTime(_selectedDate!.year,
                                _selectedDate!.month + 1, 0)
                                .day
                        ? Colors.transparent
                        : _isSelectedDay(day)
                        ? Colors.blue.withOpacity(0.1)
                        : Colors.transparent,
                    shape: BoxShape.circle),
                child: Text(
                  day <= 0 ||
                      day >
                          DateTime(_selectedDate!.year,
                              _selectedDate!.month + 1, 0)
                              .day
                      ? ''
                      : '$day',
                  style: TextStyle(
                    fontWeight: _isSelectedDay(day)
                        ? FontWeight.w600
                        : FontWeight.normal,
                    fontSize: isPortrait
                        ? (_isSelectedDay(day) ? 20 : 17)
                        : 15,
                    color: (_isSelectedDay(day) ||
                        day == DateTime.now().day)
                        ? Colors.blue
                        : Colors.black,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );

    List<Widget> topArrowBody = [
      Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              isTimeSelected = false;
              isYearSelected = !isYearSelected!;
              setState(() {});
            },
            child: Text(
              "${monthNames[_selectedDate!.month - 1]} ${_selectedDate!.year}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          const SizedBox(width: 5,),
          Icon(
            isYearSelected!
                ? Icons.keyboard_arrow_down_rounded
                : Icons.arrow_forward_ios_rounded,
            color: Colors.blue,
            size: isYearSelected! ? 30 : 15,
          ),
          Expanded(child: Container()),
          if(!isYearSelected!)
            ...[
              IconButton(
                onPressed: () {
                  setState(() {
                    _selectedDate =
                        _selectedDate?.subtract(const Duration(days: 30));
                    returnDate = _selectedDate;
                  });
                },
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.blue,
                  size: 15,
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: () {
                  setState(() {
                    _selectedDate = _selectedDate?.add(const Duration(days: 30));
                    returnDate = _selectedDate;
                  });
                },
                icon: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.blue,
                  size: 15,
                ),
              ),]
        ],
      ),
      if (isPortrait)
        const SizedBox(
          height: 10,
        ),
    ];

    List<Widget> pickTimeBody = [
      const Text(
        "Time",
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
      ),
      if (isPortrait) Expanded(child: Container()),
      GestureDetector(
        onTap: () {
          isTimeSelected = !isTimeSelected!;
          isYearSelected = false;
          setState(() {});
        },
        child: Container(
          height: 40,
          width: screenWidth * (isPortrait ? 0.25 : 0.3),
          decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              // child: Text("${_selectedDate.hour}:${_selectedDate.minute}",
              child: FittedBox(
                child: Text(
                  _selectedDate!.format12Hour(),
                  // "${_selectedDate.hour <= 9 ? "0${_selectedDate.hour}" : _selectedDate.hour}:${
                  //     _selectedDate.minute <= 9 ? "0${_selectedDate.minute}" : _selectedDate.minute}",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      letterSpacing: 3),
                ),
              ),
            ),
          ),
        ),
      ),
      SizedBox(width: screenWidth * 0.02),
      Container(
        height: 40,
        width: screenWidth * (isPortrait ? 0.32 : 0.3),
        decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    isAM = !isAM!;
                    _selectedDate = timePickerMode(
                        _selectedDate!, selectedHours!, selectedMinutes!, isAM!);
                    returnDate = _selectedDate;
                    print("am_Selected========$_selectedDate");
                    setState(() {});
                  },
                  child: Container(
                    // height: 40,
                    width: screenWidth * 0.14,
                    decoration: BoxDecoration(
                        color: isAM! ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(5)),
                    child: const Center(
                      child: Padding(
                        padding: EdgeInsets.all(6.0),
                        child: Text(
                          "AM",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: screenWidth * 0.01),
                GestureDetector(
                  onTap: () {
                    isAM = !isAM!;
                    _selectedDate = timePickerMode(
                        _selectedDate!, selectedHours!, selectedMinutes!, isAM!);
                    returnDate = _selectedDate;
                    print("pm_Selected========$_selectedDate");
                    setState(() {});
                  },
                  child: Container(
                    // height: 40,
                    width: screenWidth * 0.14,
                    decoration: BoxDecoration(
                        color: !isAM! ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(5)),
                    child: const Center(
                      child: Padding(
                        padding: EdgeInsets.all(6.0),
                        child: Text(
                          "PM",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ];

    return WillPopScope(
      onWillPop: () {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
        ]);
        Navigator.pop(context, returnDate);
        return Future.value(true);
      },
      child: Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        insetPadding: EdgeInsets.symmetric(horizontal: isPortrait ? 20 : 60),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 15.0,
          ),
          child: isPortrait
              ? Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Upper Section
              ...topArrowBody,
              calendarBody,
              // Lower Section
              const Divider(
                thickness: 0.5,
              ),
              Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: pickTimeBody),
            ],
          )
              : Column(
            mainAxisSize: MainAxisSize.min,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ...topArrowBody,
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                      height: screenHeight * 0.57,
                      width: screenWidth / 3,
                      child: calendarBody),
                  const Spacer(),
                  SizedBox(
                      height: screenHeight * 0.57,
                      width: screenWidth / 3,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: pickTimeBody,
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  bool _isSelectedDay(int day) {
    return _selectedDate!.day == day;
  }

  DateTime timePickerMode(DateTime _selectedDate, int selectedHours,
      int selectedMinutes, bool isAM) {
    var formattedHours = selectedHours;
    if (isAM) {
      if (selectedHours == 12) {
        formattedHours = selectedHours + 12;
      }
    } else {
      if (selectedHours != 12) {
        formattedHours = selectedHours + 12;
      }
    }
    _selectedDate = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        // 24,
        formattedHours,
        selectedMinutes);
    return _selectedDate;
  }
}

extension DateTimeExtension on DateTime {
  String format12Hour() {
    // Convert hour to 12-hour format
    int hour12 = this.hour % 12 == 0 ? 12 : this.hour % 12;

    // Add leading zero for single-digit hours
    String hourString = hour12 < 10 ? '0$hour12' : '$hour12';

    // Add leading zero for single-digit minutes
    String minuteString =
    this.minute < 10 ? '0${this.minute}' : '${this.minute}';

    // Determine AM/PM
    String period = this.hour < 12 ? 'AM' : 'PM';

    // Return formatted time
    return '$hourString:$minuteString';
  }
}

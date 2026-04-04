import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/screens/restaurant_owner/model/restaurant_settings_model.dart';

class WorkingHoursPicker extends StatefulWidget {
  final List<WorkingHours> workingHours;
  final bool isEditing;
  final Function(List<WorkingHours>) onUpdate;

  const WorkingHoursPicker({
    super.key,
    required this.workingHours,
    required this.isEditing,
    required this.onUpdate,
  });

  @override
  State<WorkingHoursPicker> createState() => _WorkingHoursPickerState();
}

class _WorkingHoursPickerState extends State<WorkingHoursPicker> {
  late List<WorkingHours> _workingHours;

  @override
  void initState() {
    super.initState();
    _workingHours = List.from(widget.workingHours);
  }

  Future<void> _selectTime(
    BuildContext context,
    WorkingHours hours,
    bool isOpenTime,
  ) async {
    final currentTime = isOpenTime ? hours.openTime : hours.closeTime;
    final picked = await showTimePicker(
      context: context,
      initialTime: currentTime ?? const TimeOfDay(hour: 9, minute: 0),
    );
    if (picked != null) {
      setState(() {
        if (isOpenTime) {
          hours.openTime = picked;
        } else {
          hours.closeTime = picked;
        }
      });
      widget.onUpdate(_workingHours);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          ..._workingHours.map((hours) {
            final dayIndex = _workingHours.indexOf(hours);
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 100.w,
                        child: Text(
                          hours.day,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      if (widget.isEditing)
                        Checkbox(
                          value: hours.isClosed,
                          onChanged: (value) {
                            setState(() {
                              hours.isClosed = value ?? false;
                            });
                            widget.onUpdate(_workingHours);
                          },
                          activeColor: Colors.red,
                        ),
                      if (!widget.isEditing && hours.isClosed)
                        const Expanded(
                          child: Text(
                            'Closed',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      if (!widget.isEditing && !hours.isClosed)
                        Expanded(
                          child: Text(
                            hours.formattedHours,
                            style: const TextStyle(color: Colors.green),
                          ),
                        ),
                      if (widget.isEditing && !hours.isClosed)
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed:
                                      () => _selectTime(context, hours, true),
                                  child: Text(
                                    hours.openTime != null
                                        ? hours.openTime!.format(context)
                                        : 'Set Open',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              const Text('-'),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: OutlinedButton(
                                  onPressed:
                                      () => _selectTime(context, hours, false),
                                  child: Text(
                                    hours.closeTime != null
                                        ? hours.closeTime!.format(context)
                                        : 'Set Close',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                if (dayIndex < _workingHours.length - 1)
                  Divider(height: 1, color: Colors.grey.shade200),
              ],
            );
          }),
        ],
      ),
    );
  }
}

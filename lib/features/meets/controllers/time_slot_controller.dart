// import 'package:intl/intl.dart';
//
//
//
// class RestaurantHours {
//   final TimeOfDay openingTime;
//   final TimeOfDay closingTime;
//
//   RestaurantHours({required this.openingTime, required this.closingTime});
// }
//
// class TimeOfDay {
//   final int hour;
//   final int minute;
//
//   TimeOfDay({required this.hour, required this.minute});
//
//   TimeOfDay operator +(TimeOfDay other) {
//     int newMinute = (minute + other.minute) % 60;
//     int newHour = hour + other.hour + (minute + other.minute) ~/ 60;
//     return TimeOfDay(hour: newHour, minute: newMinute);
//   }
//
//   TimeOfDay operator -(TimeOfDay other) {
//     int newMinute = (minute - other.minute) % 60;
//     int newHour = hour - other.hour + (minute - other.minute) ~/ 60;
//     return TimeOfDay(hour: newHour, minute: newMinute);
//   }
//
//   int toMinutes() {
//     return hour * 60 + minute;
//   }
//
//   @override
//   String toString() {
//     return '$hour:${minute.toString().padLeft(2, '0')}';
//   }
// }
//
// class DateTimeRange {
//   final DateTime start;
//   final DateTime end;
//
//   DateTimeRange({required this.start, required this.end});
// }
//
// class Restaurant {
//   final Map<String, RestaurantHours> weeklyHours;
//
//   Restaurant({required this.weeklyHours});
//
//   List<DateTimeRange> getAvailableTimeSlots(DateTime date, {TimeOfDay currentTime = const TimeOfDay(hour: 0, minute: 0), int slotInterval = 30}) {
//     final restaurantHours = _getRestaurantHoursForDate(date);
//
//     if (currentTime < restaurantHours.start) {
//       currentTime = restaurantHours.start;
//     }
//
//     List<DateTimeRange> availableSlots = [];
//
//     DateTime currentSlotStart = DateTime(date.year, date.month, date.day, currentTime.hour, currentTime.minute);
//     DateTime currentSlotEnd = currentSlotStart.add(Duration(minutes: slotInterval));
//
//     while (currentSlotEnd.isBefore(restaurantHours.end)) {
//       if (currentSlotEnd.isAfter(restaurantHours.start)) {
//         availableSlots.add(DateTimeRange(start: currentSlotStart, end: currentSlotEnd));
//       }
//
//       currentSlotStart = currentSlotEnd;
//       currentSlotEnd = currentSlotStart.add(Duration(minutes: slotInterval));
//     }
//
//     return availableSlots;
//   }
//
//   RestaurantHours _getRestaurantHoursForDate(DateTime date) {
//     final dayName = DateFormat('EEEE').format(date);
//     final hours = weeklyHours[dayName] ?? weeklyHours['default']!;
//
//     DateTime startDateTime = DateTime(date.year, date.month, date.day, hours.openingTime.hour, hours.openingTime.minute);
//     DateTime endDateTime = DateTime(date.year, date.month, date.day, hours.closingTime.hour, hours.closingTime.minute);
//
//     if (endDateTime.isBefore(startDateTime)) {
//       endDateTime = endDateTime.add(const Duration(days: 1)); // Restaurant spans across midnight
//     }
//
//     return RestaurantHours(
//       openingTime: TimeOfDay(hour: startDateTime.hour, minute: startDateTime.minute),
//       closingTime: TimeOfDay(hour: endDateTime.hour, minute: endDateTime.minute),
//     );
//   }
// }
//
// void main() {
//   final restaurant = Restaurant(
//     weeklyHours: {
//       'Monday': RestaurantHours(openingTime: TimeOfDay(hour: 10, minute: 0), closingTime: TimeOfDay(hour: 22, minute: 0)),
//       'Tuesday': RestaurantHours(openingTime: TimeOfDay(hour: 10, minute: 0), closingTime: TimeOfDay(hour: 22, minute: 0)),
//       'default': RestaurantHours(openingTime: TimeOfDay(hour: 0, minute: 0), closingTime: TimeOfDay(hour: 0, minute: 0)), // Default for unknown days
//     },
//   );
//
//   // Test Scenarios
//   final testScenarios = [
//     {
//       'date': DateTime(2023, 8, 27),
//       'currentTime': TimeOfDay(hour: 9, minute: 0),
//       'expectedSlots': [],
//     },
//     {
//       'date': DateTime(2023, 8, 27),
//       'currentTime': TimeOfDay(hour: 14, minute: 0),
//       'expectedSlots': ['14:00 - 14:30', '14:30 - 15:00', '15:00 - 15:30', '15:30 - 16:00', '16:00 - 16:30', '16:30 - 17:00', '17:00 - 17:30', '17:30 - 18:00', '18:00 - 18:30', '18:30 - 19:00', '19:00 - 19:30', '19:30 - 20:00', '20:00 - 20:30', '20:30 - 21:00', '21:00 - 21:30', '21:30 - 22:00'],
//     },
//     // Add more scenarios
//   ];
//
//   // Run tests
//   for (final scenario in testScenarios) {
//     final selectedDate = scenario['date'];
//     final currentTime = scenario['currentTime'];
//
//     final availableTimeSlots = restaurant.getAvailableTimeSlots(selectedDate, currentTime: currentTime);
//
//     // Compare actual and expected results (ignoring minute accuracy)
//     final actualSlots = availableTimeSlots.map((slot) => '${slot.start.hour}:${slot.start.minute} - ${slot.end.hour}:${slot.end.minute}').toList();
//     final expectedSlots = scenario['expectedSlots'];
//     if (actualSlots.toString() != expectedSlots.toString()) {
//       print('Test failed for scenario:');
//       print('Date: $selectedDate, Current Time: $currentTime');
//       print('Expected: $expectedSlots');
//       print('Actual: $actualSlots');
//       print('============================');
//     }
//   }
// }

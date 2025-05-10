
class Booking {
  final String name;
  final String address;
  final String phone;
  final String email;
  final String date;
  final String time;
  final String duration;
  final int guests;
  final String requests;

  Booking({
    required this.name,
    required this.address,
    required this.phone,
    required this.email,
    required this.date,
    required this.time,
    required this.duration,
    required this.guests,
    required this.requests,
  });
  
}

Navigator.pop(context, bookingObject); // instead of setState or printing

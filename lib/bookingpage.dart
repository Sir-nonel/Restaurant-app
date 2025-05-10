import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'booking.dart';
import 'menu.dart';

void main() => runApp(RestaurantApp());

class RestaurantApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant Booking',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      home: BookingPage(),
    );
  }
}

class BookingPage extends StatefulWidget {
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _additionalRequestController =
      TextEditingController();

  DateTime? _reservationDate;
  TimeOfDay? _reservationTime;
  String? _duration;
  int? _guests;

  String _displayInfo = "";

  Future<void> _pickDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        _reservationDate = date;
      });
    }
  }

  Future<void> _pickTime() async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      setState(() {
        _reservationTime = time;
      });
    }
  }

  Future<void> _saveDataLocally(String info) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('reservation_info', info);
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() &&
        _reservationDate != null &&
        _reservationTime != null &&
        _duration != null &&
        _guests != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(_reservationDate!);
      String formattedTime = _reservationTime!.format(context);
      String info = '''
        Name: ${_nameController.text}
        Address: ${_addressController.text}
        Phone: ${_phoneController.text}
        Email: ${_emailController.text}
        Date: $formattedDate
        Time: $formattedTime
        Duration: $_duration
        Guests: $_guests
        Requests: ${_additionalRequestController.text}
        ''';

      setState(() {
        final bookingObject = Booking(
          name: _nameController.text,
          address: _addressController.text,
          phone: _phoneController.text,
          email: _emailController.text,
          date: formattedDate,
          time: formattedTime,
          duration: _duration!,
          guests: _guests!,
          requests: _additionalRequestController.text,
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => MenuPage(cart: cartObject, booking: bookingObject),
          ),
        );
      });

      _saveDataLocally(info);
    } else {
      setState(() {
        _displayInfo = "Please fill out all required fields correctly.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(title: Text('Restaurant Booking'), centerTitle: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Enter your details",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Address'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone No'),
                keyboardType: TextInputType.phone,
                validator:
                    (value) =>
                        value!.isEmpty || value.length < 10
                            ? 'Enter valid phone number'
                            : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator:
                    (value) =>
                        value!.isEmpty || !value.contains('@')
                            ? 'Enter valid email'
                            : null,
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _reservationDate == null
                          ? 'Select Reservation Date'
                          : 'Date: ${DateFormat('yyyy-MM-dd').format(_reservationDate!)}',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _pickDate,
                    child: Text('Pick Date'),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _reservationTime == null
                          ? 'Select Reservation Time'
                          : 'Time: ${_reservationTime!.format(context)}',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _pickTime,
                    child: Text('Pick Time'),
                  ),
                ],
              ),
              SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Duration'),
                items:
                    ['3 hours', '4 hours', '5 hours']
                        .map(
                          (val) =>
                              DropdownMenuItem(value: val, child: Text(val)),
                        )
                        .toList(),
                onChanged: (val) => _duration = val,
                validator: (val) => val == null ? 'Select duration' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _additionalRequestController,
                decoration: InputDecoration(
                  labelText: 'Additional Requests (e.g. Birthday/Decoration)',
                ),
              ),
              SizedBox(height: 12),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(labelText: 'Number of Guests'),
                items:
                    List.generate(20, (index) => index + 1)
                        .map(
                          (val) =>
                              DropdownMenuItem(value: val, child: Text('$val')),
                        )
                        .toList(),
                onChanged: (val) => _guests = val,
                validator:
                    (val) => val == null ? 'Select number of guests' : null,
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 12,
                    ),
                    child: Text(
                      'Submit Reservation',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                _displayInfo,
                style: TextStyle(fontSize: 16, color: Colors.teal[800]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

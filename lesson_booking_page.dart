import 'package:flutter/material.dart';
import 'checkoutpage.dart'; // Import the CheckoutPage widget

class LessonBookingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Tennis Lesson'),
      ),
      body: LessonBookingForm(),
    );
  }
}

class LessonBookingForm extends StatefulWidget {
  @override
  _LessonBookingFormState createState() => _LessonBookingFormState();
}

class _LessonBookingFormState extends State<LessonBookingForm> {
  late DateTime _selectedDate;
  int _numberOfPlayers = 1;
  int _lessonDuration = 1; // Default duration is 1 hour

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Select Date:'),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              _selectDate(context);
            },
            child: Text('Select Date'),
          ),
          SizedBox(height: 20),
          Text('Number of Players:'),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () {
                  setState(() {
                    if (_numberOfPlayers > 1) {
                      _numberOfPlayers--;
                    }
                  });
                },
              ),
              Text('$_numberOfPlayers'),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    _numberOfPlayers++;
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 20),
          Text('Lesson Duration (hours):'),
          SizedBox(height: 10),
          DropdownButton<int>(
            value: _lessonDuration,
            onChanged: (value) {
              setState(() {
                _lessonDuration = value!;
              });
            },
            items: [1, 2, 3, 4, 5].map<DropdownMenuItem<int>>((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text('$value'),
              );
            }).toList(),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Calculate price based on number of players and lesson duration
              int price = calculatePrice();
              // Show price or further booking steps
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Lesson Price'),
                    content: Text('\$$price'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          // Navigate to CheckoutPage
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CheckoutPage()),
                          );
                        },
                        child: Text('Book Lesson'),
                      ),
                    ],
                  );
                },
              );
            },
            child: Text('Book Lesson'),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  int calculatePrice() {
    // Define price rates
    const int pricePerHour1Player = 30;
    const int pricePerHour2Players = 50;
    const int pricePerExtraPlayer = 25;

    // Calculate total price based on number of players and lesson duration
    int totalPrice;
    if (_numberOfPlayers == 1) {
      totalPrice = _lessonDuration * pricePerHour1Player;
    } else {
      totalPrice = _lessonDuration * pricePerHour2Players +
          (_numberOfPlayers - 1) * pricePerExtraPlayer;
    }
    return totalPrice;
  }
}

void main() {
  runApp(MaterialApp(
    home: LessonBookingPage(),
  ));
}

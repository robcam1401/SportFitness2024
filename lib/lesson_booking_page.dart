import 'package:flutter/material.dart';
import 'checkoutpage.dart'; // Import the CheckoutPage widget

class LessonBookingPage extends StatelessWidget {
  final String name;
  final String resourceID;
  final bool numPlayers;
  final bool bookDate;
  final bool duration;
  final int pricePerson;
  final int priceHour;

    const LessonBookingPage({Key? key, 
    required this.name, 
    required this.resourceID,
    required this.numPlayers,
    required this.bookDate,
    required this.duration,
    required this.pricePerson,
    required this.priceHour})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: LessonBookingForm(name: name, resourceID: resourceID, numPlayers: numPlayers, bookDate: bookDate, duration: duration,priceHour: priceHour, pricePerson: pricePerson,),
    );
  }
}

class LessonBookingForm extends StatefulWidget {
    final String name;
    final String resourceID;
    final bool numPlayers;
    final bool bookDate;
    final bool duration;
    final int pricePerson;
    final int priceHour;

    const LessonBookingForm({Key? key, 
    required this.name, 
    required this.resourceID,
    required this.numPlayers,
    required this.bookDate,
    required this.duration,
    required this.pricePerson,
    required this.priceHour})
      : super(key: key);
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
    List<Widget> np; // the list of widgets for the number of players
    List<Widget> ld; // the list of widgets for the lesson duration
    List<Widget> bd; // the list of widgets for the book date
    List<Widget> pc; // the list of widgets to calculate the price
    int ppp = 0; // price per person
    int pph = 0; // price per hour
    if (widget.numPlayers) {
      ppp = widget.pricePerson;
      np = [Text('Number of Players at \$$ppp per hour:'),
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
        )
      ];
    }
    else {
      np = [];
    }
    if (widget.bookDate) {
      bd = [
        Row(
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
            SizedBox(height:20)
          ]
        )
      ];
    }
    else {
      bd = [];
    }
    if (widget.duration) {
      pph = widget.priceHour;
      ld = [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Lesson Duration (hours) at \$$pph per hour:'),
            SizedBox(height: 20),
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
            SizedBox(height: 20)
          ]
        )
      ];
    }
    else {
      ld = [];
    }
    pc = [
      ElevatedButton(
        onPressed: () {
          // Calculate price based on number of players and lesson duration
          int price = calculatePrice(ppp,pph, _numberOfPlayers, _lessonDuration);
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
    ];


    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: bd+np+ld+pc
      )
    );
    // return Padding(
    //   padding: EdgeInsets.all(20.0),
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       Text('Select Date:'),
    //       SizedBox(height: 10),
    //       ElevatedButton(
    //         onPressed: () {
    //           _selectDate(context);
    //         },
    //         child: Text('Select Date'),
    //       ),
    //       SizedBox(height: 20),
    //       Text('Number of Players:'),
    //       SizedBox(height: 10),
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           IconButton(
    //             icon: Icon(Icons.remove),
    //             onPressed: () {
    //               setState(() {
    //                 if (_numberOfPlayers > 1) {
    //                   _numberOfPlayers--;
    //                 }
    //               });
    //             },
    //           ),
    //           Text('$_numberOfPlayers'),
    //           IconButton(
    //             icon: Icon(Icons.add),
    //             onPressed: () {
    //               setState(() {
    //                 _numberOfPlayers++;
    //               });
    //             },
    //           ),
    //         ],
    //       ),
    //       SizedBox(height: 20),
    //       Text('Lesson Duration (hours):'),
    //       SizedBox(height: 10),
    //       DropdownButton<int>(
    //         value: _lessonDuration,
    //         onChanged: (value) {
    //           setState(() {
    //             _lessonDuration = value!;
    //           });
    //         },
    //         items: [1, 2, 3, 4, 5].map<DropdownMenuItem<int>>((int value) {
    //           return DropdownMenuItem<int>(
    //             value: value,
    //             child: Text('$value'),
    //           );
    //         }).toList(),
    //       ),
    //       SizedBox(height: 20),
    //       ElevatedButton(
    //         onPressed: () {
    //           // Calculate price based on number of players and lesson duration
    //           int price = calculatePrice();
    //           // Show price or further booking steps
    //           showDialog(
    //             context: context,
    //             builder: (BuildContext context) {
    //               return AlertDialog(
    //                 title: Text('Lesson Price'),
    //                 content: Text('\$$price'),
    //                 actions: [
    //                   TextButton(
    //                     onPressed: () {
    //                       // Navigate to CheckoutPage
    //                       Navigator.push(
    //                         context,
    //                         MaterialPageRoute(builder: (context) => CheckoutPage()),
    //                       );
    //                     },
    //                     child: Text('Book Lesson'),
    //                   ),
    //                 ],
    //               );
    //             },
    //           );
    //         },
    //         child: Text('Book Lesson'),
    //       ),
    //     ],
    //   ),
    // );
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

  int calculatePrice(int ppp,int pph, int players, int hours) {
    // Define price rates
    const int pricePerHour1Player = 30;
    const int pricePerHour2Players = 50;
    const int pricePerExtraPlayer = 25;

    print("ppp: $ppp");
    print("pph: $pph");
    // Calculate total price based on number of players and lesson duration
    int totalPrice = (ppp*players)+(pph*hours);
    // if (_numberOfPlayers == 1) {
    //   totalPrice = _lessonDuration * pricePerHour1Player;
    // } else {
    //   totalPrice = _lessonDuration * pricePerHour2Players +
    //       (_numberOfPlayers - 1) * pricePerExtraPlayer;
    // }
    return totalPrice;
  }
}

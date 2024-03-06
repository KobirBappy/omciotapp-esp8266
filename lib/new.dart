//  @override
//   void initState() {
//     super.initState();
//     _loadButtonStatesFromDatabase();
//     _buttonsRef.onValue.listen((event) {
//       var data = event.snapshot.value;
//       if (data != null && data is Map<dynamic, dynamic>) {
//         for (int i = 0; i < _buttonColors.length; i++) {
//           for (int j = 0; j < _buttonColors[i].length; j++) {
//             String key = 'button$i$j';
//             if (data.containsKey(key)) {
//               setState(() {
//                 _buttonColors[i][j] =
//                     data[key]['state'] == '1' ? _getColor(j) : Colors.blue;
//                 _buttonQuantities[i][j] = data[key]['quantity'] ?? 0;
//               });
//             }
//           }
//         }
//       }
//     });
//   }




// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'OMC Footwear',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: ButtonControlPage(),
//     );
//   }
// }

// class ButtonControlPage extends StatefulWidget {
//   @override
//   _ButtonControlPageState createState() => _ButtonControlPageState();
// }

// class _ButtonControlPageState extends State<ButtonControlPage> {
//   final DatabaseReference _buttonsRef =
//       FirebaseDatabase.instance.reference().child('buttons');

//   List<List<Color>> _buttonColors = List.generate(
//     12,
//     (_) => List.generate(3, (_) => Colors.blue),
//   );

//   @override
//   void initState() {
//     super.initState();
//     _loadButtonStatesFromDatabase();
//     _buttonsRef.onValue.listen((event) {
//       var data = event.snapshot.value;
//       if (data != null && data is Map<dynamic, dynamic>) {
//         for (int i = 0; i < _buttonColors.length; i++) {
//           for (int j = 0; j < _buttonColors[i].length; j++) {
//             String key = 'button$i$j';
//             if (data.containsKey(key)) {
//               setState(() {
//                 _buttonColors[i][j] =
//                     data[key]['state'] == '1' ? _getColor(j) : Colors.blue;
               
//               });
//             }
//           }
//         }
//       }
//     });
//   }

//   String _getButtonName(int colIndex) {
//     List<String> colors = ['Hamper', 'On Process', 'OK'];
//     return '${colors[colIndex]}';
//   }

//   Future<void> _loadButtonStatesFromDatabase() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     for (int i = 0; i < _buttonColors.length; i++) {
//       for (int j = 0; j < _buttonColors[i].length; j++) {
//         String colorString =
//             prefs.getString('button$i$j') ?? Colors.blue.toString();
//         setState(() {
//           _buttonColors[i][j] = Color(int.parse(colorString));
//         });
//       }
//     }
//   }

//   Color _getColor(int index) {
//     switch (index) {
//       case 0:
//         return Colors.red;
//       case 1:
//         return Colors.yellow;
//       case 2:
//         return Colors.green;
//       default:
//         return Colors.blue;
//     }
//   }

//   Future<void> _toggleButtonColor(int rowIndex, int colIndex) async {
//     Color currentColor = _buttonColors[rowIndex][colIndex];
//     Color newColor =
//         currentColor == Colors.blue ? _getColor(colIndex) : Colors.blue;
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString(
//         'button$rowIndex$colIndex', newColor.value.toString());
//     _buttonsRef
//         .child('button$rowIndex$colIndex')
//         .set(newColor == Colors.blue ? '1' : '0');
//     setState(() {
//       _buttonColors[rowIndex][colIndex] = newColor;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Center(child: Text('OMC Automation')),
//       ),
//       body: Column(
//         children: [
//           Text('Image'),
//           Column(
//             children: List.generate(
//               12,
//               (rowIndex) => Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Text('Line ${rowIndex + 1}'),
//                   ...List.generate(
//                     3,
//                     (colIndex) => ElevatedButton(
//                       onPressed: () {
//                         _toggleButtonColor(rowIndex, colIndex);
//                       },
//                       style: ButtonStyle(
//                         backgroundColor:
//                             MaterialStateProperty.resolveWith<Color>(
//                           (Set<MaterialState> states) {
//                             return _buttonColors[rowIndex][colIndex];
//                           },
//                         ),
//                       ),
//                       child: SizedBox(
//                         child: Text(_getButtonName(colIndex)),
//                         width: 60,
//                         height: 40,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

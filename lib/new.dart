// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Button Grid with Firebase',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: LoginPage(),
//     );
//   }
// }

// class LoginPage extends StatelessWidget {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   Future<void> _login(BuildContext context) async {
//     try {
//       UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//         email: _emailController.text.trim(),
//         password: _passwordController.text.trim(),
//       );
//       // If login is successful, navigate to the ButtonControlPage
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => ButtonControlPage()),
//       );
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'user-not-found') {
//         print('No user found for that email.');
//       } else if (e.code == 'wrong-password') {
//         print('Wrong password provided for that user.');
//       } else {
//         print('Error: $e');
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Login'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: _emailController,
//               decoration: InputDecoration(
//                 labelText: 'Email',
//               ),
//             ),
//             SizedBox(height: 20),
//             TextField(
//               controller: _passwordController,
//               decoration: InputDecoration(
//                 labelText: 'Password',
//               ),
//               obscureText: true,
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () => _login(context),
//               child: Text('Login'),
//             ),
//           ],
//         ),
//       ),
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
//   List<List<int>> _buttonQuantities = List.generate(
//     12,
//     (_) => List.generate(3, (_) => 0),
//   );
//   @override
//   void initState() {
//     super.initState();
//     _loadButtonStatesFromDatabase();
//     _buttonsRef.onValue.listen((event) {
//       // Update button states and quantities according to database data
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
//         .child('state')
//         .set(newColor == Colors.blue ? '0' : '1');
//     setState(() {
//       _buttonColors[rowIndex][colIndex] = newColor;
//     });
//   }

//   void _setQuantity(int rowIndex, int colIndex, int quantity) async {
//     _buttonsRef
//         .child('button$rowIndex$colIndex')
//         .child('quantity')
//         .set(quantity);
//     setState(() {
//       _buttonQuantities[rowIndex][colIndex] = quantity;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Center(child: Text('Button Control')),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: List.generate(
//             12,
//             (rowIndex) => Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Text('Line ${rowIndex + 1}'),
//                 ...List.generate(
//                   3,
//                   (colIndex) => Column(
//                     children: [
//                       ElevatedButton(
//                         onPressed: () {
//                           _toggleButtonColor(rowIndex, colIndex);
//                         },
//                         style: ButtonStyle(
//                           backgroundColor:
//                               MaterialStateProperty.resolveWith<Color>(
//                             (Set<MaterialState> states) {
//                               return _buttonColors[rowIndex][colIndex];
//                             },
//                           ),
//                         ),
//                         child: SizedBox(
//                           child: Text(_getButtonName(colIndex)),
//                           width: 60,
//                           height: 40,
//                         ),
//                       ),
//                       SizedBox(height: 8),
//                       SizedBox(
//                         width: 60,
//                         child: TextField(
//                           keyboardType: TextInputType.number,
//                           decoration: InputDecoration(labelText: 'Quantity'),
//                           onChanged: (value) {
//                             _setQuantity(
//                                 rowIndex, colIndex, int.tryParse(value) ?? 0);
//                           },
//                           controller: TextEditingController(
//                               text: _buttonQuantities[rowIndex][colIndex]
//                                   .toString()),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//      ),
//      );
//      }
// }















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
  //   12,
  //   (_) => List.generate(3, (_) => Colors.blue),
  // );

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

  import 'package:flutter/material.dart';
  import 'package:app/pages/home_page.dart';

  class Authentification_page extends StatelessWidget {
  const Authentification_page({Key? key});

  @override
  Widget build(BuildContext context) {
  return Scaffold(body: Login());
  }
  }

  class Login extends StatefulWidget {
  const Login({Key? key});

  @override
  State<Login> createState() => _LoginState();
  }

  class _LoginState extends State<Login> {
  void navigateToNextPage() {
  Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => HomePage()),
  );
  }

  @override
  Widget build(BuildContext context) {
  return Padding(
  padding: const EdgeInsets.all(30),
  child: Stack(
  children: [
  Column(
  mainAxisAlignment: MainAxisAlignment.center,
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
  const Text(
  "WELCOME TO SMART HOME",
  style: TextStyle(
  color: Colors.black87,
  fontSize: 25,
  height: -10,
  fontWeight: FontWeight.bold,
  ),
  ),
  ],
  ),
  Column(
  mainAxisAlignment: MainAxisAlignment.end,
  children: [
  const TextField(
  keyboardType: TextInputType.name,
  decoration: InputDecoration(
  hintText: "User name",
  prefixIcon: Icon(Icons.verified_user_rounded, color: Colors.black),
  ),
  ),
  const SizedBox(
  height:20,
  ),
  const TextField(
  obscureText: true,
  keyboardType: TextInputType.name,
  decoration: InputDecoration(
  hintText: "User Password",
  prefixIcon: Icon(Icons.lock, color: Colors.black),
  ),
  ),
  const SizedBox(
  height: 15,
  ),
  Container(
  width: double.infinity,
  child: RawMaterialButton(
  fillColor: Colors.blueGrey,
  shape: RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(20)
  ),
  onPressed: () {
  navigateToNextPage();
  },
  child: Text("Login"),
  ),
  ),
  ],
  ),
  ],
  ),
  );
  }
  }

  class AnotherPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  return Scaffold(
  appBar: AppBar(
  title: Text('Another Page'),
  ),
  body: Center(
  child: Text('This is another page'),
  ),
  );
  }
  }

































// import 'package:flutter/material.dart';
// //import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter/cupertino.dart';

// class Authentification_page extends StatefulWidget {
//   const Authentification_page({super.key});

//   @override
//   State<Authentification_page> createState() => _Authentification_pageState();
// }

// class _Authentification_pageState extends State<Authentification_page> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(body: Login());
//   }
// }

// class Login extends StatefulWidget {
//   const Login({super.key});

//   @override
//   State<Login> createState() => _LoginState();
// }

// class _LoginState extends State<Login> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(30),

//       child: Stack(
//         children: [
//           Column(
            
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const Text(
//                 "WELCOME TO SMART HOME",
//                 style: TextStyle(
//                   color: Colors.black87,
//                   fontSize: 25,
//                   height: -10,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ]
//           ),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               const TextField(
//                 keyboardType: TextInputType.name,
//                 decoration: const InputDecoration(
//                   hintText: "User name",
//                   prefixIcon: Icon(Icons.verified_user_rounded, color: Colors.black),
//                 ),
//               ),
//               const SizedBox(
//                 height:20,
//               ),
//               const TextField(
//                 obscureText: true,
//                 keyboardType: TextInputType.name,
//                 decoration: const InputDecoration(
//                   hintText: "User Password",
//                   prefixIcon: Icon(Icons.lock, color: Colors.black),
//                 ),
//               ),
//               const SizedBox(
//                 height: 15,
//               ),
//               Container(
//                 width: double.infinity,
//                 child: RawMaterialButton(
//                   fillColor: Colors.blueGrey,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20)
//                   ),
//                   onPressed: () {},
//                   child: Text("Login"),
//                 )
//               )
//             ],
//           )  
//         ],
//       ),
//     );
//   }
// }

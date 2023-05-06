import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255,236,239,241),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromARGB(255,132,78,244),
                    Color.fromARGB(255,212,47,245)
                  ]
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(45),
                  bottomRight: Radius.circular(45),
                )
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/logo.png', width: 160),
                    const Text('SmartPhome',
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 80),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 40),
                        child:const TextField(
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(
                              color: Color.fromARGB(255, 241,196,250)
                            ),
                            fillColor: Color.fromARGB(40, 255, 255, 255),
                            filled: true, // ajouter l'oppacite
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(50)
                              ),
                            ),
                            contentPadding:
                              EdgeInsets.only(left: 30), 
                          )
                        ),
                      )
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 80),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 40),
                        child:const TextField(
                          decoration: InputDecoration(
                            labelText: 'Mot de passe', // Criminel
                            labelStyle: TextStyle(
                              color: Color.fromARGB(255, 241,196,250)
                            ),
                            fillColor: Color.fromARGB(40, 255, 255, 255),
                            filled: true, // ajouter l'oppacite
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(50)
                              ),
                            ),
                            contentPadding:
                              EdgeInsets.only(left: 30),
                          )
                        ),
                      )
                    )
                  ],
                )
              ),
            )
          ),
          Expanded(
            flex: 1,
            child: Container(

            )
          ),
        ],
      ),
    );
  }
}
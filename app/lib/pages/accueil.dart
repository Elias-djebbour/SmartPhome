import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(  
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 236,239,241),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50),
            bottomRight: Radius.circular(50),
          )
        ),
        child: Stack(
          children: [
            Align(
              alignment: const Alignment(0.9,-0.85),
              child: IconButton(
                onPressed: () => print('salut'),
                icon: const Icon(Icons.menu),
                iconSize: 40,
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home'
          ),
        ],
        elevation: 0.0,
      ),
    );
  }
}
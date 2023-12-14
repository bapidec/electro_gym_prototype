import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'dart:math';
import 'package:barcode_widget/barcode_widget.dart';

const Color minunBlue = Color(0xff0dd4ff);
const Color minunBlueDark = Color.fromARGB(255, 7, 132, 160);
const Color minunYellow = Color(0xfff5f6b5);
const Color minunYellowDark = Color.fromARGB(255, 186, 187, 137);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: minunBlue,
        appBarTheme: const AppBarTheme(
          backgroundColor: minunYellow,
          foregroundColor: minunBlue),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  double _power = 500.0;
  int _totalPointsPrevious = 0, _totalPointsCurrent  = 0, _points = 0;
  Random random = Random();

  @override
  void initState() {
    super.initState();

    Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      setState(() {
        _power += (random.nextDouble() * 16.0) + 1.0;
        _totalPointsCurrent = _power ~/ 10;
        _points += _totalPointsCurrent - _totalPointsPrevious;
        _totalPointsPrevious = _totalPointsCurrent;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: const Icon(Icons.qr_code_scanner_sharp, color: minunBlueDark,),
          title: Text(
            "KiloWatGym",
            style: GoogleFonts.getFont('Press Start 2P')
          ),
          bottom: const TabBar(
            tabs: <Widget> [
              Tab(
                icon: Icon(
                  Icons.fitness_center,
                  color: minunBlueDark,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.shopping_bag,
                  color: minunBlueDark,
                ),
              )
            ]
          ),
        ),
        body: TabBarView(
          children: <Widget> [
            _buildMeter(),
            _buildItemsList(),
          ]
        ),
      ),
    );
  }

  Widget _buildMeter() {
    return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              
              children: [
                AnimatedFlipCounter(
                  value: _power >= 10000.0 ? _power / 1000.0 : _power,
                  duration: const Duration(seconds: 1),
                  curve: Curves.bounceOut,
                  wholeDigits:  _power >= 10000.0 ? 2 : 4,
                  fractionDigits:  _power >= 10000.0 ? 3 : 2,
                  textStyle: GoogleFonts.orbitron(
                    textStyle: const TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.bold,
                      color: minunBlue,
                      shadows: [
                        BoxShadow(
                          color: minunYellowDark,
                          offset: Offset(1, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  suffix: _power >= 10000.0 ? 'kW' : 'W',
                ),
                const SizedBox(height: 36,),
                AnimatedFlipCounter(
                  prefix: 'Punkty: ',
                  value: _points,
                  textStyle: GoogleFonts.pressStart2p(
                    textStyle: const TextStyle(
                      color: minunBlueDark,
                      fontSize: 20.0,
                    )
                  )
                ),
              ],
            ),
          );
  }

  Widget _buildItemsList() {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(7.0),
          child: Column(
            children: [
              Column(
                children: [
                  BarcodeWidget(
                    barcode: Barcode.codabar(), // Barcode type and settings
                    data: '640509-040147', // Content
                    height: 100,
                  ),
                ],
              ),
              Expanded(
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    _buildItemCard(cost: 10, title: 'Nagroda 1', icon: const Icon(Icons.card_giftcard_sharp)),
                    _buildItemCard(cost: 20, title: 'Nagroda 2', icon: const Icon(Icons.card_giftcard_sharp)),
                    _buildItemCard(cost: 30, title: 'Nagroda 3', icon: const Icon(Icons.card_giftcard_sharp)),
                    _buildItemCard(cost: 40, title: 'Nagroda 4', icon: const Icon(Icons.card_giftcard_sharp)),
                    _buildItemCard(cost: 50, title: 'Nagroda 5', icon: const Icon(Icons.card_giftcard_sharp)),
                    _buildItemCard(cost: 60, title: 'Nagroda 6', icon: const Icon(Icons.card_giftcard_sharp)),
                    _buildItemCard(cost: 70, title: 'Nagroda 7', icon: const Icon(Icons.card_giftcard_sharp)),
                    _buildItemCard(cost: 80, title: 'Nagroda 8', icon: const Icon(Icons.card_giftcard_sharp)),
                    _buildItemCard(cost: 90, title: 'Nagroda 9', icon: const Icon(Icons.card_giftcard_sharp)),
                    _buildItemCard(cost: 100, title: 'Nagroda 10', icon: const Icon(Icons.card_giftcard_sharp)),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
  }

  Widget _buildItemCard({required cost, required title, required Icon icon}) {
      return Padding(
        padding: const EdgeInsets.all(1.0),
        child: Card(
          color: Colors.white,
          elevation: 2.0,
          shadowColor: minunYellowDark,
          surfaceTintColor: minunBlue,
          child: ListTile(
            leading: icon,
            title: Text(title, style: GoogleFonts.getFont('Orbitron'),),
            subtitle: Text('Punkty: $cost', style: GoogleFonts.getFont('Orbitron'),),
            trailing: TextButton(
              onPressed: _points >= cost ? () => showAlertDialog(context, cost) : null, 
              child: Text(
                'Kup',
                style: _points >= cost ? 
                  GoogleFonts.pressStart2p(
                    textStyle: const TextStyle(
                      color: minunBlueDark
                    )
                  ) :
                  GoogleFonts.pressStart2p(
                    textStyle: const TextStyle(
                      color: Colors.black26
                    )
                  )
              )
            ),
          ),
        ),
      );
  }

  void _buyItem({required int cost}) {
    if (_points >= cost) {
      setState(() {
        _points -= cost;
      });
    }
  }

  showAlertDialog(BuildContext context, int cost) {
    Widget cancelButton = TextButton(
      child: const Text("Nie"),
      onPressed:  () => Navigator.of(context).pop(),
    );
    Widget continueButton = TextButton(
      child: const Text("Tak"),
      onPressed:  () {
        Navigator.of(context).pop();
        _buyItem(cost: cost);
      }
    );
    AlertDialog alert = AlertDialog(
      title: const Text("Potwierdzenie"),
      content: Text("Czy na pewno chcesz wykorzystać $cost punktów?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
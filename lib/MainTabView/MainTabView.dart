import 'package:flutter/material.dart';
import '../ContratoData/ContratoData.dart';
import '../InicioView/InicioView.dart';
import '../DatosGenerales/DatosGenerales.dart';

class MainTabView extends StatefulWidget {
  final ContratoData datosContrato;

  const MainTabView({super.key, required this.datosContrato});

  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _pages = [
      InicioView(datosContrato: widget.datosContrato),
      const DatosGenerales(),
      const PlaceholderView(title: 'Financiamiento'),
      const PlaceholderView(title: 'Otros'),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: SafeArea(
        top: false,
        bottom: false,
        child: BottomNavigationBar(
          backgroundColor: const Color.fromRGBO(8, 12, 36, 1.0),
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Datos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.description),
              label: 'Condiciones',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.attach_money),
              label: 'Financiamiento',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz),
              label: 'Otros',
            ),
          ],
        ),
      ),
    );
  }
}

class PlaceholderView extends StatelessWidget {
  final String title;

  const PlaceholderView({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color.fromRGBO(8, 12, 36, 1),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          '$title (en desarrollo)',
          style: const TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }
}

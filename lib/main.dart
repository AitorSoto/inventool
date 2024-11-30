import 'package:flutter/material.dart';
import 'package:inventool/screens/add_sql_toold.dart';
import 'package:inventool/screens/list_screen.dart';
import 'package:inventool/screens/scan_screen.dart';
import 'package:inventool/screens/add_tool_screen.dart';
import 'package:inventool/screens/add_volunteer_screen.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() {
  runApp(const Inventool());
}

class Inventool extends StatelessWidget {
  const Inventool({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [routeObserver],
      home: HomeScreen(
        isDarkMode: false,
        toggleTheme: () {},
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final bool isDarkMode;
  final Function toggleTheme;

  const HomeScreen(
      {super.key, required this.isDarkMode, required this.toggleTheme});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const ListScreen(),
    const ScanScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inventool"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: const Text(
                'Opciones',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                widget.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              ),
              title: Text('Modo ${widget.isDarkMode ? "Claro" : "Oscuro"}'),
              onTap: () {
                widget.toggleTheme();
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.contact_page),
              title: const Text('Añadir voluntarios'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddVolunteerScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.build),
              title: const Text('Añadir herramientas'),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddToolScreen()),
                );
                setState(() {
                  _screens[0] =
                      const ListScreen(); // Recargar la pantalla de lista
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.code),
              title: const Text('Ejecutar SQL'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddSQLToolScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Lista de herramientas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: 'Escanear QR',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

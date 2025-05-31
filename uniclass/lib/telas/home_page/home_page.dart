import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
  import 'package:provider/provider.dart';
import 'package:uniclass/utils/themeNotifier.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.75,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'assets/fake_user_flutter.png',
                      width: 38,
                      height: 38,
                    ),
                    Text(
                      'Maria Eduarda',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Provider.of<ThemeNotifier>(context, listen: false)
                            .changeTheme();
                      },
                      child: Image.asset(
                        'assets/moon_flutter.png',
                        width: 23,
                        height: 23,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 40),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black54),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Primeiro horário',
                              style: TextStyle(fontSize: 16)),
                          SizedBox(height: 10),
                          Divider(
                            thickness: 1,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black54,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'LAB 01 -\nFlutter Avançado',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black54,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Segundo horário',
                              style: TextStyle(fontSize: 16)),
                          SizedBox(height: 10),
                          Divider(
                              thickness: 1,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black54),
                          SizedBox(height: 10),
                          Text(
                            'LAB 01 -\nFlutter Avançado',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Center(
                              child: Text('SAIR'),
                            ),
                            FloatingActionButton.small(
                              onPressed: () {},
                              backgroundColor: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black54,
                              child: Icon(Icons.exit_to_app),
                            ),
                          ],
                        ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

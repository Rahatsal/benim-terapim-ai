import 'package:flutter/material.dart';
import 'main.dart';

class AyarlarSayfasi extends StatefulWidget {
  const AyarlarSayfasi({super.key});

  @override
  State<AyarlarSayfasi> createState() => _AyarlarSayfasiState();
}

class _AyarlarSayfasiState extends State<AyarlarSayfasi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlar'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.dark_mode_outlined),
            title: const Text('Karanlik Mod'),
            trailing: Switch(
              value: themeNotifier.value == ThemeMode.dark,
              onChanged: (bool value) {
                // Sadece tema değiştirme işlemi kalıyor
                setState(() {
                  themeNotifier.value =
                      value ? ThemeMode.dark : ThemeMode.light;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

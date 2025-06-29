// main.dart dosyasının tam ve güncel hali
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'secrets.dart';
import 'egzersizler_sayfasi.dart';
import 'duygu_gunlugu_sayfasi.dart';
import 'ayarlar_sayfasi.dart';

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() {
  runApp(const BenimTerapimAI());
}

class BenimTerapimAI extends StatelessWidget {
  const BenimTerapimAI({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Poppins',
            brightness: Brightness.light,
            primaryColor: Colors.teal,
            scaffoldBackgroundColor: Colors.grey[100],
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.grey[100],
              foregroundColor: Colors.black87,
              elevation: 0,
            ),
            cardColor: Colors.white,
          ),
          darkTheme: ThemeData(
              fontFamily: 'Poppins',
              brightness: Brightness.dark,
              primaryColor: Colors.teal,
              scaffoldBackgroundColor: const Color(0xff121212),
              cardColor: const Color(0xff1e1e1e),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xff121212),
                foregroundColor: Colors.white70,
                elevation: 0,
              )),
          themeMode: currentMode,
          home: const SohbetEkrani(),
        );
      },
    );
  }
}

// EKSİK OLAN KISIM BURASIYDI:
class SohbetEkrani extends StatefulWidget {
  const SohbetEkrani({super.key});
  @override
  State<SohbetEkrani> createState() => _SohbetEkraniState();
}

class _SohbetEkraniState extends State<SohbetEkrani> {
  final _controller = TextEditingController();
  final List<String> _mesajlar = [];

  Future<String> yapayZekadanCevapAl(String kullaniciMesaji) async {
    final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=$apiKey');
    final body = jsonEncode({
      'contents': [
        {
          'parts': [
            {'text': kullaniciMesaji}
          ]
        }
      ]
    });

    try {
      final response = await http.post(url,
          headers: {'Content-Type': 'application/json'}, body: body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'];
      } else {
        return 'Bir hata olustu: ${response.body}';
      }
    } catch (e) {
      return 'Baglanti hatasi: $e';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final buttonBackgroundColor =
        isDarkMode ? Colors.grey[850] : Colors.teal.withOpacity(0.1);
    final buttonTextColor = isDarkMode ? Colors.white70 : Colors.teal.shade800;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.settings_outlined),
          tooltip: 'Ayarlar',
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AyarlarSayfasi()));
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              children: [
                Text(
                  'Benim Terapim AI',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const DuyguGunluguSayfasi()));
                      },
                      icon: Icon(Icons.book_outlined, color: buttonTextColor),
                      label: Text('Günlüğüm',
                          style: TextStyle(
                              color: buttonTextColor,
                              fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonBackgroundColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const EgzersizlerSayfasi()));
                      },
                      icon:
                          Icon(Icons.self_improvement, color: buttonTextColor),
                      label: Text('Rahatla',
                          style: TextStyle(
                              color: buttonTextColor,
                              fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonBackgroundColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 32, indent: 20, endIndent: 20),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _mesajlar.length,
              itemBuilder: (BuildContext context, int index) {
                final mesaj = _mesajlar[index];
                final bool bendenMi = mesaj.startsWith('Sen: ');
                final mesajMetni = mesaj.substring(5);
                return Row(
                  mainAxisAlignment: bendenMi
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 14),
                      decoration: BoxDecoration(
                        color: bendenMi
                            ? Colors.teal
                            : Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              spreadRadius: 1,
                              blurRadius: 5)
                        ],
                      ),
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.75),
                      child: Text(mesajMetni,
                          style: TextStyle(
                              color: bendenMi
                                  ? Colors.white
                                  : Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.color,
                              fontSize: 16)),
                    ),
                  ],
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 24),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Mesajini buraya yaz...',
                      filled: true,
                      fillColor: Theme.of(context).cardColor,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide.none),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: Theme.of(context).primaryColor,
                  iconSize: 28,
                  onPressed: () async {
                    if (_controller.text.isNotEmpty) {
                      final kullaniciMesaji = _controller.text;
                      setState(() => _mesajlar.add("Sen: $kullaniciMesaji"));
                      _controller.clear();
                      final aiCevabi =
                          await yapayZekadanCevapAl(kullaniciMesaji);
                      setState(() => _mesajlar.add("Bot: $aiCevabi"));
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

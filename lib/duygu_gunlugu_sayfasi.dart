// duygu_gunlugu_sayfasi.dart dosyasının tam ve güncel hali
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';

class DuyguGunluguSayfasi extends StatefulWidget {
  const DuyguGunluguSayfasi({super.key});

  @override
  State<DuyguGunluguSayfasi> createState() => _DuyguGunluguSayfasiState();
}

class _DuyguGunluguSayfasiState extends State<DuyguGunluguSayfasi> {
  int _seciliModIndex = -1;
  final _notController = TextEditingController();
  List<Map<String, dynamic>> _kayitliGunlukler = [];

  final List<IconData> _modIkonlari = [
    Icons.sentiment_very_dissatisfied,
    Icons.sentiment_dissatisfied,
    Icons.sentiment_neutral,
    Icons.sentiment_satisfied,
    Icons.sentiment_very_satisfied,
  ];
  final List<Color> _modRenkleri = [
    Colors.red,
    Colors.orange,
    Colors.blueGrey,
    Colors.lightGreen,
    Colors.green,
  ];

  @override
  void initState() {
    super.initState();
    _kayitlariYukle();
  }

  Future<void> _kayitlariYukle() async {
    final prefs = await SharedPreferences.getInstance();
    final kayitlarString = prefs.getString('gunluk_kayitlari') ?? '[]';
    final List kayitlarListesi = jsonDecode(kayitlarString);
    setState(() {
      _kayitliGunlukler = kayitlarListesi.cast<Map<String, dynamic>>();
    });
  }

  // YENİ EKLENEN HAFTALIK RAPOR FONKSİYONU
  Widget _buildWeeklyReport() {
    if (_kayitliGunlukler.isEmpty) {
      return const SizedBox.shrink(); // Hiç kayıt yoksa bir şey gösterme
    }

    final birHaftaOncesi = DateTime.now().subtract(const Duration(days: 7));

    // Son bir haftadaki kayıtları filtrele
    final sonHaftaninKayitlari = _kayitliGunlukler.where((kayit) {
      final kayitTarihi = DateTime.parse(kayit['tarih']);
      return kayitTarihi.isAfter(birHaftaOncesi);
    }).toList();

    if (sonHaftaninKayitlari.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Bu hafta henüz bir duygu kaydı yapmadın.',
            textAlign: TextAlign.center,
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      );
    }

    // Modları saymak için bir harita (map) oluşturalım
    final modSayilari = <int, int>{};
    for (var kayit in sonHaftaninKayitlari) {
      final modIndex = kayit['modIndex'] as int;
      modSayilari[modIndex] = (modSayilari[modIndex] ?? 0) + 1;
    }

    // En çok tekrar eden modu bulalım
    final enCokTekrarEdenEntry =
        modSayilari.entries.reduce((a, b) => a.value > b.value ? a : b);
    final enCokTekrarEdenModIndex = enCokTekrarEdenEntry.key;

    final List<String> modIsimleri = [
      'Çok Kötü',
      'Kötü',
      'Normal',
      'İyi',
      'Çok İyi'
    ];
    final enCokHissedilenMod = modIsimleri[enCokTekrarEdenModIndex];

    final raporMetni = "Bu hafta en çok '$enCokHissedilenMod' hissettin.";

    // Raporu şık bir kart içinde gösterelim
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          raporMetni,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildChart() {
    if (_kayitliGunlukler.length < 2) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24.0),
        child: Center(
            child: Text('Grafik için en az 2 kayıt gerekir.',
                style: TextStyle(fontStyle: FontStyle.italic))),
      );
    }

    List<FlSpot> spots = _kayitliGunlukler.asMap().entries.map((entry) {
      int index = entry.key;
      Map<String, dynamic> kayit = entry.value;
      return FlSpot(index.toDouble(), (kayit['modIndex'] as int).toDouble());
    }).toList();

    return AspectRatio(
      aspectRatio: 1.7,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: LineChart(
            LineChartData(
              gridData: const FlGridData(show: false),
              titlesData: const FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: Theme.of(context).primaryColor,
                  barWidth: 5,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Duygu Günlüğü'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Bugün nasıl hissediyorsun?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(5, (index) {
                  return IconButton(
                    iconSize: 40,
                    icon: Icon(_modIkonlari[index],
                        color: _seciliModIndex == index
                            ? _modRenkleri[index]
                            : Colors.grey.withOpacity(0.5)),
                    onPressed: () => setState(() => _seciliModIndex = index),
                  );
                }),
              ),
              const SizedBox(height: 30),
              TextField(
                  controller: _notController,
                  decoration: const InputDecoration(
                      labelText: 'Bugün hakkında bir şeyler yaz...',
                      border: OutlineInputBorder()),
                  maxLines: 4),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_seciliModIndex == -1) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Lütfen bugünkü modunu seç.')));
                    return;
                  }
                  final yeniKayit = {
                    'tarih': DateTime.now().toIso8601String(),
                    'modIndex': _seciliModIndex,
                    'not': _notController.text
                  };
                  final prefs = await SharedPreferences.getInstance();
                  if (!mounted) return;
                  final eskiKayitlarString =
                      prefs.getString('gunluk_kayitlari') ?? '[]';
                  final List eskiKayitlar = jsonDecode(eskiKayitlarString);
                  eskiKayitlar.add(yeniKayit);
                  await prefs.setString(
                      'gunluk_kayitlari', jsonEncode(eskiKayitlar));
                  if (!mounted) return;
                  await _kayitlariYukle();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Günün başarıyla kaydedildi!')));
                  setState(() {
                    _seciliModIndex = -1;
                    _notController.clear();
                  });
                },
                child:
                    const Text('Günü Kaydet', style: TextStyle(fontSize: 18)),
              ),

              const SizedBox(height: 40),
              const Text('Haftalık Raporun',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const Divider(),
              const SizedBox(height: 10),
              _buildWeeklyReport(), // RAPOR WIDGET'INI BURADA ÇAĞIRIYORUZ

              const SizedBox(height: 30),
              const Text('Duygu Durumu Grafiği',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const Divider(),
              const SizedBox(height: 10),
              _buildChart(),

              const SizedBox(height: 30),
              const Text('Geçmiş Kayıtlar',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const Divider(),
              if (_kayitliGunlukler.isEmpty)
                const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Center(child: Text('Henüz bir kayıt bulunmuyor.')))
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _kayitliGunlukler.length,
                  itemBuilder: (context, index) {
                    final kayit = _kayitliGunlukler.reversed.toList()[index];
                    final tarih = DateTime.parse(kayit['tarih']);
                    final modIndex = kayit['modIndex'];
                    final not = kayit['not'];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        leading: Icon(_modIkonlari[modIndex],
                            color: _modRenkleri[modIndex], size: 30),
                        title:
                            Text('${tarih.day}/${tarih.month}/${tarih.year}'),
                        subtitle: Text(not),
                      ),
                    );
                  },
                )
            ],
          ),
        ),
      ),
    );
  }
}

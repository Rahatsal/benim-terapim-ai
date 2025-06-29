// egzersizler_sayfasi.dart dosyasının tam ve güncel hali
import 'package:flutter/material.dart';
import 'egzersiz_detay_sayfasi.dart';

final List<Map<String, String>> egzersizler = [
  {
    'title': '5 Duyu Topraklanma Teknigi',
    'subtitle': 'Anksiyete anlari icin hizli bir odaklanma egzersizi.',
    'description':
        'Bu teknik, 5 duyunuzu kullanarak sizi su ana odaklamayi hedefler.\n\n1. GORDUGUN 5 seyi say.\n2. DOKUNDUGUN 4 seyi hisset.\n3. DUYDUGUN 3 sesi dinle.\n4. KOKLADIGIN 2 kokuyu al.\n5. TADINA BAKTIGIN 1 seyi bul.'
  },
  {
    'title': '4-4-4-4 Kutu Nefesi',
    'subtitle': 'Sakinlesmek ve nefesi duzenlemek icin.',
    'description':
        'Bu basit nefes egzersizi, sinir sisteminizi sakinlestirir.\n\n1. 4 saniye boyunca burnunuzdan nefes alin.\n2. Nefesinizi 4 saniye tutun.\n3. 4 saniye boyunca agzinizdan yavasca nefes verin.\n4. 4 saniye bekleyin.\n5. Bu donguyu birkac dakika tekrarlayin.'
  },
  {
    'title': 'Guvenli Alan Imgelemesi',
    'subtitle': 'Zihinsel olarak huzurlu bir yere siginma.',
    'description':
        'Gozlerinizi kapatin ve kendinizi tamamen guvende ve huzurlu hissettiginiz bir yer hayal edin. Bu yer gercek veya hayali olabilir. Oradaki tum detaylari zihninizde canlandirin: renkleri, sesleri, kokulari. Birkac dakika bu huzurlu alanda kalin.'
  },
];

class EgzersizlerSayfasi extends StatelessWidget {
  const EgzersizlerSayfasi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rahatlama Egzersizleri'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: egzersizler.length,
        itemBuilder: (context, index) {
          final egzersiz = egzersizler[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              leading: Icon(Icons.self_improvement,
                  color: Theme.of(context).primaryColor),
              title: Text(egzersiz['title']!,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(egzersiz['subtitle']!),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EgzersizDetaySayfasi(
                      baslik: egzersiz['title']!,
                      aciklama: egzersiz['description']!,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

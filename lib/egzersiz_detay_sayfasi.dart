// egzersiz_detay_sayfasi.dart dosyasının tam ve güncel hali
import 'package:flutter/material.dart';

class EgzersizDetaySayfasi extends StatefulWidget {
  final String baslik;
  final String aciklama;

  const EgzersizDetaySayfasi({
    super.key,
    required this.baslik,
    required this.aciklama,
  });

  @override
  State<EgzersizDetaySayfasi> createState() => _EgzersizDetaySayfasiState();
}

class _EgzersizDetaySayfasiState extends State<EgzersizDetaySayfasi>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  String _rehberMetni = 'Baslamak icin daireye dokun';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _animation = Tween<double>(begin: 150.0, end: 250.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _rehberMetni = 'Tut');
        Future.delayed(const Duration(seconds: 4), () {
          if (mounted) {
            _controller.reverse();
            setState(() => _rehberMetni = 'Nefes Ver');
          }
        });
      } else if (status == AnimationStatus.dismissed) {
        setState(() => _rehberMetni = 'Bekle');
        Future.delayed(const Duration(seconds: 4), () {
          if (mounted) {
            _controller.forward();
            setState(() => _rehberMetni = 'Nefes Al');
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.baslik == '4-4-4-4 Kutu Nefesi') {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.baslik),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _rehberMetni,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 50),
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return GestureDetector(
                    onTap: () {
                      if (!_controller.isAnimating) {
                        _controller.forward();
                        setState(() => _rehberMetni = 'Nefes Al');
                      }
                    },
                    child: Container(
                      width: _animation.value,
                      height: _animation.value,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.7),
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.baslik),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            widget.aciklama,
            style: const TextStyle(fontSize: 18, height: 1.5),
          ),
        ),
      ),
    );
  }
}

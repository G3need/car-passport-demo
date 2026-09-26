import 'package:flutter/material.dart';

// ponytail: demo data hardcoded, no backend by design. Upgrade path:
// swap DemoGarage/DemoService into repository classes + http calls.

class DemoGarage {
  final String name, area, rating, phone;
  final double distanceKm;
  final List<String> services;
  const DemoGarage(this.name, this.area, this.rating, this.distanceKm, this.phone, this.services);
}

class DemoService {
  final String date, garage, work, cost, nextDueKm;
  const DemoService(this.date, this.garage, this.work, this.cost, this.nextDueKm);
}

const garages = <DemoGarage>[
  DemoGarage('El Masr Auto Care', 'المعادي', '4.6', 2.3, '+20 100 000 0001',
      ['تغيير زيت', 'فحص كمبيوتر', 'مكيف', 'فرامل']),
  DemoGarage('El Nasr Garage', 'مدينة نصر', '4.3', 5.8, '+20 100 000 0002',
      ['زيت وفلاتر', 'بطاريات', 'Suspension', 'معايرة']),
  DemoGarage('المهندسين Service Center', 'المهندسين', '4.8', 7.1, '+20 100 000 0003',
      ['صيانة دورية', 'تكييف', 'إطاريات', 'غسيل']),
];

final services = <DemoService>[
  DemoService('12/03/2026', 'المرور亲和 Auto Care', 'زيت 5W-30 + فلتر زيت', '1,450 EGP', '18,000 km'),
  DemoService('04/01/2026', 'El Nasr Garage', 'فحص كمبيوتر + بطاريات', '2,100 EGP', '24,000 km'),
  DemoService('19/10/2025', 'المهندسين Service Center', 'تغيير فرامل أمامي', '3,800 EGP', '31,000 km'),
];

void main() => runApp(const CarPassportApp());

class CarPassportApp extends StatefulWidget {
  const CarPassportApp({super.key});
  @override
  State<CarPassportApp> createState() => _CarPassportAppState();
}

class _CarPassportAppState extends State<CarPassportApp> {
  ThemeMode _mode = ThemeMode.dark;
  void _toggle() => setState(() =>
      _mode = _mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Car Passport',
        debugShowCheckedModeBanner: false,
        themeMode: _mode,
        theme: _theme(Brightness.light),
        darkTheme: _theme(Brightness.dark),
        home: Home(onToggle: _toggle, mode: _mode),
      );
}

ThemeData _theme(Brightness b) => ThemeData(
      useMaterial3: true,
      brightness: b,
      scaffoldBackgroundColor: b == Brightness.dark ? const Color(0xFF0A0E17) : Colors.white,
      colorSchemeSeed: const Color(0xFF00C2A8),
      appBarTheme: AppBarTheme(
        backgroundColor: b == Brightness.dark ? const Color(0xFF0A0E17) : Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: b == Brightness.dark ? Colors.white : Colors.black87,
          fontSize: 18, fontWeight: FontWeight.w600),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: b == Brightness.dark ? const Color(0xFF141B2D) : const Color(0xFFF2F4F8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: Color(0xFF00C2A8), textColor: Colors.white70),
    );

class Home extends StatefulWidget {
  const Home({super.key, required this.onToggle, required this.mode});
  final VoidCallback onToggle;
  final ThemeMode mode;
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _tab = 0;
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(['الجراجات', 'كار باسبور', 'الإعدادات'][_tab]),
          actions: [
            IconButton(icon: const Icon(Icons.refresh), onPressed: () => setState(() {})),
          ],
        ),
        body: IndexedStack(index: _tab, children: const [GaragesTab(), PassportTab(), SettingsTab()]),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _tab,
          onDestinationSelected: (i) => setState(() => _tab = i),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.garage_outlined), selectedIcon: Icon(Icons.garage), label: 'جراجات'),
            NavigationDestination(icon: Icon(Icons.description_outlined), selectedIcon: Icon(Icons.description), label: 'باسبور'),
            NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: 'إعدادات'),
          ],
        ),
      );
}

class GaragesTab extends StatelessWidget {
  const GaragesTab({super.key});
  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.symmetric(vertical: 10),
        children: [
          for (final g in garages)
            Card(
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                title: Text(g.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                subtitle: Text('${g.area}  •  ${g.distanceKm} km  •  ★ ${g.rating}',
                    style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: .6))),
                trailing: IconButton(
                  icon: const Icon(Icons.call),
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('اتصال ${g.phone} - تجريبي'))),
                ),
              ),
            ),
        ],
      );
}

class PassportTab extends StatelessWidget {
  const PassportTab({super.key});
  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.symmetric(vertical: 10),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('سيارتي', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text('Peugeot 208  •  2021  •  نــمــ 4',
                    style: TextStyle(color: Colors.white.withValues(alpha: .75))),
                const SizedBox(height: 4),
                Text('العداد: 78,400 km', style: TextStyle(color: Colors.white.withValues(alpha: .6), fontSize: 12)),
              ]),
            ),
          ),
          for (final s in services)
            Card(
              child: ExpansionTile(
                title: Text(s.work, style: const TextStyle(color: Colors.white, fontSize: 14)),
                subtitle: Text('${s.date}  •  ${s.garage}',
                    style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: .55))),
                childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                children: [
                  _row(context, 'التكلفة', s.cost),
                  _row(context, 'الصيانة القادمة', s.nextDueKm),
                ],
              ),
            ),
        ],
      );
  Widget _row(BuildContext c, String k, String v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(k, style: TextStyle(color: Colors.white.withValues(alpha: .55), fontSize: 12)),
          Text(v, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ]),
      );
}

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});
  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final home = context.findAncestorStateOfType<_HomeState>();
    return ListView(children: [
      SwitchListTile(
        title: const Text('الوضع الليلي', style: TextStyle(color: Colors.white)),
        subtitle: Text('تبديل فاتح/داكن', style: TextStyle(color: Colors.white.withValues(alpha: .5), fontSize: 11)),
        value: dark,
        onChanged: (_) => home?.widget.onToggle(),
      ),
      ListTile(
        leading: const Icon(Icons.language),
        title: const Text('اللغة', style: TextStyle(color: Colors.white)),
        trailing: const Text('العربية', style: TextStyle(color: Colors.white54)),
      ),
      ListTile(
        leading: const Icon(Icons.info_outline),
        title: const Text('عن التطبيق', style: TextStyle(color: Colors.white)),
        subtitle: Text('كار باسبور 1.0 — نسخة تجريبية',
            style: TextStyle(color: Colors.white.withValues(alpha: .5), fontSize: 11)),
      ),
    ]);
  }
}

import 'package:flutter/material.dart';
import 'deutsch/hoeren_screen.dart';
import 'deutsch/lesen_screen.dart';
import 'deutsch/schreiben_screen.dart';
import 'deutsch/sprechen_screen.dart';
import 'deutsch/akkusativ_artikel_screen.dart';
import 'deutsch/artikel_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _modules = <_ModuleEntry>[
    _ModuleEntry(
      titleDe: 'Hören',
      titleRu: 'Аудирование',
      icon: Icons.headphones_outlined,
      subtitle:
          'Диалоги и объявления: правильная картинка, richtig/falsch или выбор.',
    ),
    _ModuleEntry(
      titleDe: 'Lesen',
      titleRu: 'Чтение',
      icon: Icons.menu_book_outlined,
      subtitle: 'Объявления, письма, таблички: richtig/falsch или сопоставление.',
    ),
    _ModuleEntry(
      titleDe: 'Schreiben',
      titleRu: 'Письмо',
      icon: Icons.edit_note,
      subtitle: 'Формуляр и короткое E-Mail (~30 слов), типовые ситуации.',
    ),
    _ModuleEntry(
      titleDe: 'Sprechen',
      titleRu: 'Говорение',
      icon: Icons.record_voice_over_outlined,
      subtitle:
          'Знакомство (буквы, числа), тематические карточки, вежливые просьбы.',
    ),
    _ModuleEntry(
      titleDe: 'Artikel',
      titleRu: 'Артикли',
      icon: Icons.article_outlined,
      subtitle:
          'der / die / das: 150 существительных, озвучка слова и полной формы.',
    ),
    _ModuleEntry(
      titleDe: 'Artikel im Akkusativ',
      titleRu: 'Артикль, винительный падеж',
      icon: Icons.view_week_outlined,
      subtitle:
          'A1: теория + 100 заданий + бонус «Диалоги» (всего 112 карточек).',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('test_DEUTSCH_start'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        itemCount: _modules.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final m = _modules[index];
          return Card(
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              leading: CircleAvatar(
                radius: 26,
                child: Icon(m.icon, size: 28),
              ),
              title: Text(
                '${m.titleDe} — ${m.titleRu}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(m.subtitle),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                final page = switch (index) {
                  0 => const HoerenScreen(),
                  1 => const LesenScreen(),
                  2 => const SchreibenScreen(),
                  3 => const SprechenScreen(),
                  4 => const ArtikelScreen(),
                  5 => const AkkusativArtikelScreen(),
                  _ => const HoerenScreen(),
                };
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(builder: (_) => page),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _ModuleEntry {
  const _ModuleEntry({
    required this.titleDe,
    required this.titleRu,
    required this.icon,
    required this.subtitle,
  });

  final String titleDe;
  final String titleRu;
  final IconData icon;
  final String subtitle;
}

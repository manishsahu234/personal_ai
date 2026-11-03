import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';

class SideNavigation extends StatelessWidget {
  const SideNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF0EFF7),
        border: Border(right: BorderSide(color: colors.outlineVariant)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.auto_awesome, color: colors.primary, size: 27),
              const SizedBox(width: 10),
              const Text(
                'Personal AI',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
            ],
          ),
          const SizedBox(height: 28),
          FilledButton.tonalIcon(
            onPressed: () =>
                context.read<ChatBloc>().add(const NewConversationRequested()),
            icon: const Icon(Icons.add),
            label: const Text('New chat'),
          ),
          const SizedBox(height: 24),
          Text('WORKSPACE', style: Theme.of(context).textTheme.labelSmall),
          const SizedBox(height: 10),
          const _NavItem(icon: Icons.chat_bubble_outline, label: 'Chats'),
          const _NavItem(
            icon: Icons.smart_toy_outlined,
            label: 'Model library',
          ),
          const _NavItem(icon: Icons.folder_open_outlined, label: 'Documents'),
          const _NavItem(icon: Icons.psychology_outlined, label: 'Memory'),
          const Spacer(),
          const Divider(),
          const _NavItem(icon: Icons.settings_outlined, label: 'Settings'),
          const SizedBox(height: 8),
          const Text(
            'Private by design • Runs locally',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      leading: Icon(icon, size: 20),
      title: Text(label, style: const TextStyle(fontSize: 14)),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$label will be implemented in a later phase.'),
          ),
        );
      },
    );
  }
}

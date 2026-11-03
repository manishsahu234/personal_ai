import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';
import '../widgets/chat_composer.dart';
import '../widgets/chat_message_bubble.dart';
import '../widgets/empty_chat_view.dart';
import '../widgets/model_selector.dart';
import '../widgets/side_navigation.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 850;

          return Row(
            children: [
              if (isWide) const SizedBox(width: 264, child: SideNavigation()),
              Expanded(
                child: SafeArea(
                  child: Column(
                    children: [
                      _ChatHeader(showMenu: !isWide),
                      Expanded(
                        child: BlocBuilder<ChatBloc, ChatState>(
                          builder: (context, state) {
                            if (state.messages.isEmpty) {
                              return const EmptyChatView();
                            }

                            return ListView.builder(
                              padding: const EdgeInsets.fromLTRB(
                                20,
                                24,
                                20,
                                24,
                              ),
                              itemCount: state.messages.length,
                              itemBuilder: (context, index) =>
                                  ChatMessageBubble(
                                    message: state.messages[index],
                                  ),
                            );
                          },
                        ),
                      ),
                      const ChatComposer(),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ChatHeader extends StatelessWidget {
  const _ChatHeader({required this.showMenu});

  final bool showMenu;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 20, 12),
      child: Row(
        children: [
          if (showMenu)
            IconButton(
              tooltip: 'Navigation',
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Navigation drawer will be added next.'),
                ),
              ),
              icon: const Icon(Icons.menu_rounded),
            ),
          const Expanded(
            child: Text(
              'Personal AI',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
            ),
          ),
          const ModelSelector(),
          const SizedBox(width: 8),
          IconButton(
            tooltip: 'New conversation',
            onPressed: () =>
                context.read<ChatBloc>().add(const NewConversationRequested()),
            icon: const Icon(Icons.add_comment_outlined),
          ),
        ],
      ),
    );
  }
}

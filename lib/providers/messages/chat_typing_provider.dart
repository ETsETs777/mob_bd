import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatTypingState {
  const ChatTypingState({this.byThread = const {}});

  final Map<String, String> byThread;

  ChatTypingState copyWith({Map<String, String>? byThread}) =>
      ChatTypingState(byThread: byThread ?? this.byThread);
}

final chatTypingProvider =
    NotifierProvider<ChatTypingNotifier, ChatTypingState>(
  ChatTypingNotifier.new,
);

class ChatTypingNotifier extends Notifier<ChatTypingState> {
  @override
  ChatTypingState build() => const ChatTypingState();

  void setTyping({
    required String threadId,
    required String userName,
    required bool typing,
  }) {
    final map = Map<String, String>.from(state.byThread);
    if (typing && userName.isNotEmpty) {
      map[threadId] = userName;
    } else {
      map.remove(threadId);
    }
    state = ChatTypingState(byThread: map);
  }

  void clearThread(String threadId) {
    if (!state.byThread.containsKey(threadId)) return;
    final map = Map<String, String>.from(state.byThread)..remove(threadId);
    state = ChatTypingState(byThread: map);
  }

  void clearAll() => state = const ChatTypingState();
}

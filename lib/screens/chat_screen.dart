import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/routes.dart';
import '../config/theme.dart';
import '../providers/player_provider.dart';
import '../providers/chat_provider.dart';
import '../providers/time_provider.dart';
import '../providers/simulation_provider.dart';
import '../models/player_stats.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/action_suggestion_chip.dart';
import '../widgets/stat_bar.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _showNewGameDialog = false;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  Future<void> _initializeGame() async {
    final simProvider = context.read<SimulationProvider>();
    await simProvider.initialize();

    if (!simProvider.hasActivePlayer) {
      setState(() => _showNewGameDialog = true);
    } else {
      await context.read<PlayerProvider>().loadPlayer(simProvider.currentPlayerId!);
      await context.read<TimeProvider>();
    }
  }

  void _startNewGame(String name) async {
    if (name.trim().isEmpty) return;

    final simProvider = context.read<SimulationProvider>();
    final playerId = await simProvider.startNewGame(name.trim());

    await context.read<PlayerProvider>().loadPlayer(playerId);

    setState(() => _showNewGameDialog = false);

    // Add welcome message
    await context.read<ChatProvider>().addMessage(
          content: 'Welcome to Life Simulator, $name!\n\n'
              'You are 3 years old and starting Kindergarten. The world is full of '
              'possibilities. What would you like to do first?\n\n'
              'Your stats are displayed above. Keep them balanced as you navigate '
              'through life. Every choice shapes your future!',
          role: 'ai',
        );
  }

  void _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    _messageController.clear();
    setState(() {});

    await context.read<ChatProvider>().sendPlayerMessage(text);

    // Update stats
    await context.read<PlayerProvider>().refreshStats();

    // Advance time
    context.read<TimeProvider>().advanceTime(minutes: 30);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<TimeProvider>(
          builder: (context, time, _) => Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Life Simulator', style: const TextStyle(fontSize: 18)),
              Text(
                '${time.formattedDateTime} • ${time.season} • ${time.weather}',
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.profile),
            tooltip: 'Profile',
          ),
          IconButton(
            icon: const Icon(Icons.work),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.career),
            tooltip: 'Career',
          ),
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.calendar),
            tooltip: 'Calendar',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.settings),
            tooltip: 'Settings',
          ),
        ],
      ),
      body: _showNewGameDialog
          ? _buildNewGameScreen()
          : Column(
              children: [
                _buildStatBar(),
                _buildSuggestedActions(),
                Expanded(child: _buildChatFeed()),
                _buildMessageInput(),
              ],
            ),
    );
  }

  Widget _buildNewGameScreen() {
    String playerName = '';
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.self_improvement, size: 80, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 24),
            Text(
              'Life Simulator',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Live a simulated life through AI-powered storytelling.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 32),
            TextField(
              decoration: InputDecoration(
                labelText: 'Enter your character\'s name',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.person),
              ),
              autofocus: true,
              onChanged: (value) => playerName = value,
              onSubmitted: (value) => _startNewGame(value),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  if (playerName.isNotEmpty) {
                    _startNewGame(playerName);
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Begin Your Life', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBar() {
    return Consumer<PlayerProvider>(
      builder: (context, provider, _) {
        final stats = provider.stats;
        if (stats == null) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 2)],
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _miniStat('❤️', stats.health, AppTheme.healthGreen),
                _miniStat('⚡', stats.energy, AppTheme.energyYellow),
                _miniStat('😊', stats.happiness, AppTheme.happinessOrange),
                _miniStat('💰', stats.money, AppTheme.moneyGreen),
                _miniStat('🧠', stats.intelligence, AppTheme.intelligencePurple),
                _miniStat('🤝', stats.social, AppTheme.socialBlue),
                _miniStat('💪', stats.fitness, AppTheme.fitnessRed),
                if (provider.player != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      children: [
                        Text('Age ${provider.player!.age}',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        Text(provider.player!.isAlive ? 'Alive' : 'Deceased',
                            style: TextStyle(fontSize: 10, color: provider.player!.isAlive ? Colors.green : Colors.red)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _miniStat(String icon, double value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 14)),
          SizedBox(
            width: 40,
            child: LinearProgressIndicator(
              value: value / 100,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 4,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Text(
            value.toStringAsFixed(0),
            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestedActions() {
    return Consumer<ChatProvider>(
      builder: (context, chat, _) {
        if (chat.suggestedActions.isEmpty) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: chat.suggestedActions
                  .map((action) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ActionSuggestionChip(
                          label: action,
                          onTap: () => _sendMessage(action),
                        ),
                      ))
                  .toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildChatFeed() {
    return Consumer<ChatProvider>(
      builder: (context, chat, _) {
        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          itemCount: chat.messages.length + (chat.isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= chat.messages.length) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final message = chat.messages[index];
            final isPlayer = message.role == 'player';
            final isNarrator = message.role == 'narrator' || message.role == 'ai';

            return ChatBubble(
              content: message.content,
              isPlayer: isPlayer,
              senderName: isPlayer
                  ? 'You'
                  : message.role == 'narrator'
                      ? 'Narrator'
                      : message.role == 'npc'
                          ? 'NPC'
                          : 'Narrator',
              statChanges: message.statChanges,
            );
          },
        );
      },
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, -2))],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'What do you do?',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  filled: true,
                ),
                textInputAction: TextInputAction.send,
                onSubmitted: _sendMessage,
                maxLines: 3,
                minLines: 1,
              ),
            ),
            const SizedBox(width: 8),
            Consumer<ChatProvider>(
              builder: (context, chat, _) => IconButton(
                onPressed: chat.isLoading
                    ? null
                    : () => _sendMessage(_messageController.text),
                icon: const Icon(Icons.send_rounded),
                color: Theme.of(context).colorScheme.primary,
                style: IconButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:infinity_love/core/constants/app_color.dart';

import '../tab/tab_bar.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  int selectedTabIndex = 1; // Default: 'Role Play'

  final List<String> tabList = ['Chats', 'Role Play', 'Created'];

  final List<StoryContact> contacts = [
    StoryContact(
      name: 'Lavanya',
      imageUrl: 'https://picsum.photos/200/200?random=11',
    ),
    StoryContact(
      name: 'Trisha',
      imageUrl: 'https://picsum.photos/200/200?random=12',
    ),
    StoryContact(
      name: 'Mahi',
      imageUrl: 'https://picsum.photos/200/200?random=13',
    ),
    StoryContact(
      name: 'Madhavi',
      imageUrl: 'https://picsum.photos/200/200?random=14',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBlack,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Title ---
            const Padding(
              padding: EdgeInsets.only(left: 20.0, top: 16.0, bottom: 20.0),
              child: Text(
                'Messages',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),

            // --- Story / Active Avatars Horizontal List ---
            SizedBox(
              height: 100,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                scrollDirection: Axis.horizontal,
                itemCount: contacts.length,
                separatorBuilder: (context, index) => const SizedBox(width: 18),
                itemBuilder: (context, index) {
                  return StoryAvatarItem(contact: contacts[index]);
                },
              ),
            ),

            const SizedBox(height: 24),

            // --- Separate Custom Tab Filter Bar ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CustomTabPillBar(
                tabs: tabList,
                selectedIndex: selectedTabIndex,
                onTabSelected: (index) {
                  setState(() {
                    selectedTabIndex = index;
                  });
                },
              ),
            ),

            const SizedBox(height: 28),

            // --- Dynamic Body Content based on Active Tab ---
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 24.0),
                child: IndexedStack(
                  index: selectedTabIndex,
                  children: const [
                    EmptyStateTabCard(
                      title: 'No Chats Yet',
                      subtitle: 'Start a conversation with a companion',
                      iconData: Icons.chat_bubble_outline,
                    ),
                    EmptyStateTabCard(
                      title: 'No Role Play Yet',
                      subtitle: 'Explore this section',
                      iconData: Icons.settings,
                    ),
                    EmptyStateTabCard(
                      title: 'No Created Partners',
                      subtitle: 'Create your first custom AI partner',
                      iconData: Icons.add,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Independent Empty State View Component ---
class EmptyStateTabCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData iconData;

  const EmptyStateTabCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.iconData = Icons.settings,
  });

  static const Color pinkAccent = Color(0xFFE91E63);
  static const Color cardBg = Color(0xFF121212);
  static const Color cardBorder = Color(0xFF222222);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(color: cardBorder, width: 1.2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Outer & Inner Icon Rings
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: Color(0xFF1E1E1E),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(
                  color: pinkAccent,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  iconData,
                  color: Colors.black,
                  size: 20,
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),

          // Title
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),

          // Subtitle
          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}

// --- Story Avatar Item Widget ---
class StoryAvatarItem extends StatelessWidget {
  final StoryContact contact;
  static const Color pinkAccent = Color(0xFFE91E63);

  const StoryAvatarItem({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(2.5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: pinkAccent, width: 2),
          ),
          child: CircleAvatar(
            radius: 28,
            backgroundImage: AssetImage("assets/22.png"),
            backgroundColor: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          contact.name,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12.5,
          ),
        ),
      ],
    );
  }
}

class StoryContact {
  final String name;
  final String imageUrl;

  StoryContact({required this.name, required this.imageUrl});
}
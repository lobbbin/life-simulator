import 'package:flutter/material.dart';

class ActionSuggestionChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const ActionSuggestionChip({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: const Icon(Icons.arrow_forward_ios, size: 12),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      onPressed: onTap,
      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.08),
      side: BorderSide(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }
}

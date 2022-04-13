import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:today_i_learned/src/app/app.dart';
import 'package:today_i_learned/src/categories/categories.dart';
import 'package:today_i_learned/src/learnings/models/models.dart';

class LearningsListElement extends StatelessWidget {
  final LearningModel learning;
  final CategoryModel? category;

  const LearningsListElement({
    Key? key,
    required this.learning,
    this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: const Icon(
              Icons.emoji_events_outlined,
              size: AppIconSize.L,
            ),
            title: Text(learning.title),
            isThreeLine: category != null,
            subtitle: Text(
              '${category == null ? '' : '${category!.name}\n'}${learning.created.formatWeekdayDate(context.locale)} - Difficulty-Level: ${learning.difficulty}',
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.M,
              right: AppSpacing.M,
              bottom: AppSpacing.M,
            ),
            child: Text(learning.description.truncate(AppConfig.learningDescriptionPreviewLength)),
          ),
        ],
      ),
    );
  }
}

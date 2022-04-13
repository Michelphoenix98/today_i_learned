import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:today_i_learned/src/app/app.dart';
import 'package:today_i_learned/src/categories/categories.dart';
import 'package:today_i_learned/src/learnings/blocs/blocs.dart';
import 'package:today_i_learned/src/learnings/repositories/repositories.dart';
import 'package:today_i_learned/src/learnings/widgets/widgets.dart';

class LearningsPage extends StatelessWidget {
  const LearningsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LearningsCubit(
        learningRepository: context.read<LearningRepository>(),
        categoriesCubit: context.read<CategoriesCubit>(),
      ),
      child: const _LearningsView(),
    );
  }
}

// ignore: prefer-single-widget-per-file
class _LearningsView extends StatelessWidget {
  const _LearningsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Learnings'),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.M),
              child: BlocBuilder<LearningsCubit, LearningsState>(
                buildWhen: (oldState, newState) =>
                    oldState.learningOrderBy != newState.learningOrderBy ||
                    oldState.sortedLearnings != newState.sortedLearnings,
                builder: (context, state) => ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.M),
                  itemCount: state.learnings.length,
                  itemBuilder: (context, index) {
                    final learningWithCategory = state.sortedLearnings[index];
                    final learning = learningWithCategory.learning;
                    final category = learningWithCategory.category;

                    return LearningsListElement(
                      learning: learning,
                      category: category,
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.M),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: AppSpacing.XL,
            right: AppSpacing.XL,
            child: BlocSelector<LearningsCubit, LearningsState, LearningOrderBy>(
              selector: (state) => state.learningOrderBy,
              builder: (context, learningOrderBy) {
                return LearningsSortingSelection(
                  value: learningOrderBy,
                  onChanged: (learningOrderBy) => context.read<LearningsCubit>().changeOrderBy(learningOrderBy),
                );
              },
            ),
          ),
          BlocSelector<LearningsCubit, LearningsState, bool>(
            selector: (state) => state.isLoading,
            builder: (context, isLoading) => isLoading
                ? Positioned.fill(
                    child: Container(
                      color: Theme.of(context).backgroundColor.withAlpha(AppAlpha.a200),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  )
                : Container(),
          ),
        ],
      ),
    );
  }
}

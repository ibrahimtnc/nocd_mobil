import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ocdcoach/src/core/constants/app_constants.dart';
import 'package:ocdcoach/src/core/storage/hive_service.dart';
import 'package:ocdcoach/src/core/theme/app_colors.dart';
import 'package:ocdcoach/src/features/analysis/domain/models/analysis_response_model.dart';
import 'package:ocdcoach/src/features/analysis/presentation/providers/analysis_provider.dart';
import 'package:ocdcoach/src/features/analysis/presentation/widgets/actionable_takeaway_card.dart';
import 'package:ocdcoach/src/features/analysis/presentation/widgets/detailed_risk_card.dart';
import 'package:ocdcoach/src/features/analysis/presentation/widgets/disclaimer_card.dart';
import 'package:ocdcoach/src/features/analysis/presentation/widgets/expandable_mechanics_card.dart';
import 'package:ocdcoach/src/features/analysis/presentation/widgets/feedback_buttons.dart';
import 'package:ocdcoach/src/features/analysis/presentation/widgets/ocd_awareness_card.dart';
import 'package:ocdcoach/src/features/analysis/presentation/widgets/validation_card.dart';
import 'package:ocdcoach/src/features/chat/presentation/widgets/therapeutic_chat_sheet.dart';
import 'dart:convert';
import 'package:ocdcoach/src/shared/models/thought_entry_model.dart';
import 'package:ocdcoach/src/shared/providers/localization_provider.dart';

/// Analysis screen
/// Shows scientific analysis of the user's thought
class AnalysisScreen extends ConsumerStatefulWidget {
  final String thought;
  final int anxietyLevel;
  final int waitDurationSeconds;
  final String? entryId; // If provided, load saved analysis from history

  const AnalysisScreen({
    super.key,
    required this.thought,
    required this.anxietyLevel,
    required this.waitDurationSeconds,
    this.entryId,
  });

  @override
  ConsumerState<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends ConsumerState<AnalysisScreen> {
  bool _hasSavedToHistory = false;
  String? _currentEntryId;

  @override
  void initState() {
    super.initState();
    _currentEntryId = widget.entryId;
  }

  @override
  Widget build(BuildContext context) {
    final localizationAsync = ref.watch(localizationProvider);
    
    // If entryId is provided, try to load saved analysis
    AnalysisResponseModel? savedAnalysis;
    if (_currentEntryId != null) {
      final entry = HiveService.thoughtsBox.get(_currentEntryId);
      if (entry?.analysisResult != null) {
        try {
          final json = jsonDecode(entry!.analysisResult!);
          savedAnalysis = AnalysisResponseModel.fromJson(json);
        } catch (e) {
          // If parsing fails, fall back to fetching
        }
      }
    }

    // If we have saved analysis, use it; otherwise fetch from API
    final analysisAsync = savedAnalysis != null
        ? AsyncValue.data(savedAnalysis)
        : ref.watch(
            analysisCacheProvider(
              thought: widget.thought,
              anxietyLevel: widget.anxietyLevel,
            ),
          );

    // Save to history once when analysis is loaded (only if not from history)
    if (_currentEntryId == null) {
      analysisAsync.whenData((analysis) {
        if (analysis != null && !_hasSavedToHistory) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _saveToHistory(analysis);
            _hasSavedToHistory = true;
          });
        }
      });
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.textPrimary,
          ),
          onPressed: () => context.go('/home'),
        ),
        title: localizationAsync.when(
          data: (service) => Text(
            service.getString('analysis'),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.textPrimary,
                ),
          ),
          loading: () => Text(
            'Analysis',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.textPrimary,
                ),
          ),
          error: (_, __) => Text(
            'Analysis',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.textPrimary,
                ),
          ),
        ),
      ),
      body: localizationAsync.when(
        data: (localization) => Scaffold(
          backgroundColor: AppColors.background,
          body: analysisAsync.when(
            data: (analysis) {
              if (analysis == null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: AppColors.anxietyHigh,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        localization.getString('unable_to_analyze'),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () => context.go('/home'),
                        child: Text(localization.getString('go_back')),
                      ),
                    ],
                  ),
                );
              }

              return _buildAnalysisContent(context, analysis);
            },
            loading: () => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    localization.getString('finalizing_analysis'),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
            error: (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.anxietyHigh,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${localization.getString('error')}: $error',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.go('/home'),
                    child: Text(localization.getString('go_back')),
                  ),
                ],
              ),
            ),
          ),
        ),
        loading: () => Scaffold(
          backgroundColor: AppColors.background,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  'Finalizing analysis...',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ),
          ),
        ),
        error: (_, __) => Scaffold(
          backgroundColor: AppColors.background,
          body: analysisAsync.when(
            data: (analysis) {
              if (analysis == null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: AppColors.anxietyHigh,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Unable to analyze thought',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () => context.go('/home'),
                        child: const Text('Go Back'),
                      ),
                    ],
                  ),
                );
              }

              return _buildAnalysisContent(context, analysis);
            },
            loading: () => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    'Finalizing analysis...',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
            error: (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.anxietyHigh,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: $error',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.go('/home'),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _saveToHistory(AnalysisResponseModel analysis) {
    final entryId = _currentEntryId ?? DateTime.now().millisecondsSinceEpoch.toString();
    final entry = ThoughtEntryModel(
      id: entryId,
      thought: widget.thought,
      anxietyLevel: widget.anxietyLevel,
      createdAt: DateTime.now(),
      waitDurationSeconds: widget.waitDurationSeconds,
      analysisResult: jsonEncode(analysis.toJson()),
    );
    HiveService.thoughtsBox.put(entry.id, entry);
    _currentEntryId = entryId;
  }

  Widget _buildAnalysisContent(
    BuildContext context,
    AnalysisResponseModel analysis,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final horizontalPadding = isTablet ? 48.0 : AppConstants.defaultPadding;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: AppConstants.defaultPadding,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: isTablet ? 1200 : double.infinity,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bento Grid Layout - Editorial style
            // First row: OCD Awareness (full width)
            const OCDAwarenessCard(),
            const SizedBox(height: 16),
            
            // Second row: Validation Card (full width on mobile, half on tablet)
            if (isTablet)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ValidationCard(
                      message: analysis.empatheticValidation,
                      waitDurationSeconds: widget.waitDurationSeconds,
                    ),
                  ),
                ],
              )
            else
            ValidationCard(
              message: analysis.empatheticValidation,
              waitDurationSeconds: widget.waitDurationSeconds,
            ),
            const SizedBox(height: 16),
            
            // Third row: Detailed Risk Analysis Card (full width - important)
            DetailedRiskCard(
              perceivedRiskPercent: analysis.riskAnalysis.perceivedRiskPercent,
              perceivedReason: analysis.riskAnalysis.perceivedReason,
              actualRiskPercent: analysis.riskAnalysis.actualRiskPercent,
              actualReason: analysis.riskAnalysis.actualReason,
              comparisonAnalogy: analysis.riskAnalysis.comparisonAnalogy,
              safetyPercent: analysis.riskAnalysis.safetyPercent,
              analysisSummary: analysis.riskAnalysis.analysisSummary,
              anxietyLevel: widget.anxietyLevel,
            ),
            const SizedBox(height: 16),
            
            // Fourth row: Science and Brain Glitch (side by side on tablet)
            if (isTablet)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ExpandableMechanicsCard(
                      explanation: analysis.theScienceMechanism,
                      titleKey: 'the_science_behind_it',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ExpandableMechanicsCard(
                      explanation: analysis.theBrainGlitch,
                      titleKey: 'why_this_happens',
                    ),
                  ),
                ],
              )
            else
              Column(
                children: [
            ExpandableMechanicsCard(
              explanation: analysis.theScienceMechanism,
              titleKey: 'the_science_behind_it',
            ),
            const SizedBox(height: 16),
            ExpandableMechanicsCard(
              explanation: analysis.theBrainGlitch,
              titleKey: 'why_this_happens',
                  ),
                ],
            ),
            const SizedBox(height: 16),
            
            // Fifth row: Actionable Takeaway (full width)
            ActionableTakeawayCard(
              actionableTakeaway: analysis.actionableTakeaway,
            ),
            const SizedBox(height: 24),
            
            // Feedback Buttons
            FeedbackButtons(
              onSatisfied: () {
                if (_currentEntryId == null) {
                  _saveToHistory(analysis);
                }
                context.go('/home');
              },
              onNotSatisfied: () {
                // Open chat bottom sheet
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => TherapeuticChatSheet(
                    previousAnalysis: analysis,
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            
            // Disclaimer Card
            const DisclaimerCard(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}


/// Risk analysis model
/// Represents risk analysis data
class RiskAnalysisModel {
  final double perceivedRiskPercent;
  final String perceivedReason;
  final double actualRiskPercent;
  final String actualReason;
  final String comparisonAnalogy;
  final double safetyPercent;
  final String analysisSummary;

  RiskAnalysisModel({
    required this.perceivedRiskPercent,
    required this.perceivedReason,
    required this.actualRiskPercent,
    required this.actualReason,
    required this.comparisonAnalogy,
    required this.safetyPercent,
    required this.analysisSummary,
  });

  factory RiskAnalysisModel.fromJson(Map<String, dynamic> json) {
    return RiskAnalysisModel(
      perceivedRiskPercent: (json['perceived_risk_percent'] as num?)?.toDouble() ?? 99.9,
      perceivedReason: json['perceived_reason'] as String? ?? 'Based on your anxiety level.',
      actualRiskPercent: (json['actual_risk_percent'] as num?)?.toDouble() ?? 0.1,
      actualReason: json['actual_reason'] as String? ?? 'Based on scientific evidence.',
      comparisonAnalogy: json['comparison_analogy'] as String? ?? 'This is extremely unlikely.',
      safetyPercent: (json['safety_percent'] as num?)?.toDouble() ?? 99.9,
      analysisSummary: json['analysis_summary'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'perceived_risk_percent': perceivedRiskPercent,
      'perceived_reason': perceivedReason,
      'actual_risk_percent': actualRiskPercent,
      'actual_reason': actualReason,
      'comparison_analogy': comparisonAnalogy,
      'safety_percent': safetyPercent,
      'analysis_summary': analysisSummary,
    };
  }
}

/// Analysis response model
/// Represents the response from OpenAI API
class AnalysisResponseModel {
  final String empatheticValidation;
  final String theScienceMechanism;
  final String theBrainGlitch;
  final RiskAnalysisModel riskAnalysis;
  final String actionableTakeaway;

  // Legacy fields for backward compatibility
  String get validationMessage => empatheticValidation;
  String get scientificExplanation => theScienceMechanism;
  String get cognitiveReframe => theBrainGlitch;
  double get actualRiskPercentage => riskAnalysis.actualRiskPercent;
  double get safetyPercentage => riskAnalysis.safetyPercent;

  AnalysisResponseModel({
    required this.empatheticValidation,
    required this.theScienceMechanism,
    required this.theBrainGlitch,
    required this.riskAnalysis,
    required this.actionableTakeaway,
  });

  factory AnalysisResponseModel.fromJson(Map<String, dynamic> json) {
    // Support both new and legacy formats
    // Safely convert risk_analysis to Map<String, dynamic>
    final riskAnalysisRaw = json['risk_analysis'];
    Map<String, dynamic>? riskAnalysisJson;
    if (riskAnalysisRaw != null && riskAnalysisRaw is Map) {
      riskAnalysisJson = riskAnalysisRaw.map((key, value) {
        final stringKey = key?.toString() ?? '';
        return MapEntry(stringKey, value);
      });
    }
    
    return AnalysisResponseModel(
      empatheticValidation: json['empathetic_validation'] as String? ?? 
          (json['validation_message'] as String? ?? ''),
      theScienceMechanism: json['the_science_mechanism'] as String? ?? 
          (json['scientific_explanation'] as String? ?? ''),
      theBrainGlitch: json['the_brain_glitch'] as String? ?? 
          (json['cognitive_reframe'] as String? ?? ''),
      riskAnalysis: riskAnalysisJson != null
          ? RiskAnalysisModel.fromJson(riskAnalysisJson)
          : RiskAnalysisModel(
              perceivedRiskPercent: 99.9,
              perceivedReason: 'Based on your anxiety level.',
              actualRiskPercent: (json['actual_risk_percent'] as num?)?.toDouble() ?? 
                  (json['actual_risk_percentage'] as num?)?.toDouble() ?? 0.1,
              actualReason: 'Based on scientific evidence.',
              comparisonAnalogy: 'This is extremely unlikely.',
              safetyPercent: (json['safety_percent'] as num?)?.toDouble() ?? 
                  (json['safety_percentage'] as num?)?.toDouble() ?? 99.9,
              analysisSummary: '',
            ),
      actionableTakeaway: json['actionable_takeaway'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'empathetic_validation': empatheticValidation,
      'the_science_mechanism': theScienceMechanism,
      'the_brain_glitch': theBrainGlitch,
      'risk_analysis': riskAnalysis.toJson(),
      'actionable_takeaway': actionableTakeaway,
    };
  }

  /// Mock data for testing
  factory AnalysisResponseModel.mock() {
    return AnalysisResponseModel(
      empatheticValidation: 'You waited 2 minutes. That was the hardest part.',
      theScienceMechanism:
          'Your fear is likely a false alarm. The mechanism you\'re worried about (e.g., contamination, safety) has built-in safeguards. For example, soap works by breaking down the lipid layer of viruses and bacteria, and a single thorough wash is scientifically proven to be effective.',
      theBrainGlitch:
          'What you feel: Overwhelming certainty that something terrible will happen.\n\nWhat is real: The probability of actual harm is less than 0.1%. Your brain is amplifying uncertainty, but the facts show you are safe.',
      riskAnalysis: RiskAnalysisModel(
        perceivedRiskPercent: 99.9,
        perceivedReason: 'Based on the intense anxiety you feel.',
        actualRiskPercent: 0.1,
        actualReason: 'Based on scientific evidence.',
        comparisonAnalogy: 'This is less likely than being struck by lightning.',
        safetyPercent: 99.9,
        analysisSummary: 'You feel 99.9% at risk, but the actual risk is 0.1%.',
      ),
      actionableTakeaway: 'For the next hour, try to notice when your mind wants to check or seek reassurance.',
    );
  }
}


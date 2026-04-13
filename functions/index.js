const functions = require('firebase-functions');
const admin = require('firebase-admin');
const { OpenAI } = require('openai');

admin.initializeApp();

// Initialize OpenAI (lazy initialization)
// API key can be set via:
// 1. firebase functions:config:set openai.key="YOUR_KEY" (then use functions.config().openai.key)
// 2. Environment variable OPENAI_API_KEY (then use process.env.OPENAI_API_KEY)
// 3. Google Cloud Console > Cloud Functions > Environment variables
function getOpenAIClient() {
  // Try multiple methods to get API key
  let apiKey = process.env.OPENAI_API_KEY; // Environment variable
  if (!apiKey) {
    apiKey = functions.config().openai?.key; // Firebase config (deprecated but still works)
  }
  if (!apiKey) {
    throw new Error('OPENAI_API_KEY is not set. Please set it using one of these methods:\n' +
      '1. firebase functions:config:set openai.key="YOUR_KEY"\n' +
      '2. Google Cloud Console > Cloud Functions > Environment variables\n' +
      '3. Firebase Secrets (recommended)');
  }
  return new OpenAI({
    apiKey: apiKey,
  });
}

/**
 * Get system prompt for OCD analysis
 * This prompt enforces CBT/ERP principles and prevents pathological reassurance
 */
function getSystemPrompt(targetLanguage) {
  const languageName = targetLanguage === 'tr' ? 'Turkish' : 'English';
  
  return `You are "OCD Coach," an expert AI Assistant specialized in OCD (Obsessive-Compulsive Disorder), CBT (Cognitive Behavioral Therapy), and ERP (Exposure Response Prevention).

**YOUR GOAL:**
Help the user understand their situation using REAL, SPECIFIC data about their thought and anxiety level. Make them realize this is OCD, not their fault, and provide genuine insights that help them see reality clearly.

**CRITICAL PRINCIPLES:**
1. **THIS IS NOT THEIR FAULT:** Always emphasize that OCD is a neurological condition, not a character flaw. The user did not cause this. Their brain's threat-detection system is overactive due to OCD, which is a medical condition.
2. **NO Reassurance:** Never say "Don't worry," "It will be fine," or "You are definitely safe." This feeds OCD. Instead, provide FACTS and let them sit with uncertainty.
3. **REAL DATA:** Use the anxiety level (1-10) and the specific thought to provide personalized, realistic analysis. If anxiety is high (8-10), acknowledge the intensity. If it's moderate (4-7), note the progress.
4. **Scientific Mechanism:** Explain the *actual physics*, *biology*, or *logic* behind the trigger with SPECIFIC details. Cite real scientific facts, not generalities.
5. **Probability vs. Possibility:** Show REAL numbers. If the actual risk is 0.001%, say that. Be honest and specific.
6. **Tone:** Empathetic, Understanding, Educational, Supportive (like a therapist), but never condescending.
7. **Language:** You MUST generate the JSON content in the **${languageName}** language requested by the user.
8. **METAPHORS & ANALOGIES:** Use vivid, memorable metaphors to help users understand probability. For example: "This is more likely than being struck by lightning twice" or "You'd need to experience this scenario 10,000 times before it might happen once." Make these comparisons concrete and relatable.
9. **COGNITIVE DISTORTION NAMES:** Identify and name specific cognitive distortions when relevant:
   - "Catastrophizing" (assuming the worst-case scenario)
   - "Thought-Action Fusion" (believing thinking something makes it more likely to happen)
   - "Intolerance of Uncertainty" (inability to tolerate not knowing)
   - "Overestimation of Threat" (exaggerating the likelihood of danger)
   - "Magical Thinking" (believing thoughts or actions can influence unrelated events)
   - "All-or-Nothing Thinking" (seeing situations in black and white)
10. **SHERLOCK HOLMES STYLE DEDUCTIONS:** Use logical deduction to help users see reality:
    - "Deduction: If X were true, we would observe Y. But Y is not present, therefore X is not true."
    - "The evidence shows: [specific fact]. This contradicts your fear because [logical reason]."
    - Use clear, step-by-step logical reasoning that helps users see the disconnect between their feeling and reality.

**OUTPUT FORMAT:**
Return ONLY a raw JSON object (no markdown formatting) with these fields:
- \`empathetic_validation\`: A personalized, empathetic sentence (2-3 sentences) that:
  - Acknowledges their anxiety level specifically (e.g., "I see you're at an 8/10 anxiety level right now")
  - Validates that their fear feels very real
  - Reminds them this is OCD, not their fault (e.g., "This intense fear you're experiencing is your OCD's alarm system, not a reflection of reality or your character")
- \`the_science_mechanism\`: A DETAILED, SPECIFIC paragraph (minimum 120 words) explaining:
  - The actual physics/biology/chemistry/logic of the specific trigger
  - Real scientific facts, studies, or mechanisms
  - Why the feared outcome is extremely unlikely based on actual science
  - Be thorough, educational, and cite specific principles
- \`the_brain_glitch\`: A crucial section (minimum 4 sentences) that MUST:
  - Explain this is OCD, a neurological condition
  - Clarify it's NOT the user's fault
  - Explain the neuroscience: "Your Amygdala (fear center) is firing false alarms. This is due to OCD, which causes your brain's threat-detection system to be overactive. This is a medical condition, not a personal failing."
  - Help them understand the difference between the feeling (real) and the threat (not real)
- \`risk_analysis\`: An object with:
  - \`perceived_risk_percent\`: What the user feels the risk is based on their anxiety level (e.g., if anxiety is 9/10, perceived risk might be 95-99%)
  - \`perceived_reason\`: A short explanation (max 10 words) of WHY the user feels this risk is so high, based on their anxiety level and thought pattern. Example: "Based on the intense anxiety (10/10) you feel."
  - \`actual_risk_percent\`: The REALISTIC probability based on actual data (be specific, e.g., 0.001%, 0.01%, etc.)
  - \`actual_reason\`: A specific scientific/logical reason (max 10 words) explaining WHY the actual risk is so low. Be concrete and specific. Example: "Bacteria cannot survive on dry surfaces." or "Muscle memory handles routine tasks."
  - \`comparison_analogy\`: A one-sentence metaphor comparing this probability to something absurd or well-known. Make it memorable and concrete. Example: "You are more likely to be struck by lightning twice than for this to happen." or "This is less likely than winning the lottery three times in a row."
  - \`safety_percent\`: The remaining safety probability (100 - actual_risk_percent)
  - \`analysis_summary\`: A detailed, personalized sentence (2-3 sentences) that:
    - Compares perceived vs actual risk
    - Explains the discrepancy is due to OCD, not reality
    - Uses their specific anxiety level in the explanation
    - May reference the cognitive distortion by name if relevant
- \`actionable_takeaway\`: A practical, non-compulsive tip (2-3 sentences) for the next hour that:
  - Is specific to their situation
  - Helps them practice ERP
  - Reminds them they're practicing a skill, not failing

**EXAMPLE SCENARIO:**
User: "I touched a door handle and I feel like I contracted HIV."
Response (JSON):
{
  "empathetic_validation": "I understand your mind is sounding a loud alarm right now, and that feels very real.",
  "the_science_mechanism": "HIV is an extremely fragile virus that cannot survive outside the human body for more than a few seconds. It requires direct bloodstream transmission, which is physically impossible through intact skin touching a dry surface. The virus's lipid envelope breaks down immediately upon exposure to air.",
  "the_brain_glitch": "Your Amygdala fired a false alarm. It's treating a zero-risk situation as a survival threat. This is a biological misfire in your threat-detection system, not a reflection of your character or reality. Your brain is doing its job of protecting you, but it's overreacting to uncertainty.",
  "risk_analysis": {
    "perceived_risk_percent": 99.9,
    "perceived_reason": "Based on the intense anxiety (10/10) you feel.",
    "actual_risk_percent": 0.00,
    "actual_reason": "HIV cannot survive outside the human body.",
    "comparison_analogy": "You are more likely to be struck by lightning twice than to contract HIV this way.",
    "safety_percent": 100.00,
    "analysis_summary": "You feel 99.9% at risk, but the actual risk is 0%. Your brain is amplifying uncertainty through a cognitive distortion called 'Overestimation of Threat.'"
  },
  "actionable_takeaway": "For the next hour, try to notice when your mind wants to check or seek reassurance. Acknowledge the thought, but don't act on it."
}`;
}

/**
 * Check if input contains self-harm or emergency keywords
 */
function checkForEmergency(userText) {
  const emergencyKeywords = [
    'suicide', 'kill myself', 'end my life', 'want to die',
    'intihar', 'kendimi öldürmek', 'hayatıma son vermek', 'ölmek istiyorum'
  ];
  
  const lowerText = userText.toLowerCase();
  return emergencyKeywords.some(keyword => lowerText.includes(keyword));
}

/**
 * Firebase Function to analyze thought using OpenAI
 * This function proxies OpenAI API calls securely
 */
exports.analyzeThought = functions.region('us-central1').https.onCall(async (data, context) => {
  // Verify user is authenticated (anonymous is fine)
  if (!context.auth) {
    throw new functions.https.HttpsError(
      'unauthenticated',
      'User must be authenticated'
    );
  }

  // Input validation
  const { userText, language, anxietyLevel } = data;

  if (!userText || typeof userText !== 'string' || userText.trim().length === 0) {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'userText is required and must be a non-empty string'
    );
  }

  // Validate anxiety level
  const anxiety = typeof anxietyLevel === 'number' 
    ? Math.max(1, Math.min(10, anxietyLevel)) 
    : 5;

  // Validate language (default to 'en')
  const targetLanguage = (language === 'tr' || language === 'en') ? language : 'en';

  // Check for emergency situations
  if (checkForEmergency(userText)) {
    return {
      error: 'EMERGENCY_HELP',
      message: 'Please seek immediate professional help. You are not alone.'
    };
  }

  try {
    const openai = getOpenAIClient();
    const systemPrompt = getSystemPrompt(targetLanguage);

    const completion = await openai.chat.completions.create({
      model: 'gpt-4o-mini', // Using GPT-4o-mini for cost efficiency
      messages: [
        { role: 'system', content: systemPrompt },
        {
          role: 'user',
          content: `Anxiety Level: ${anxiety}/10\n\nThought: ${userText}\n\nProvide analysis in the specified JSON format.`,
        },
      ],
      response_format: { type: 'json_object' },
      temperature: 0.7,
    });

    const responseText = completion.choices[0].message.content;
    
    if (!responseText) {
      throw new Error('Empty response from OpenAI');
    }

    const analysis = JSON.parse(responseText);

    // Validate and normalize response
    const riskAnalysis = analysis.risk_analysis || {};
    
    return {
      empathetic_validation: analysis.empathetic_validation || '',
      the_science_mechanism: analysis.the_science_mechanism || '',
      the_brain_glitch: analysis.the_brain_glitch || '',
      risk_analysis: {
        perceived_risk_percent: typeof riskAnalysis.perceived_risk_percent === 'number'
          ? riskAnalysis.perceived_risk_percent
          : (riskAnalysis.perceived_risk_percentage || 99.9),
        perceived_reason: riskAnalysis.perceived_reason || 'Based on your anxiety level.',
        actual_risk_percent: typeof riskAnalysis.actual_risk_percent === 'number'
          ? riskAnalysis.actual_risk_percent
          : (riskAnalysis.actual_risk_percentage || 0.1),
        actual_reason: riskAnalysis.actual_reason || 'Based on scientific evidence.',
        comparison_analogy: riskAnalysis.comparison_analogy || 'This is extremely unlikely.',
        safety_percent: typeof riskAnalysis.safety_percent === 'number'
          ? riskAnalysis.safety_percent
          : (riskAnalysis.safety_percentage || 99.9),
        analysis_summary: riskAnalysis.analysis_summary || '',
      },
      actionable_takeaway: analysis.actionable_takeaway || '',
    };
  } catch (error) {
    console.error('OpenAI API Error:', error);
    
    // Return user-friendly error
    throw new functions.https.HttpsError(
      'internal',
      'Failed to analyze thought. Please try again.',
      error.message
    );
  }
});

/**
 * Get system prompt for therapeutic chat
 * This prompt enforces Socratic questioning and prevents reassurance
 */
function getChatSystemPrompt(targetLanguage, previousAnalysis) {
  const languageName = targetLanguage === 'tr' ? 'Turkish' : 'English';
  
  return `You are "OCD Coach," an expert AI Assistant specialized in OCD (Obsessive-Compulsive Disorder), CBT (Cognitive Behavioral Therapy), and ERP (Exposure Response Prevention).

**CONTEXT:**
The user has just received an analysis about their thought, but they are still anxious and not satisfied. Here is the previous analysis:
${JSON.stringify(previousAnalysis, null, 2)}

**YOUR GOAL:**
Help the user sit with uncertainty using Socratic questioning. Do NOT provide reassurance.

**CORE RULES (STRICT):**
1. **NO Reassurance:** Never say "Don't worry," "It will be fine," or "You are definitely safe." This feeds OCD.
2. **Socratic Questions:** Ask open-ended questions that help the user explore their thoughts:
   - "What specifically feels unresolved?"
   - "What is the worst case scenario you're imagining?"
   - "What would it mean if that worst case happened?"
   - "How would you cope if that happened?"
   - "What evidence do you have that supports this fear?"
   - "What evidence contradicts this fear?"
3. **Validate Without Reassuring:** Acknowledge their anxiety without trying to fix it.
4. **Encourage Uncertainty Tolerance:** Help them practice sitting with "maybe" and "I don't know."
5. **Tone:** Empathetic, Curious, Calm, Non-judgmental.
6. **Language:** You MUST respond in **${languageName}** language.

**OUTPUT FORMAT:**
Return ONLY a raw JSON object (no markdown formatting) with these fields:
- \`response\`: Your Socratic question or empathetic response (2-3 sentences max)
- \`is_question\`: Boolean indicating if this is a question (true) or a statement (false)

**EXAMPLE:**
User: "I'm still worried that I might have contracted something."
Response (JSON):
{
  "response": "I understand the worry is still there. Can you tell me what specifically feels unresolved about the situation? What is the worst case scenario you're imagining?",
  "is_question": true
}`;
}

/**
 * Firebase Function for therapeutic chat
 * Provides Socratic questioning when user is still anxious after analysis
 */
exports.therapeuticChat = functions.region('us-central1').https.onCall(async (data, context) => {
  // Verify user is authenticated
  if (!context.auth) {
    throw new functions.https.HttpsError(
      'unauthenticated',
      'User must be authenticated'
    );
  }

  // Input validation
  const { userMessage, previousAnalysis, language, conversationHistory } = data;

  if (!userMessage || typeof userMessage !== 'string' || userMessage.trim().length === 0) {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'userMessage is required and must be a non-empty string'
    );
  }

  // Validate language (default to 'en')
  const targetLanguage = (language === 'tr' || language === 'en') ? language : 'en';

  // Check for emergency situations
  if (checkForEmergency(userMessage)) {
    return {
      error: 'EMERGENCY_HELP',
      message: 'Please seek immediate professional help. You are not alone.'
    };
  }

  try {
    const openai = getOpenAIClient();
    const systemPrompt = getChatSystemPrompt(targetLanguage, previousAnalysis || {});

    // Build conversation history
    const messages = [
      { role: 'system', content: systemPrompt },
    ];

    // Add conversation history if provided
    if (conversationHistory && Array.isArray(conversationHistory)) {
      conversationHistory.forEach(msg => {
        if (msg.role && msg.content) {
          messages.push({
            role: msg.role,
            content: msg.content,
          });
        }
      });
    }

    // Add current user message
    messages.push({
      role: 'user',
      content: userMessage,
    });

    const completion = await openai.chat.completions.create({
      model: 'gpt-4o-mini',
      messages: messages,
      response_format: { type: 'json_object' },
      temperature: 0.7,
    });

    const responseText = completion.choices[0].message.content;
    
    if (!responseText) {
      throw new Error('Empty response from OpenAI');
    }

    const chatResponse = JSON.parse(responseText);

    return {
      response: chatResponse.response || '',
      isQuestion: chatResponse.is_question || false,
    };
  } catch (error) {
    console.error('Therapeutic Chat API Error:', error);
    
    throw new functions.https.HttpsError(
      'internal',
      'Failed to process chat message. Please try again.',
      error.message
    );
  }
});

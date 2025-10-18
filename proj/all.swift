//
//  all.swift
//  proj
//
//  Created by Layan on 26/04/1447 AH.
//
import SwiftUI
import ConfettiSwiftUI

// MARK: - 0. Question Struct
struct QuizQuestion: Identifiable, Codable {
    let id: Int
    let qAr: String
    let qEn: String
    let aAr: [String]
    let aEn: [String]
    let correctAr: String
    let correctEn: String

    func getQuestion(isArabic: Bool) -> String {
        return isArabic ? qAr : qEn
    }
    func getAnswers(isArabic: Bool) -> [String] {
        return isArabic ? aAr : aEn
    }
    func getCorrectAnswer(isArabic: Bool) -> String {
        return isArabic ? correctAr : correctEn
    }
}

// MARK: - Custom Colors
extension Color {
    static let babyBlue = Color(red: 0.3, green: 0.6, blue: 1.0)
    static let stickyNoteYellow = Color(red: 1.0, green: 0.96, blue: 0.78)
    static let lightBlueBackground = Color(red: 0.95, green: 0.96, blue: 1.0)
    static let lightAnswerBackground = Color(red: 0.80, green: 0.90, blue: 1.0)
    static let progressBackground = Color(red: 0.9, green: 0.95, blue: 1.0)
}

// MARK: - 1. TopNumberBar
struct TopNumberBar: View {
    let totalSteps = 5
    @Binding var stepResults: [Bool?]
    @Binding var timeRemaining: Double
    @Binding var isArabic: Bool
    
    var onTimeOut: () -> Void
    
    private let maxTime: Double = 60
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var answeredCount: Int {
        stepResults.filter { $0 != nil }.count
    }
    
    var progressAmount: CGFloat {
        CGFloat(answeredCount) / CGFloat(totalSteps)
    }
    
    var body: some View {
        HStack(spacing: 8) {
            
            // 1. شريط التقدم
            VStack(alignment: isArabic ? .trailing : .leading, spacing: 4) {
                Text(isArabic ? "التقدم الحالي" : "Current Progress")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                ZStack(alignment: isArabic ? .trailing : .leading) {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.progressBackground)
                        .frame(height: 20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                        )
                    
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.babyBlue)
                        .frame(width: 250 * progressAmount, height: 20)
                        .animation(.easeInOut, value: answeredCount)
                    
                    Text("\(answeredCount)/\(totalSteps)")
                        .font(.subheadline)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                }
                .frame(minWidth: 250, maxWidth: 280)
            }
            .environment(\.layoutDirection, isArabic ? .rightToLeft : .leftToRight)
            
            
            Spacer()
            
            // 2. التايمر الأزرق
            ZStack {
                Circle()
                    .fill(Color.babyBlue)
                    .frame(width: 55, height: 55)
                    .shadow(radius: 3)
                
                Circle()
                    .trim(from: 0, to: CGFloat(timeRemaining / maxTime))
                    .stroke(Color.white, lineWidth: 4)
                    .frame(width: 50, height: 50)
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 0.1), value: timeRemaining)
                
                Text("\(Int(timeRemaining))")
                    .foregroundColor(.white)
                    .font(.title3)
                    .fontWeight(.heavy)
            }
            .padding(.trailing, 8)
        }
        .padding(.horizontal)
        .padding(.top, 10)
        .onReceive(timer) { _ in
            if timeRemaining > 0 && !allQuestionsAnswered() {
                timeRemaining -= 1
            } else if timeRemaining == 0 && !allQuestionsAnswered() {
                onTimeOut()
            }
        }
    }

    private func borderColor(for index: Int) -> Color {
        guard index >= 0 && index < stepResults.count else { return .blue }
        if let result = stepResults[index] {
            return result ? .green : .red
        }
        return .blue
    }
    
    private func allQuestionsAnswered() -> Bool {
        return !stepResults.contains(where: { $0 == nil })
    }
}

// MARK: - 2. Sticky Note View
struct StickyNoteView: View {
    var text: String
    var rotation: Double
    var xOffset: CGFloat
    var yOffset: CGFloat
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.stickyNoteYellow)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.gray, lineWidth: 1)
                )
            
            if !text.isEmpty {
                Text(text)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding(14)
                    .foregroundColor(.black)
            }
        }
        .frame(width: 300, height: 270)
        .rotationEffect(.degrees(rotation))
        .offset(x: xOffset, y: yOffset)
    }
}

// MARK: - 3. ComeTomorrowView
struct ComeTomorrowView: View {
    @Binding var isPresented: Bool
    var remainingQuestions: Int
    @Binding var isArabic: Bool
    
    @AppStorage("cooldownDate") private var cooldownDate: Double = 0
    private var isCooldownActive: Bool { return cooldownDate > Date().timeIntervalSince1970 }
    private var formattedUnlockTime: String {
        let tomorrow = Date(timeIntervalSince1970: cooldownDate)
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: tomorrow)
    }

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack(spacing: 20) {
                Spacer()
                
                Image(remainingQuestions == -2 ? "80" : "79")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 200)

                if remainingQuestions == -2 {
                    Text(isArabic ? "✅ تم الانتهاء من جميع الأسئلة المتاحة!" : "✅ All available questions have been completed!")
                        .font(.title)
                        .foregroundColor(.green)
                        .multilineTextAlignment(.center)
                    
                    Text(isArabic ? "راجع معلوماتك أو انتظر أسئلة جديدة." : "Review your knowledge or wait for new questions.")
                        .font(.body)
                        .foregroundColor(.gray)
                } else if remainingQuestions == 0 {
                    Text(isArabic ? "أكملت تحدي اليوم بنجاح!" : "You successfully completed today's challenge!")
                        .font(.title3)
                        .foregroundColor(.green)
                        .multilineTextAlignment(.center)
                    
                    Text(isArabic ? "عد غداً في **\(formattedUnlockTime)**" : "Come back tomorrow at **\(formattedUnlockTime)**")
                        .font(.largeTitle)
                        .foregroundColor(.blue)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                } else {
                    Text(isArabic ? "انتهى تحدي اليوم." : "Today's challenge has ended.")
                        .font(.title3)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                    
                    Text(isArabic ? "عد غداً في **\(formattedUnlockTime)**" : "Come back tomorrow at **\(formattedUnlockTime)**")
                        .font(.largeTitle)
                        .foregroundColor(.blue)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
            }
        }
        .onAppear {
            if remainingQuestions != -2 {
                if cooldownDate == 0 || !isCooldownActive {
                    let cooldownDuration: TimeInterval = 24 * 60 * 60
                    cooldownDate = Date().timeIntervalSince1970 + cooldownDuration
                }
            }
        }
        .environment(\.layoutDirection, isArabic ? .rightToLeft : .leftToRight)
    }
}


// MARK: - 4. TopStepsView
struct TopStepsView: View {
    @State private var counter = 0
    @State private var isActive = true
    @Binding var isPresented: Bool
    @Binding var shouldDismissQuiz: Bool
    @Binding var shouldContinueQuiz: Bool
    @Binding var quizRemainingQuestions: Int
    @Binding var isArabic: Bool

    var body: some View {
        ZStack {
            Color.gray.opacity(0.2)
                .ignoresSafeArea()
            VStack(spacing: 12) {
                Text("🎉")
                    .font(.system(size: 60))
                
                Text(isArabic ? "تهانينا!" : "Congratulations!")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                    .multilineTextAlignment(.center)
                
                Text(isArabic ? "أكملت 5 أسئلة بنجاح! تابع لإنهاء التحدي." : "You completed 5 questions successfully! Continue to finish the challenge.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                
                Button(action: {
                    isPresented = false
                    shouldContinueQuiz = true
                }) {
                    Text(isArabic ? "متابعة التحدي" : "Continue Challenge")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: 200,maxHeight: 7)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(5)
                }
                .padding(.horizontal, 24)

                Button(action: {
                    isPresented = false
                    quizRemainingQuestions = -1
                    shouldContinueQuiz = false
                }) {
                    Text(isArabic ? "تخطي لغدًا" : "Skip for Tomorrow")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.gray)
                }
                .padding(.top, 8)
                
            }
            .padding(24)
            .background(Color.white)
            .cornerRadius(60)
            .shadow(color:Color.black.opacity(0.15),radius: 6, x: 0, y: 4)
            .padding()
        }
        .confettiCannon(trigger: $counter, num: 40, colors: [.red, .blue, .green, .yellow, .pink], repetitions: isActive ? 1000 : 0, repetitionInterval: 0.6)
        .onAppear { counter += 1 }
        .onChange(of: isPresented) { newValue in
            if !newValue { isActive = false }
        }
        .environment(\.layoutDirection, isArabic ? .rightToLeft : .leftToRight)
    }
}


// MARK: - 5. FailMotivationalView
struct FailMotivationalView: View {
    @Binding var isPresented: Bool
    @Binding var shouldContinueQuiz: Bool
    @Binding var quizRemainingQuestions: Int
    @Binding var isArabic: Bool
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.2)
                .ignoresSafeArea()
            
            VStack {
                VStack(spacing: 12) {
                    Text("💡")
                        .font(.system(size: 70))
                    
                    Text(isArabic ? "لنتعلم من الخطأ" : "Let's Learn from Mistakes")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.blue)
                        .multilineTextAlignment(.center)
                    
                    Text(isArabic ? "كل محاولة هي خطوة نحو النجاح." : "Every attempt is a step towards success.")
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                    
                    Button(action: {
                        isPresented = false
                        shouldContinueQuiz = true
                    }) {
                        Text(isArabic ? "متابعة الأسئلة" : "Continue Questions")
                            .frame(maxWidth: 200, maxHeight: 7)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(5)
                    }
                    .padding(.top, 10)
                    
                    Button(action: {
                        isPresented = false
                        quizRemainingQuestions = -1
                        shouldContinueQuiz = false
                    }) {
                        Text(isArabic ? "إنهاء التحدي لليوم" : "End Challenge for Today")
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .frame(width: 280)
                .background(Color.white)
                .cornerRadius(60)
                .shadow(color: Color.black.opacity(0.15), radius: 6, x: 0, y: 4)
            }
        }
        .environment(\.layoutDirection, isArabic ? .rightToLeft : .leftToRight)
    }
}

// MARK: - 9. TimeoutView
struct TimeoutView: View {
    @Binding var isPresented: Bool
    @Binding var shouldRetry: Bool
    @Binding var quizRemainingQuestions: Int
    @Binding var isArabic: Bool
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.2)
                .ignoresSafeArea()
            
            VStack {
                VStack(spacing: 12) {
                    Text("⏰")
                        .font(.system(size: 70))
                    
                    Text(isArabic ? "انتهى الوقت!" : "Time's Up!")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                    
                    Text(isArabic ? "لم تتمكن من إنهاء المجموعة في الوقت المحدد." : "You couldn't finish the group in time.")
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                    
                    // Button 1: Retry (إعادة المحاولة)
                    Button(action: {
                        isPresented = false
                        shouldRetry = true
                    }) {
                        Text(isArabic ? "إعادة محاولة المجموعة" : "Retry Group")
                            .frame(maxWidth: 200, maxHeight: 7)
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(5)
                    }
                    .padding(.top, 10)
                    
                    // Button 2: Skip (إنهاء التحدي لليوم)
                    Button(action: {
                        isPresented = false
                        quizRemainingQuestions = -1
                        shouldRetry = false
                    }) {
                        Text(isArabic ? "إنهاء التحدي لليوم" : "End Challenge for Today")
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .frame(width: 280)
                .background(Color.white)
                .cornerRadius(60)
                .shadow(color: Color.black.opacity(0.15), radius: 6, x: 0, y: 4)
            }
        }
        .environment(\.layoutDirection, isArabic ? .rightToLeft : .leftToRight)
    }
}

// MARK: - 8. CoachMarkView
struct CoachMarkView: View {
    let text: String
    let geometry: GeometryProxy
    let targetX: CGFloat
    let targetY: CGFloat
    let onDismiss: () -> Void
    @Binding var isArabic: Bool
    
    var body: some View {
        Color.black.opacity(0.3).ignoresSafeArea()
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation { onDismiss() }
            }
            .overlay(
                VStack(spacing: 5) {
                    Text(text)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(8)
                }
                .padding(8)
                .frame(width: 150)
                .background(Color.stickyNoteYellow)
                .cornerRadius(8)
                .shadow(radius: 5)
                .position(x: targetX, y: targetY)
                .transition(.opacity)
            )
            .environment(\.layoutDirection, isArabic ? .rightToLeft : .leftToRight)
    }
}

// MARK: - 6. Quiz View (Main Questions Screen)
struct QuizView: View {
    @Binding var isPresented: Bool
    
    @State private var isShowingTopStepsView: Bool = false
    @State private var isShowingFailView: Bool = false
    @State private var isShowingTimeoutView: Bool = false
    @State private var shouldRetryGroup: Bool = false
    
    @State private var stepResults: [Bool?] = Array(repeating: nil, count: 5)
    private let maxTime: Double = 60
    @State private var timeRemaining: Double = 60
    
    @State private var shouldShowComeTomorrow: Bool = false
    @State private var remainingQuestions: Int = 0
    
    @State private var shouldContinueQuiz: Bool = false
    @State private var isTutorialActive: Bool = true
    @State private var tutorialStep: Int = 0
    
    @AppStorage("isArabic") private var isArabic: Bool = true
    @AppStorage("askedQuestionIDs") private var askedQuestionIDsData: Data = Data()
    
    // **Full Question Set (40 سؤالاً مع الترجمة)**
    let allQuestions: [QuizQuestion] = [
        QuizQuestion(id: 1, qAr: "ما هي عاصمة كندا؟", qEn: "What is the capital of Canada?", aAr: ["تورنتو","أوتاوا","فانكوفر","مونتريال"], aEn: ["Toronto","Ottawa","Vancouver","Montreal"], correctAr: "أوتاوا", correctEn: "Ottawa"),
        QuizQuestion(id: 2, qAr: "أي قارة هي الأكبر من حيث المساحة؟", qEn: "Which continent is the largest by area?", aAr: ["أفريقيا","آسيا","أوروبا","أمريكا الشمالية"], aEn: ["Africa","Asia","Europe","North America"], correctAr: "آسيا", correctEn: "Asia"),
        QuizQuestion(id: 3, qAr: "ما هو أطول نهر في العالم؟", qEn: "What is the longest river in the world?", aAr: ["النيل","الأمازون","المسيسيبي","يانغتسي"], aEn: ["Nile","Amazon","Mississippi","Yangtze"], correctAr: "النيل", correctEn: "Nile"),
        QuizQuestion(id: 4, qAr: "ما هو أعلى جبل في العالم؟", qEn: "What is the tallest mountain in the world?", aAr: ["كليمنجارو","البروس","إيفرست","K2"], aEn: ["Mount Kilimanjaro","Mount Elbrus","Mount Everest","K2"], correctAr: "إيفرست", correctEn: "Mount Everest"),
        QuizQuestion(id: 5, qAr: "ما قيمة 7 × 8؟", qEn: "What is the value of 7 × 8?", aAr: ["54","56","58","64"], aEn: ["54","56","58","64"], correctAr: "56", correctEn: "56"),
        QuizQuestion(id: 6, qAr: "ما هي عاصمة أستراليا؟", qEn: "What is the capital of Australia?", aAr: ["سيدني","كانبيرا","ملبورن","بريزبين"], aEn: ["Sydney","Canberra","Melbourne","Brisbane"], correctAr: "كانبيرا", correctEn: "Canberra"),
        QuizQuestion(id: 7, qAr: "ما هي 25% من 200؟", qEn: "What is 25% of 200?", aAr: ["25","50","75","100"], aEn: ["25","50","75","100"], correctAr: "50", correctEn: "50"),
        QuizQuestion(id: 8, qAr: "أي صحراء هي الأكبر في العالم؟", qEn: "Which desert is the largest in the world?", aAr: ["العربية","جوبي","الصحراء الكبرى","تار"], aEn: ["Arabian","Gobi","Sahara","Thar"], correctAr: "الصحراء الكبرى", correctEn: "Sahara"),
        QuizQuestion(id: 9, qAr: "ما هي أصغر دولة في العالم؟", qEn: "What is the smallest country in the world?", aAr: ["موناكو","الفاتيكان","سان مارينو","مالطا"], aEn: ["Monaco","Vatican City","San Marino","Malta"], correctAr: "الفاتيكان", correctEn: "Vatican City"),
        QuizQuestion(id: 10, qAr: "ما هو 10²؟", qEn: "What is 10 squared?", aAr: ["10","20","100","1000"], aEn: ["10","20","100","1000"], correctAr: "100", correctEn: "100"),
        
        QuizQuestion(id: 11, qAr: "أي عنصر يمثله 'O' في الجدول الدوري؟", qEn: "What element does 'O' represent on the periodic table?", aAr: ["الأكسجين", "الذهب", "الأوزميوم", "الزيت"], aEn: ["Oxygen", "Gold", "Osmum", "Oil"], correctAr: "الأكسجين", correctEn: "Oxygen"),
        QuizQuestion(id: 12, qAr: "من رسم لوحة الموناليزا؟", qEn: "Who painted the Mona Lisa?", aAr: ["فان جوخ", "بيكاسو", "ليوناردو دا فينشي", "مونيه"], aEn: ["Van Gogh", "Picasso", "Da Vinci", "Monet"], correctAr: "ليوناردو دا فينشي", correctEn: "Da Vinci"),
        QuizQuestion(id: 13, qAr: "أي كوكب يعرف باسم الكوكب الأحمر؟", qEn: "Which planet is known as the Red Planet?", aAr: ["المشتري", "المريخ", "الزهرة", "زحل"], aEn: ["Jupiter", "Mars", "Venus", "Saturn"], correctAr: "المريخ", correctEn: "Mars"),
        QuizQuestion(id: 14, qAr: "ما هي الصيغة الكيميائية للماء؟", qEn: "What is the chemical formula for water?", aAr: ["CO2", "H2O2", "H2O", "O2"], aEn: ["CO2", "H2O2", "H2O", "O2"], correctAr: "H2O", correctEn: "H2O"),
        QuizQuestion(id: 15, qAr: "كم عدد العظام في جسم الإنسان البالغ؟", qEn: "How many bones are in the adult human body?", aAr: ["206", "180", "220", "250"], aEn: ["206", "180", "220", "250"], correctAr: "206", correctEn: "206"),
        
        QuizQuestion(id: 16, qAr: "ما هو أسرع حيوان بري؟", qEn: "What is the fastest land animal?", aAr: ["الأسد","الفهد","الغزال","الحصان"], aEn: ["Lion","Cheetah","Gazelle","Horse"], correctAr: "الفهد", correctEn: "Cheetah"),
        QuizQuestion(id: 17, qAr: "كم عدد القلوب في الأخطبوط؟", qEn: "How many hearts does an octopus have?", aAr: ["1","2","3","4"], aEn: ["1","2","3","4"], correctAr: "3", correctEn: "3"),
        QuizQuestion(id: 18, qAr: "من هو مؤلف مسرحية 'روميو وجولييت'؟", qEn: "Who wrote 'Romeo and Juliet'?", aAr: ["تشارلز ديكنز","وليام شكسبير","جين أوستن","مارك توين"], aEn: ["Charles Dickens","William Shakespeare","Jane Austen","Mark Twain"], correctAr: "وليام شكسبير", correctEn: "William Shakespeare"),
        QuizQuestion(id: 19, qAr: "ما العملة الرسمية لليابان؟", qEn: "What is the official currency of Japan?", aAr: ["وون","يوان","ين","دولار"], aEn: ["Won","Yuan","Yen","Dollar"], correctAr: "ين", correctEn: "Yen"),
        QuizQuestion(id: 20, qAr: "ما هو الغاز الأكثر وفرة في الغلاف الجوي للأرض؟", qEn: "What is the most abundant gas in Earth's atmosphere?", aAr: ["الأكسجين","النيتروجين","ثاني أكسيد الكربون","الأرغون"], aEn: ["Oxygen","Nitrogen","Carbon Dioxide","Argon"], correctAr: "النيتروجين", correctEn: "Nitrogen"),
        QuizQuestion(id: 21, qAr: "في أي عام سقط جدار برلين؟", qEn: "In which year did the Berlin Wall fall?", aAr: ["1989","1991","1985","1995"], aEn: ["1989","1991","1985","1995"], correctAr: "1989", correctEn: "1989"),
        QuizQuestion(id: 22, qAr: "ما هي عاصمة البرازيل؟", qEn: "What is the capital of Brazil?", aAr: ["ريو دي جانيرو","ساو باولو","برازيليا","بوينس آيرس"], aEn: ["Rio de Janeiro","Sao Paulo","Brasília","Buenos Aires"], correctAr: "برازيليا", correctEn: "Brasília"),
        QuizQuestion(id: 23, qAr: "ما هو أكبر محيط في العالم؟", qEn: "What is the largest ocean in the world?", aAr: ["الأطلسي","الهندي","القطبي الشمالي","الهادئ"], aEn: ["Atlantic","Indian","Arctic","Pacific"], correctAr: "الهادئ", correctEn: "Pacific"),
        QuizQuestion(id: 24, qAr: "ما هو العنصر الكيميائي الذي يرمز له بالرمز Au؟", qEn: "What chemical element is represented by the symbol Au?", aAr: ["الفضة","الذهب","الألومنيوم","الحديد"], aEn: ["Silver","Gold","Aluminum","Iron"], correctAr: "الذهب", correctEn: "Gold"),
        QuizQuestion(id: 25, qAr: "من اخترع المصباح الكهربائي؟", qEn: "Who invented the electric light bulb?", aAr: ["تسلا","إديسون","بيل","فاراداي"], aEn: ["Tesla","Edison","Bell","Faraday"], correctAr: "إديسون", correctEn: "Edison"),
        
        QuizQuestion(id: 26, qAr: "ما هي عاصمة إيطاليا؟", qEn: "What is the capital of Italy?", aAr: ["ميلانو","البندقية","روما","نابولي"], aEn: ["Milan","Venice","Rome","Naples"], correctAr: "روما", correctEn: "Rome"),
        QuizQuestion(id: 27, qAr: "كم عدد ألوان قوس قزح؟", qEn: "How many colors are in a rainbow?", aAr: ["5","6","7","8"], aEn: ["5","6","7","8"], correctAr: "7", correctEn: "7"),
        QuizQuestion(id: 28, qAr: "ما هو نوع الطاقة التي تنتجها الشمس؟", qEn: "What type of energy does the sun produce?", aAr: ["حرارية","نووية","كهربائية","شمسية"], aEn: ["Thermal","Nuclear","Electrical","Solar"], correctAr: "نووية", correctEn: "Nuclear"),
        QuizQuestion(id: 29, qAr: "ما هي أبرد درجة حرارة يمكن أن توجد؟", qEn: "What is the coldest possible temperature?", aAr: ["0 كلفن","10- كلفن","0 سيلزيوس","273- كلفن"], aEn: ["0 Kelvin","10- Kelvin","0 Celsius","273- Kelvin"], correctAr: "0 كلفن", correctEn: "0 Kelvin"),
        QuizQuestion(id: 30, qAr: "من غنى أغنية 'Bohemian Rhapsody'؟", qEn: "Who sang 'Bohemian Rhapsody'?", aAr: ["البيتلز","كوين","ليد زيبلين","رولينج ستونز"], aEn: ["The Beatles","Queen","Led Zeppelin","Rolling Stones"], correctAr: "كوين", correctEn: "Queen"),
        
        QuizQuestion(id: 31, qAr: "في أي مدينة يقع برج إيفل؟", qEn: "In which city is the Eiffel Tower located?", aAr: ["لندن","نيويورك","باريس","مدريد"], aEn: ["London","New York","Paris","Madrid"], correctAr: "باريس", correctEn: "Paris"),
        QuizQuestion(id: 32, qAr: "ما هو عدد جوانب البنتاغون؟", qEn: "How many sides does a pentagon have?", aAr: ["4","5","6","7"], aEn: ["4","5","6","7"], correctAr: "5", correctEn: "5"),
        QuizQuestion(id: 33, qAr: "ما هي عاصمة مصر؟", qEn: "What is the capital of Egypt?", aAr: ["القاهرة","الإسكندرية","الجيزة","أسوان"], aEn: ["Cairo","Alexandria","Giza","Aswan"], correctAr: "القاهرة", correctEn: "Cairo"),
        QuizQuestion(id: 34, qAr: "ما هو الرقم الهيدروجيني (pH) للماء النقي؟", qEn: "What is the pH level of pure water?", aAr: ["0","7","14","1"], aEn: ["0","7","14","1"], correctAr: "7", correctEn: "7"),
        QuizQuestion(id: 35, qAr: "ما هو اسم المجرة التي تنتمي إليها الأرض؟", qEn: "What is the name of the galaxy Earth belongs to?", aAr: ["أندروميدا","درب التبانة","تريانغولوم","فيرغو"], aEn: ["Andromeda","Milky Way","Triangulum","Virgo"], correctAr: "درب التبانة", correctEn: "Milky Way"),

        QuizQuestion(id: 36, qAr: "ما هي أطول سلسلة جبال في العالم؟", qEn: "What is the longest mountain range in the world?", aAr: ["روكي","هيمالايا","الأنديز","الألب"], aEn: ["Rocky Mountains","Himalayas","Andes","Alps"], correctAr: "الأنديز", correctEn: "Andes"),
        QuizQuestion(id: 37, qAr: "من كتب رواية 'الحرب والسلام'؟", qEn: "Who wrote the novel 'War and Peace'?", aAr: ["تولستوي","دوستويفسكي","تشيخوف","غوغول"], aEn: ["Tolstoy","Dostoyevsky","Chekhov","Gogol"], correctAr: "تولستوي", correctEn: "Tolstoy"),
        QuizQuestion(id: 38, qAr: "ما هي المادة التي تعطي النباتات لونها الأخضر؟", qEn: "What substance gives plants their green color?", aAr: ["الكاروتين","الزيتون","الكلوروفيل","الميلانين"], aEn: ["Carotene","Olive","Chlorophyll","Melanin"], correctAr: "الكلوروفيل", correctEn: "Chlorophyll"),
        QuizQuestion(id: 39, qAr: "ما هي عاصمة روسيا؟", qEn: "What is the capital of Russia?", aAr: ["سانت بطرسبرغ","كييف","موسكو","فولغوغراد"], aEn: ["Saint Petersburg","Kyiv","Moscow","Volgograd"], correctAr: "موسكو", correctEn: "Moscow"),
        QuizQuestion(id: 40, qAr: "ما هو أكبر حيوان على وجه الأرض؟", qEn: "What is the largest animal on Earth?", aAr: ["الفيل الأفريقي","الحوت الأزرق","الزرافة","الدب القطبي"], aEn: ["African Elephant","Blue Whale","Giraffe","Polar Bear"], correctAr: "الحوت الأزرق", correctEn: "Blue Whale"),
    ]
    
    @State private var currentIndex: Int = 0
    @State private var selectedAnswer: String? = nil
    
    @State private var shuffledQuestionSet: [QuizQuestion] = []
    @State private var randomQuestions: [QuizQuestion] = []
    @State private var shuffledAnswers: [String] = []
    @State private var correctAnswersCount: Int = 0
    @State private var groupNumber: Int = 1
    
    private let stackCount = 5
    private let rotations: [Double] = [0, 0, 0, 0, 0]
    private let xOffsets: [CGFloat] = [0, 0, 0, 0, 0]
    private let yOffsets: [CGFloat] = [0, 8, 16, 24, 32]
    
    private func getCurrentQuestion() -> QuizQuestion? {
        guard randomQuestions.indices.contains(currentIndex) else { return nil }
        return randomQuestions[currentIndex]
    }
    
    var body: some View {
        if shouldShowComeTomorrow {
            ComeTomorrowView(isPresented: $isPresented, remainingQuestions: remainingQuestions, isArabic: $isArabic)
        } else {
            NavigationView {
                GeometryReader { geometry in
                    ZStack {
                        Color.lightBlueBackground.ignoresSafeArea()
                        
                        VStack(spacing: 0) {
                            
                            // زر تغيير اللغة
                            HStack {
                                Spacer()
                                Button(action: {
                                    withAnimation {
                                        isArabic.toggle()
                                        selectedAnswer = nil
                                        if let currentQ = getCurrentQuestion() {
                                            shuffledAnswers = currentQ.getAnswers(isArabic: isArabic).shuffled()
                                        }
                                    }
                                }) {
                                    Text(isArabic ? "English" : "عربي")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 5)
                                        .background(Color.gray.opacity(0.7))
                                        .cornerRadius(8)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.top, 5)
                            
                            // Top Bar with NEW onTimeOut handler
                            TopNumberBar(stepResults: $stepResults, timeRemaining: $timeRemaining, isArabic: $isArabic) {
                                self.timeRemaining = 0
                                self.isShowingTimeoutView = true
                            }
                            .padding(.top, 1)
                            .zIndex(1)
                            
                            VStack(spacing: 26) {
                                // Sticky Notes UI
                                ZStack {
                                    ForEach(0..<stackCount, id: \.self) { depth in
                                        let idx = currentIndex + depth
                                        if let currentQ = getCurrentQuestion() {
                                            StickyNoteView(
                                                text: idx == currentIndex ? currentQ.getQuestion(isArabic: isArabic) : "",
                                                rotation: rotations[depth], xOffset: xOffsets[depth], yOffset: yOffsets[depth]
                                            )
                                            .zIndex(Double(stackCount - depth))
                                            .animation(.easeInOut(duration: 0.25), value: currentIndex)
                                        }
                                    }
                                }
                                .frame(width: 300, height: 380)
                                .zIndex(0)
                                
                                // Answer Buttons
                                VStack(spacing: 14) {
                                    if let currentQ = getCurrentQuestion() {
                                        ForEach(shuffledAnswers, id: \.self) { ans in
                                            Button(action: {
                                                if selectedAnswer == nil {
                                                    selectedAnswer = ans
                                                    let isCorrect = ans == currentQ.getCorrectAnswer(isArabic: isArabic)
                                                    if isCorrect { correctAnswersCount += 1 }
                                                    if currentIndex < 5 { stepResults[currentIndex] = isCorrect }
                                                    
                                                    self.timeRemaining = maxTime
                                                    
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { goNext() }
                                                }
                                            }) {
                                                Text(ans)
                                                    .font(.system(size: 16, weight: .medium)).frame(width: 300, height: 44).background(Color.lightAnswerBackground).cornerRadius(10)
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 10)
                                                            .stroke(borderColor(for: ans, currentQ: currentQ),
                                                                    lineWidth: selectedAnswer == ans || (selectedAnswer != nil && ans == currentQ.getCorrectAnswer(isArabic: isArabic)) ? 3 : 0
                                                            )
                                                    )
                                            }
                                            .disabled(selectedAnswer != nil || isShowingTimeoutView)
                                        }
                                    }
                                }
                                .zIndex(1)
                                
                                Spacer()
                            }
                        }
                        .onAppear {
                            if shuffledQuestionSet.isEmpty { setupNewQuiz() }
                            loadCurrentGroup()
                            if isTutorialActive && randomQuestions.isEmpty {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { tutorialStep = 1 }
                            }
                        }
                        .onChange(of: isArabic) { _ in
                             if let currentQ = getCurrentQuestion() {
                                 shuffledAnswers = currentQ.getAnswers(isArabic: isArabic).shuffled()
                             }
                        }
                        .onChange(of: shouldContinueQuiz) { newValue in
                            if newValue {
                                if groupNumber * 5 < shuffledQuestionSet.count {
                                    groupNumber += 1
                                }
                                
                                loadCurrentGroup()
                                shouldContinueQuiz = false
                                shouldShowComeTomorrow = false
                                isShowingTimeoutView = false
                                tutorialStep = 0
                                isTutorialActive = false
                            }
                            
                            // Logic for Forced Quit (from Success/Failure screen)
                            if !newValue && remainingQuestions == -1 {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    self.shouldShowComeTomorrow = true
                                }
                            }
                        }
                        .onChange(of: shouldRetryGroup) { newValue in
                            if newValue {
                                retryCurrentGroup()
                                isShowingTimeoutView = false
                                shouldRetryGroup = false
                            }
                            // Logic for Forced Quit from Timeout
                            if !newValue && remainingQuestions == -1 {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    self.shouldShowComeTomorrow = true
                                }
                            }
                        }
                        
                        // MARK: - Transition Overlays
                        if isShowingTopStepsView {
                            TopStepsView(isPresented: $isShowingTopStepsView,
                                         shouldDismissQuiz: .constant(false),
                                         shouldContinueQuiz: $shouldContinueQuiz,
                                         quizRemainingQuestions: $remainingQuestions,
                                         isArabic: $isArabic)
                        }
                        if isShowingFailView {
                            FailMotivationalView(isPresented: $isShowingFailView,
                                                 shouldContinueQuiz: $shouldContinueQuiz,
                                                 quizRemainingQuestions: $remainingQuestions,
                                                 isArabic: $isArabic)
                        }
                        if isShowingTimeoutView {
                            TimeoutView(isPresented: $isShowingTimeoutView,
                                        shouldRetry: $shouldRetryGroup,
                                        quizRemainingQuestions: $remainingQuestions,
                                        isArabic: $isArabic)
                        }
                        
                        // MARK: - Coach Marks
                        if tutorialStep > 0 {
                            Group {
                                if tutorialStep == 1 {
                                    CoachMarkView(text: isArabic ? "حان الوقت! انظر إلى الدائرة لترى الوقت المتبقي." : "Time is ticking! Check the blue circle for time left.", geometry: geometry, targetX: geometry.size.width - 70, targetY: geometry.safeAreaInsets.top + 70, onDismiss: { tutorialStep = 2 }, isArabic: $isArabic)
                                } else if tutorialStep == 2 {
                                    CoachMarkView(text: isArabic ? "شريط التقدم: تتبع تقدمك في هذه المجموعة من الأسئلة." : "Progress Bar: Track your progress through this set of questions.", geometry: geometry, targetX: 100, targetY: geometry.safeAreaInsets.top + 70, onDismiss: { tutorialStep = 3 }, isArabic: $isArabic)
                                } else if tutorialStep == 3 {
                                    CoachMarkView(text: isArabic ? "اختر الإجابة. الإجابات الصحيحة تقودك للمجموعة التالية." : "Select the correct answer to move to the next question.", geometry: geometry, targetX: geometry.size.width / 2, targetY: geometry.size.height - 300, onDismiss: { tutorialStep = 0 }, isArabic: $isArabic)
                                }
                            }
                            .zIndex(100)
                        }
                    }
                    .environment(\.layoutDirection, isArabic ? .rightToLeft : .leftToRight)
                }
            }
        }
    }
    
    // MARK: - Quiz Logic Methods
    private func saveAskedQuestions(newIDs: [Int]) {
        var existingIDs: [Int] = []
        if let decodedIDs = try? JSONDecoder().decode([Int].self, from: askedQuestionIDsData) {
            existingIDs = decodedIDs
        }
        
        let updatedIDs = Array(Set(existingIDs + newIDs))
        if let encodedData = try? JSONEncoder().encode(updatedIDs) {
            askedQuestionIDsData = encodedData
        }
    }
    
    private func setupNewQuiz() {
        var askedIDs: [Int] = []
        if let decodedIDs = try? JSONDecoder().decode([Int].self, from: askedQuestionIDsData) {
            askedIDs = decodedIDs
        }
        
        let unseenQuestions = allQuestions.filter { !askedIDs.contains($0.id) }
        
        if unseenQuestions.count < 5 {
            remainingQuestions = -2
            shouldShowComeTomorrow = true
            return
        }
        
        shuffledQuestionSet = unseenQuestions.shuffled()
        groupNumber = 1
    }
    
    private func loadCurrentGroup() {
        let startIndex = (groupNumber - 1) * 5
        let endIndex = min(startIndex + 5, shuffledQuestionSet.count)
        
        if startIndex >= shuffledQuestionSet.count || endIndex - startIndex < 5 {
            if shuffledQuestionSet.count < 5 {
                remainingQuestions = -2
                shouldShowComeTomorrow = true
                return
            }
            if startIndex >= shuffledQuestionSet.count {
                remainingQuestions = 0
                shouldShowComeTomorrow = true
                groupNumber = 1
                setupNewQuiz()
                return
            }
        }
        
        randomQuestions = Array(shuffledQuestionSet[startIndex..<endIndex])
        
        currentIndex = 0
        selectedAnswer = nil
        correctAnswersCount = 0
        stepResults = Array(repeating: nil, count: 5)
        remainingQuestions = 5
        
        if let currentQ = getCurrentQuestion() {
            shuffledAnswers = currentQ.getAnswers(isArabic: isArabic).shuffled()
        }
        timeRemaining = 60
    }
    
    private func retryCurrentGroup() {
        currentIndex = 0
        selectedAnswer = nil
        correctAnswersCount = 0
        stepResults = Array(repeating: nil, count: 5)
        remainingQuestions = 5
        
        if let currentQ = getCurrentQuestion() {
            shuffledAnswers = currentQ.getAnswers(isArabic: isArabic).shuffled()
        }
        timeRemaining = 60
    }
    
    private func goNext() {
        if currentIndex < randomQuestions.count - 1 {
            currentIndex += 1
            selectedAnswer = nil
            timeRemaining = 60
            if let currentQ = getCurrentQuestion() {
                shuffledAnswers = currentQ.getAnswers(isArabic: isArabic).shuffled()
            }
        } else {
            let currentGroupIDs = randomQuestions.map { $0.id }
            saveAskedQuestions(newIDs: currentGroupIDs)
            
            let isLastGroup = (groupNumber * 5) >= shuffledQuestionSet.count
            
            if correctAnswersCount >= 3 {
                if isLastGroup {
                    remainingQuestions = 0
                    shouldShowComeTomorrow = true
                    groupNumber = 1
                    setupNewQuiz()
                } else {
                    isShowingTopStepsView = true
                }
            } else {
                isShowingFailView = true
            }
            
            timeRemaining = 0
        }
    }
    
    private func borderColor(for answer: String, currentQ: QuizQuestion) -> Color {
        guard let sel = selectedAnswer else { return Color.clear }
        let correctAnswer = currentQ.getCorrectAnswer(isArabic: isArabic)
        
        if selectedAnswer != nil {
            let isCorrectAnswer = answer == correctAnswer
            let isUserSelection = sel == answer
            if isUserSelection { return isCorrectAnswer ? Color.green : Color.red }
            if isCorrectAnswer { return Color.green }
        }
        return Color.clear
    }
}

// MARK: - 7. Home View (With Reset Button)
struct ContentView: View {
    @State private var isOpened: Bool = false
    @State private var scale: CGFloat = 1.0
    @AppStorage("hasLaunchedBefore") private var hasLaunchedBefore: Bool = false
    @AppStorage("cooldownDate") private var cooldownDate: Double = 0
    @State private var showQuiz: Bool = false
    
    // هذا هو السطر الذي يحفظ بيانات الأسئلة التي تمت الإجابة عليها
    @AppStorage("askedQuestionIDs") private var askedQuestionIDsData: Data = Data()
    
    // متغير جديد لإظهار رسالة تأكيد عند الحذف
    @State private var showResetMessage = false
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            VStack(spacing: 20) {
                Spacer()
                
                Button(action: {
                    isOpened.toggle()
                    withAnimation(.easeInOut(duration: 0.3)) { scale = isOpened ? 1.5 : 1.0 }
                    hasLaunchedBefore = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        showQuiz = true
                    }
                }) {
                    Image(isOpened ? "ap22" : "ap1")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 200)
                        .scaleEffect(scale)
                }
                
                if !isOpened && !hasLaunchedBefore {
                    Image(systemName: "arrow.up")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                // --- الزر الجديد الذي تمت إضافته ---
                Button(action: {
                    // مسح بيانات الأسئلة المحفوظة
                    askedQuestionIDsData = Data()
                    // مسح تاريخ انتهاء التحدي اليومي
                    cooldownDate = 0
                    
                    // إظهار رسالة تأكيد للمستخدم
                    withAnimation {
                        showResetMessage = true
                    }
                    // إخفاء الرسالة بعد ثانيتين
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            showResetMessage = false
                        }
                    }
                }) {
                    Text("إعادة ضبط الأسئلة والبدء من جديد")
                        .font(.footnote)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.red)
                        .cornerRadius(10)
                        .shadow(radius: 3)
                }
                .padding(.bottom, 40) // لإعطائه مساحة في الأسفل
            }
            
            // رسالة التأكيد التي تظهر عند الضغط على الزر
            if showResetMessage {
                Text("✅ تم إعادة الضبط بنجاح!")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(15)
                    .transition(.opacity.combined(with: .scale))
                    .zIndex(1) // للتأكد من أنها تظهر في المقدمة
            }
        }
        .fullScreenCover(isPresented: $showQuiz) {
            QuizView(isPresented: $showQuiz)
        }
        // عند فتح التطبيق، أعد الـ scale إلى 1.0
        .onAppear {
            scale = 1.0
            isOpened = false
        }
    }
}


// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


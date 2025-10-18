//
//  NORAH.swift
//  proj
//
//  Created by NORAH on 13/04/1447 AH.
//

import SwiftUI

// ============================
// Sticky Note View
// ============================
struct StickyNoteView: View {
   
    // باقي المتغيرات...
 
    
    @State private var correctAnswers = 0
    @State private var showMabrook = false
    @State private var hasShownMabrook = false

        var text: String
        var rotation: Double
        var xOffset: CGFloat
        var yOffset: CGFloat
        
        var body: some View {
          
           

            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color(red: 1.0, green: 0.96, blue: 0.78))
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
    
    // ============================
    // Main Content View
    // ============================
struct main_page: View {
    @State private var shoContentView = false

    @State private var isShowingTopStepsView = false
        let allQuestions: [(q: String, a: [String], correct: String)] = [
            ("What is the capital of Canada?", ["Toronto","Ottawa","Vancouver","Montreal"], "Ottawa"),
            ("Which continent is the largest by area?", ["Africa","Asia","Europe","North America"], "Asia"),
            ("Which ocean is the largest?", ["Atlantic","Indian","Pacific","Arctic"], "Pacific"),
            ("What country has the most people?", ["India","China","USA","Brazil"], "China"),
            ("What is the longest river in the world?", ["Nile","Amazon","Mississippi","Yangtze"], "Nile"),
            ("What is the tallest mountain in the world?", ["Mount Kilimanjaro","Mount Elbrus","Mount Everest","K2"], "Mount Everest"),
            ("Which desert is the largest in the world?", ["Arabian","Gobi","Sahara","Thar"], "Sahara"),
            ("What is the smallest country in the world?", ["Monaco","Vatican City","San Marino","Malta"], "Vatican City"),
            ("What country is known as the 'Land of the Rising Sun'?", ["China","Japan","Korea","Thailand"], "Japan"),
            ("What is the capital of Australia?", ["Sydney","Canberra","Melbourne","Brisbane"], "Canberra"),
            ("Which country has the most islands?", ["Philippines","Indonesia","Sweden","Greece"], "Sweden"),
            ("What is the capital of Italy?", ["Milan","Venice","Rome","Florence"], "Rome"),
            ("Which two continents are located entirely in the Southern Hemisphere?", ["Africa and Australia","South America and Australia","Europe and Antarctica","Asia and South America"], "South America and Australia"),
            ("What sea separates Europe and Africa?", ["Red Sea","Arabian Sea","Mediterranean Sea","Black Sea"], "Mediterranean Sea"),
            ("What is the longest river in Africa?", ["Congo","Niger","Zambezi","Nile"], "Nile"),
            ("What is the capital of Brazil?", ["São Paulo","Rio de Janeiro","Brasília","Salvador"], "Brasília"),
            ("Which country borders the most other countries?", ["China","Brazil","Russia","Germany"], "Russia"),
            ("Where are the Andes Mountains located?", ["Asia","South America","Africa","Europe"], "South America"),
            ("What is the largest island in the world?", ["Madagascar","Greenland","Australia","Borneo"], "Greenland"),
            ("What is the capital of Egypt?", ["Cairo","Alexandria","Giza","Luxor"], "Cairo"),
            ("Which continent is the coldest?", ["Europe","Asia","Antarctica","North America"], "Antarctica"),
            ("Which U.S. state is the largest by area?", ["California","Texas","Alaska","Montana"], "Alaska"),
            ("What country is famous for the Eiffel Tower?", ["Germany","France","Italy","Spain"], "France"),
            ("Which African country has the most population?", ["South Africa","Nigeria","Kenya","Egypt"], "Nigeria"),
            ("Which continent has the most countries?", ["Europe","Asia","Africa","South America"], "Africa"),
            ("What is the name of the ocean on the east coast of the United States?", ["Indian","Atlantic","Pacific","Arctic"], "Atlantic"),
            ("Which mountain range separates Europe from Asia?", ["Alps","Rockies","Andes","Ural Mountains"], "Ural Mountains"),
            ("What is the capital of Russia?", ["St. Petersburg","Sochi","Moscow","Kazan"], "Moscow"),
            ("Which country has both the highest and lowest points on Earth?", ["China","India","Russia","Nepal"], "China"),
            ("What is the capital city of South Korea?", ["Busan","Seoul","Incheon","Daegu"], "Seoul"),
            // ==== Math ====
            ("What is the value of 7 × 8?", ["54","56","58","64"], "56"),
            ("What is 25% of 200?", ["25","50","75","100"], "50"),
            ("What is the square root of 144?", ["10","11","12","13"], "12"),
            ("Solve: 3(x + 2) = 15", ["x = 3","x = 4","x = 5","x = 2"], "x = 3"),
            ("What is the value of π (pi) approximately?", ["2.14","3.14","3.33","4.00"], "3.14"),
            ("If a triangle has angles 40° and 70°, what is the third angle?", ["60°","70°","80°","90°"], "80°"),
            ("What is 10² (10 squared)?", ["10","20","100","1000"], "100"),
            ("Solve: (5 + 3) × 2", ["11","16","13","10"], "16"),
            ("A right angle has how many degrees?", ["90","60","180","45"], "90"),
            ("What is the value of 2³ (2 cubed)?", ["6","8","4","10"], "8"),
            ("What is the perimeter of a square with side length 5 cm?", ["10 cm","15 cm","20 cm","25 cm"], "20 cm"),
            ("Which number is a prime number?", ["4","6","7","9"], "7"),
            ("What is the area of a rectangle with length 8 cm and width 3 cm?", ["24 cm²","11 cm²","22 cm²","18 cm²"], "24 cm²"),
            ("Simplify: 4/8", ["1/2","2/3","3/4","1/4"], "1/2"),
            ("What is the next number in the pattern: 2, 4, 8, 16, ...?", ["18","24","30","32"], "32"),
            ("Solve: x – 4 = 9", ["x = 5","x = 13","x = 12","x = 15"], "x = 13"),
            ("What is 0.75 as a fraction?", ["3/4","2/3","1/4","5/8"], "3/4"),
            ("Convert 150 cm to meters.", ["0.5 m","1.5 m","15 m","2.5 m"], "1.5 m"),
            ("What is the median of: 3, 7, 9, 11, 12?", ["7","9","11","12"], "9"),
            ("What is ⅓ + ⅔?", ["1","½","⅔","1¼"], "1"),
            ("What is the product of -5 and 6?", ["-30","30","-11","-1"], "-30"),
            ("If you flip a coin, what’s the probability of getting heads?", ["25%","100%","50%","75%"], "50%"),
            ("A pizza is cut into 8 equal slices. What fraction is 3 slices?", ["3/8","3/4","1/3","2/5"], "3/8"),
            ("What is 20% of 50?", ["5","10","15","20"], "10"),
            ("How many degrees are in a straight line?", ["90°","180°","360°","45°"], "180°"),
            ("What is the reciprocal of 4?", ["1/2","2","1/4","4"], "1/4"),
            ("If 3 pens cost $6, what is the cost of 1 pen?", ["$1","$2","$3","$6"], "$2"),
            ("Which shape has exactly 3 sides?", ["Square","Circle","Triangle","Hexagon"], "Triangle"),
            ("What is the sum of interior angles in a triangle?", ["90°","180°","360°","270°"], "180°"),
            ("What is ⅓ of 90?", ["20","25","30","40"], "30"),
            // ==== Riddles & Art  ====
            ("It walks without legs and cries without eyes. What is it?", ["Rain","River","Shadow","Wind"], "River"),
            ("What has teeth but doesn’t bite?", ["Knife","Comb","Saw","Gear"], "Comb"),
            ("You see it, but it doesn’t see you. What is it?", ["Mirror","Window","Glass","Shadow"], "Mirror"),
            ("It writes but cannot read.", ["Book","Pen","Computer","Typewriter"], "Pen"),
            ("The more you take from it, the bigger it gets.", ["Hole","Rock","Box","Balloon"], "Hole"),
            ("Who is the author of the 'Harry Potter' series?", ["Suzanne Collins","J.K. Rowling","Stephanie Meyer","Rick Riordan"], "J.K. Rowling"),
            ("Which painter created the 'Mona Lisa'?", ["Vincent van Gogh","Pablo Picasso","Leonardo da Vinci","Michelangelo"], "Leonardo da Vinci")    ]
        
        @State private var currentIndex: Int = 0
        @State private var selectedAnswer: String? = nil
        @State private var randomQuestions: [(q: String, a: [String], correct: String)] = []
        @State private var shuffledAnswers: [String] = []
        @State private var correctAnswersCount: Int = 0
        @State private var groupNumber: Int = 1
        @State private var showMabrook = false
        private let stackCount = 5
        private let rotations: [Double] = [0, 0, 0, 0, 0]
        private let xOffsets: [CGFloat] = [0, 0, 0, 0, 0]
        private let yOffsets: [CGFloat] = [0, 8, 16, 24, 32]
    
        var body: some View {
            
            //navigationView
            NavigationView {
                ZStack {
                    Color(red: 0.95, green: 0.96, blue: 1.0).ignoresSafeArea()
                    
                    VStack(spacing: 26) {
                        ZStack {
                            ForEach(0..<stackCount, id: \.self) { depth in
                                let idx = currentIndex + depth
                                if idx < randomQuestions.count {
                                    StickyNoteView(
                                        text: idx == currentIndex ?
                                        randomQuestions[idx].q : "",
                                        rotation: rotations[depth],
                                        xOffset: xOffsets[depth],
                                        yOffset: yOffsets[depth]
                                    )
                                    .zIndex(Double(stackCount - depth))
                                    .animation(.easeInOut(duration: 0.25), value: currentIndex)
                                }
                            }
                        }
                        .frame(width: 300, height: 380)
                        
                        VStack(spacing: 14) {
                            if randomQuestions.indices.contains(currentIndex) {
                                ForEach(shuffledAnswers, id: \.self) { ans in
                                    Button(action: {
                                        if selectedAnswer == nil {
                                            selectedAnswer = ans
                                            if ans == randomQuestions[currentIndex].correct {
                                                correctAnswersCount += 1
                                            }
                                        }
                                    }) {
                                        Text(ans)
                                            .font(.system(size: 16, weight: .medium))
                                            .frame(width: 300, height: 44)
                                            .background(Color(red: 0.80, green: 0.90, blue: 1.0))
                                            .cornerRadius(10)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(
                                                        borderColor(for: ans),
                                                        lineWidth: selectedAnswer == ans || ans == randomQuestions[currentIndex].correct ? 3 : 0
                                                    )
                                            )
                                    }
                                    .disabled(selectedAnswer != nil)
                                }
                            }
                        }
                        
                        HStack(spacing: 12) {
                            if currentIndex < randomQuestions.count - 1 || (currentIndex == randomQuestions.count - 1 && selectedAnswer != nil) {
                                Button(action: goNext) {
                                    Text("Next")
                                        .font(.system(size: 15, weight: .semibold))
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 18)
                                        .background(Color.blue.opacity(0.9))
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                    
                                    
                                   
                                }
                                
//                                if showMabrook {
//                                                TopStepsView(isPresented: $showMabrook)
//                                            }
                                
                                //
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(.top, 40)
                    
                    
                  
                    .onAppear {
                        loadNewGroup()
                    }
                    
                    
                    if showMabrook {
                        TopStepsView(isPresented: $showMabrook)
                        
                    }
                    
                    
                    if  shoContentView{
                        ContentView(isPresente:$shoContentView)
                    }
                }
            }
        }
        
        private func borderColor(for answer: String) -> Color {
            guard let sel = selectedAnswer else { return Color.clear }
            if sel == answer {
                return answer == randomQuestions[currentIndex].correct ? Color.green : Color.red
            }
            // إذا اختار المستخدم إجابة خاطئة، نوضح الإجابة الصحيحة
            if selectedAnswer != nil && answer == randomQuestions[currentIndex].correct {
                return Color.green
            }
            return Color.clear
        }
        
    private func goNext() {
        if currentIndex < randomQuestions.count - 1 {
            currentIndex += 1
            selectedAnswer = nil
            if randomQuestions.indices.contains(currentIndex) {
                shuffledAnswers = randomQuestions[currentIndex].a.shuffled()
                
                
                       
            }
        }
       
            // نهاية المجموعة
          
            // إذا أخطأ المستخدم في أي سؤال أو هذه المجموعة الثانية → لا شيء
       // }
        if correctAnswersCount == 5 && currentIndex == 4 {
            
            
            showMabrook = true
            
            //if groupNumber == 1 && correctAnswersCount == randomQuestions.count {
            // إذا كانت كل الإجابات صحيحة في المجموعة الأولى → نولد المجموعة الثانية
            groupNumber = 2
            loadNewGroup()
            //  }
            print("Show Mobarak")
            
            
            //coreect == 5 && currentIndex == 5
            //  {
            //انادي اسم السكرين هنا از بري
            // }
        }
        else{
         
            if correctAnswersCount < 5 && currentIndex == 4 {
                
                
                shoContentView = true
                
                
                print("shoContentView")
                
                
                
            
                
            }
            
        }
        
        
    
    }
        
        private func loadNewGroup() {
            randomQuestions = allQuestions.shuffled().prefix(5).map { $0 }
            currentIndex = 0
            selectedAnswer = nil
            correctAnswersCount = 0
            if randomQuestions.indices.contains(currentIndex) {
                shuffledAnswers = randomQuestions[currentIndex].a.shuffled()
            }
        }
    }
  
    // ============================
    // Preview
    // ============================
    struct main_page_Previews: PreviewProvider {
        static var previews: some View {
            // ContentView()
            main_page()
        }
    }


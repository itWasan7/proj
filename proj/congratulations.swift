//
//  congratulations.swift
//  proj
//
//  Created by wasan hamoud on 07/04/1447 AH.
//
import SwiftUI
import ConfettiSwiftUI
struct TopStepsView: View {
    @State private var counter = 0
    @State private var isActive = true
    var body: some View {
        
        ZStack {
            Color.gray.opacity(0.2)
                .ignoresSafeArea()
            VStack(spacing: 12) {
                Text("🎉")
                    .font(.system(size: 60))
                
                Text("Congratulations!")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                    .multilineTextAlignment(.center)
                Text("You’ve unlocked 5 extra questions 🎉")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                
                Button(action: {
                    // اكشن الزر
                }) {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: 100,maxHeight: 7)
                        .padding()
                        .background(Color.babyBlue)
                        .cornerRadius(5)
                }
                .padding(.horizontal, 24)
                Button(action: {
                    isActive = false
                }) {
                    Text("SKIP")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.blue)
                }
                .padding(.top, 8)
            
            }
            .padding(24)
            .background(Color.white)
            .cornerRadius(60)
            .shadow(color:Color.black.opacity(0.15),radius: 6, x: 0, y: 4)
            .padding()
        }
       
        
        
        .confettiCannon(
            trigger: $counter,
            num: 40,
            colors: [.red, .blue, .green, .yellow, .pink],
            repetitions: isActive ? 1000 : 0,
            repetitionInterval: 0.6
        )


        .onAppear {
            counter += 1
        }
    }
}

struct TopStepsView_Previews: PreviewProvider {
    static var previews: some View {
        TopStepsView()
    }
}


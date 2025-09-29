//
//  congratulations.swift
//  proj
//
//  Created by wasan hamoud on 07/04/1447 AH.
//
import SwiftUI

struct congratulations: View {
    @State private var showCongrats: Bool = true

    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                HStack(spacing: 12) {
                    ForEach((1...5).reversed(), id: \.self) { n in
                        ZStack {
                            Capsule()
                                .fill(Color(.systemGray6))
                                .frame(width: 48, height: 36)
                                .overlay(
                                    Circle()
                                        .stroke(Color.gray.opacity(0.6), lineWidth: 1)
                                )
                            Text("\(n)")
                                .font(.headline)
                                .foregroundColor(.black)
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 16)

                Spacer()

                VStack(spacing: 18) {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.green, lineWidth: 4)
                        .frame(height: 44)
                        .padding(.horizontal, 48)

                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemBlue).opacity(0.2))
                        .frame(height: 56)
                        .padding(.horizontal, 32)

                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemBlue).opacity(0.2))
                        .frame(height: 56)
                        .padding(.horizontal, 40)
                }
                .padding(.bottom, 80)

                Spacer()

                Text("SKIP")
                    .font(.headline)
                    .foregroundColor(Color.blue)
                    .padding(.bottom, 18)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                ZStack {
                    Color(.systemGroupedBackground)
                    ConfettiView(numberOfPieces: 20)
                }
                .ignoresSafeArea()
            )

            if showCongrats {
                Color.black.opacity(0.25)
                    .ignoresSafeArea()

                VStack(spacing: 18) {
                    Text("🎉")
                        .font(.system(size: 56))

                    Text("Congratulations!!")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)

                    Text("You’ve unlocked 5 extra questions 🎊")
                        .multilineTextAlignment(.center)
                        .font(.body)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 20)

                    Button(action: {
                        withAnimation {
                            showCongrats = false
                        }
                    }) {
                        Text("Continue")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 14).fill(Color.blue.opacity(0.85)))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 28)
                    .padding(.bottom, 8)
                }
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 28)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.2), radius: 12, x: 0, y: 6)
                )
                .frame(maxWidth: 340)
                .padding(.horizontal, 16)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: showCongrats)
    }
}

struct ConfettiView: View {
    let numberOfPieces: Int

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(0..<numberOfPieces, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: 3)
                        .frame(width: CGFloat.random(in: 10...22), height: CGFloat.random(in: 6...14))
                        .rotationEffect(.degrees(Double.random(in: 0...360)))
                        .opacity(0.18)
                        .offset(x: CGFloat.random(in: -geo.size.width/2...geo.size.width/2),
                                y: CGFloat.random(in: -geo.size.height/2...geo.size.height/2))
                        .foregroundColor(randomColor())
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }

    func randomColor() -> Color {
        let colors: [Color] = [.red, .blue, .green, .yellow, .purple, .orange]
        return colors.randomElement() ?? .blue
    }
}

struct congratulationsswift: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


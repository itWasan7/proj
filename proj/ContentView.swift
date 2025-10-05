//
//  ContentView.swift
//  proj
//
//  Created by wasan hamoud on 06/04/1447 AH.




import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            
            
            
            
            
            
            Color.gray.opacity(0.2)
                .ignoresSafeArea()

            VStack {
                // ===== البوكس =====
                VStack(spacing: 12) {
                    // الإيموجي
                    Text("😊")
                        .font(.system(size: 70))

                    // العنوان الأزرق
                    Text("EVERDAY MEANS\nNEW START")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.blue)
                        .multilineTextAlignment(.center)

                    // النص الرمادي
                    Text("You Never Fail, Until You\nStop Trying")
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)

                    // زر Done
                    Button(action: {
                        print("Done tapped")
                    }) {
                        Text("Done")
                            .frame(maxWidth: 100, maxHeight: 7)
                            .padding()
                            .background(Color.babyBlue)
                            .foregroundColor(.white)
                            .cornerRadius(5)
                    }
                }
                .padding()
                .frame(width: 280) // نفس عرض البوكس في الصورة
                .background(Color.white)
                .cornerRadius(60)
                .shadow(color: Color.black.opacity(0.15),
                        radius: 6, x: 0, y: 4)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


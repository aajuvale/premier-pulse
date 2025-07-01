//
//  SplashScreenView.swift
//  Premier Pulse
//
//  Created by Ahmed Juvale on 11/26/24.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive: Bool = false

    var body: some View {
        if isActive {
            ContentView() // Transition to your main ContentView after splash
        } else {
            ZStack {
                Color.blue.edgesIgnoringSafeArea(.all) // Splash screen background color
                VStack {
                    Text("Premier Pulse")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

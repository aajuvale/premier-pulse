//
//  ContentView.swift
//  Premier Pulse
//
//  Created by Ahmed Juvale on 11/18/24.
//

import SwiftUI

struct ContentView: View {
    @State private var userInput: String = "" // State variable to hold user input

    var body: some View {
        VStack(spacing: 20) {
            Text("What Release Would You Like to Follow?:")
                .font(.headline)
            
            TextField("Type a movie/show/video game title...", text: $userInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Text("You entered: \(userInput)")
                .font(.subheadline)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

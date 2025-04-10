//
//  Premier_PulseApp.swift
//  Premier Pulse
//
//  Created by Ahmed Juvale on 11/18/24.
//

import SwiftUI

@main
struct Premier_PulseApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
        }
        WindowGroup {
            ContentView()
        }
    }
}

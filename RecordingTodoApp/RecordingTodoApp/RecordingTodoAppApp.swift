//
//  RecordingTodoAppApp.swift
//  RecordingTodoApp
//
//  Created by 김동준 on 12/29/23
//

import SwiftUI

@main
struct RecordingTodoAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            OnboardingView()
        }
    }
}

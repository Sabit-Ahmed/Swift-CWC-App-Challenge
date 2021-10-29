//
//  LearningAppApp.swift
//  LearningApp
//
//  Created by Sabit Ahmed on 30/9/21.
//

import SwiftUI

@main
struct LearningApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(ContentModel())
        }
    }
}

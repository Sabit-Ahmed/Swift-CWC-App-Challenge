//
//  LaunchView.swift
//  LearningApp
//
//  Created by Sabit Ahmed on 4/11/21.
//

import SwiftUI

struct LaunchView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        
        if model.loggedIn == false {
            
            // Show login view
            LoginView()
                .onAppear {
                    // Check if a user is logged in or out
                    model.checkLogin()
                }
        }
        else {
            
            // Show the logged in view
            TabView {
                HomeView()
                    .tabItem {
                        VStack {
                            Image(systemName: "book")
                            Text("Learn")
                        }
                    }
                
                ProfileView()
                    .tabItem {
                        VStack {
                            Image(systemName: "person")
                            Text("Profile")
                        }
                    }
            }
            .onAppear {
                model.getModules()
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                
                // Save progress to the database when it goes to background
                model.saveData(writeToDatabase: true)
                
            }
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}

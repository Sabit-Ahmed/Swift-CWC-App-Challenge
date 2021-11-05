//
//  ContentView.swift
//  LearningApp
//
//  Created by Sabit Ahmed on 30/9/21.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var model: ContentModel
    
    let user = UserService.shared.user
    
    var navTitle: String {
        if user.lastLesson != nil || user.lastQuestion != nil {
            return "Welcome Back!"
        }
        else {
            return "Get Started"
        }
    }
    
    var body: some View {
        
        NavigationView {
            VStack (alignment: .leading) {
                
                if (user.lastLesson != nil && user.lastLesson! > 0) || (user.lastQuestion != nil && user.lastQuestion! > 0) {
                    
                    // Show the resume view
                    ResumeView()
                        .padding(.horizontal)
                }
                else {
                    Text("What do you want to learn today?")
                        .padding(.leading, 20)
                }
                
                ScrollView {
                    LazyVStack {
                        ForEach(model.modules) { module in
                            
                            VStack (spacing: 20) {
                                // MARK: Learning Card
                                
                                NavigationLink (
                                    destination: ContentView()
                                        .onAppear(perform: {
                                            model.getLessons(module: module) {
                                                model.beginModule(module.id)
                                            }
                                            
                                        }),
                                    tag: module.id.hash,
                                    selection: $model.currentContentSelected,
                                    label: {
                                        HomeViewRow(image: module.content.image, title: "Learn \(module.category)", description: module.content.description, count: "\(module.content.lessons.count) Lessons", time: module.content.time)
                                    })
                                
                                // MARK: Test Card
                                
                                NavigationLink(
                                    destination: TestView()
                                        .onAppear(perform: {
                                            model.getQuestions(module: module) {
                                                model.beginTest(module.id)
                                            }
                                            
                                        }),
                                    tag: module.id.hash,
                                    selection: $model.currentTestSelected,
                                    label: {
                                        // Test card
                                        HomeViewRow(image: module.test.image, title: "\(module.category) Test", description: module.test.description, count: "\(module.test.questions.count) Lessons", time: module.test.time)
                                    })
                                
                                NavigationLink(
                                    destination: EmptyView(),
                                    label: {
                                        EmptyView()
                                    })
                                
                            }
                            
                        }
                    }
                    .accentColor(.black)
                    .padding()
                }
            }
            .navigationTitle(navTitle)
            .onChange(of: model.currentContentSelected, perform: { changedValue in
                if changedValue == nil {
                    model.currentModule = nil
                }
            })
            .onChange(of: model.currentTestSelected, perform: { changedValue in
                if changedValue == nil {
                    model.currentModule = nil
                }
            })
        }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(ContentModel())
    }
}

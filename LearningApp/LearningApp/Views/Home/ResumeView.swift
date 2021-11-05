//
//  ResumeView.swift
//  LearningApp
//
//  Created by Sabit Ahmed on 5/11/21.
//

import SwiftUI

struct ResumeView: View {
    
    @EnvironmentObject var model: ContentModel
    @State var resumeSelected: Int?
    let user = UserService.shared.user
    
    var destination: some View {
        
        let module = model.modules[user.lastModule ?? 0]
        
        return Group  {
            
            // Determine if we need to go into a ContentDetailView or a TestView
            if user.lastLesson! > 0 {
                
                // Go to ContentDetailView
                ContentDetailView()
                    .onAppear {
                        
                        // Fetch lessons
                        model.getLessons(module: module) {
                            model.beginModule(module.id)
                            model.beginLesson(user.lastLesson!)
                        }
                    }
            }
            else {
                
                // Go to TestView
                TestView()
                    .onAppear(perform: {
                        model.getQuestions(module: module) {
                            model.beginTest(module.id)
                            model.currentQuestionIndex = user.lastQuestion!
                        }
                        
                    })
            }
            
        }
    }
    
    var resumeTitle: String {
        
        let module = model.modules[user.lastModule ?? 0]
        
        if user.lastLesson != 0 {
            // Resume a lesson
            return "Learn \(module.category): Lesson \(user.lastLesson! + 1)"
        }
        else {
            // Resume a test
            return "\(module.category) Test: Question \(user.lastQuestion! + 1)"
        }
    }
    
    var body: some View {
        
        let module = model.modules[user.lastModule ?? 0]
        
        NavigationLink (destination: destination, tag: module.id.hash, selection: $resumeSelected) {
            
            ZStack {
                RectangleCard()
                    .frame(height: 66)
                
                HStack {
                    VStack {
                        Text("Continure where you left off:")
                        Text(resumeTitle)
                            .bold()
                    }
                    .foregroundColor(.black)
                    Spacer()
                    Image(systemName: "play.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                }
                .padding()
                   
            }
        }

        
        
    }
}

struct ResumeView_Previews: PreviewProvider {
    static var previews: some View {
        ResumeView()
    }
}

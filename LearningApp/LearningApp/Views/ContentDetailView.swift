//
//  ContentDetailView.swift
//  LearningApp
//
//  Created by Sabit Ahmed on 1/10/21.
//

import SwiftUI
import AVKit

struct ContentDetailView: View {
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        let lesson = model.currentLesson
        let url = URL(string: Constants.videoHostUrl + (lesson?.video ?? ""))
        
        VStack {
            // Only the videos with valid urls
            if url != nil{
                VideoPlayer(player: AVPlayer(url: url!))
                    .cornerRadius(10)
            }
            
            // Description
            CodeTextView()
            // Show next lesson button if there is next lesson
            if model.hasNextLesson() {
                Button(action: {
                    // Advance to the next lesson
                    model.nextLesson()
                }, label: {
                    
                    ZStack {
                        RectangleCard(color: Color.green)
                        
                        Text("Next Lesson: \(model.currentModule!.content.lessons[model.currentLessonIndex + 1].title)")
                            .foregroundColor(Color.white)
                            .bold()
                            
                    }

                })
            }
            else {
                Button(action: {
                    // Advance to the home View after completion
                    model.currentContentSelected = nil
                }, label: {
                    
                    ZStack {
                        RectangleCard(color: Color.green)
                        
                        Text("Complete")
                            .foregroundColor(Color.white)
                            .bold()
                            
                    }

                })
            }
        }
        .padding()
        .navigationTitle(lesson?.title ?? "")
        
        
    }
}

struct ContentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ContentDetailView()
    }
}

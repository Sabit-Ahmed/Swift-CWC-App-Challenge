//
//  TestResultView.swift
//  LearningApp
//
//  Created by Sabit Ahmed on 7/10/21.
//

import SwiftUI

struct TestResultView: View {
    @EnvironmentObject var model: ContentModel
    var numCorrect: Int?
    
    // Dynamic result string
    var resultString: String {
        
        guard model.currentModule != nil else {
            return ""
        }
        let percentage = Double(numCorrect!)/Double(model.currentModule!.test.questions.count)
        if percentage > 0.5 {
            return "Awesome!"
        }
        else if percentage > 0.2 {
            return "Doing great!"
        }
        else {
            return "Keep learning."
        }
    }
    
    var body: some View {
        VStack {
            Spacer()
            Text(resultString)
            
            Spacer()
            Text("You got \(numCorrect!) out of \(model.currentModule?.test.questions.count ?? 0) questions")
            
            Spacer()
            Button(action: {
                // Set the next test as the current test upon completion
                model.currentTestSelected = nil
            }, label: {
                ZStack {
                    RectangleCard(color: Color.green)
                    
                    Text("Complete")
                        .bold()
                        .foregroundColor(.white)
                }
                .padding()
            })
            Spacer()
        }
    }
}


//
//  TestView.swift
//  LearningApp
//
//  Created by Sabit Ahmed on 6/10/21.
//

import SwiftUI

struct TestView: View {
    @EnvironmentObject var model: ContentModel
    @State var selectedAnswerIndex: Int?
    @State var numCorrect = 0
    @State var submitted = false
    @State var showResults = false
    
    // Dynamic button string
    var buttonString: String {
        if submitted == true {
            if model.currentQuestionIndex + 1 == model.currentModule?.test.questions.count {
                return "Finish"
            }
            else {
                return "Next"
            }
            
        }
        else {
            return "Submit"
        }
    }
    
    var body: some View {
        if model.currentQuestion != nil && showResults == false {
            VStack(alignment: .leading) {
                // Question number
                Text("Qustion \(model.currentQuestionIndex + 1) of \(model.currentModule?.test.questions.count ?? 0)")
                    .padding(.leading, 20)
                
                // Question
                CodeTextView()
                    .padding(.horizontal, 20)
                
                // Answer
                ScrollView {
                    VStack {
                        ForEach(0..<model.currentQuestion!.answers.count, id: \.self) {index in

                            Button(action: {
                                // Change the answer button color into grey if selected
                                selectedAnswerIndex = index
                                
                            }, label: {
                                ZStack {
                                    if submitted == false {
                                        RectangleCard(color: index == selectedAnswerIndex ? Color.gray : Color.white)
                                    }
                                    else {
                                        // If user selects right answer
                                        if index == selectedAnswerIndex && index == model.currentQuestion?.correctIndex {
                                            RectangleCard(color: Color.green)
                                        }
                                        // If user selects wrong answer
                                        else if index == selectedAnswerIndex && index != model.currentQuestion?.correctIndex {
                                            RectangleCard(color: Color.red)
                                        }
                                        // Actual right answer hwich will always be green background
                                        else if index == model.currentQuestion?.correctIndex {
                                            RectangleCard(color: Color.green)
                                        }
                                        // Rest of the options will be white color
                                        else {
                                            RectangleCard(color: Color.white)
                                        }
                                    }
             
                                    Text(model.currentQuestion!.answers[index])
                                }
                        })
                            
                        }
                    }
                    .accentColor(.black)
                    .padding()
                    .disabled(submitted)
                }
                
                // Button
                Button(action: {
                    
                    if submitted == true {
                        
                        if model.currentQuestionIndex + 1 == model.currentModule?.test.questions.count {
                            
                            // Check next question and save progress
                            model.nextQuestion()
                            
                            showResults = true
                        }
                        else {
                            // If the answer is already submitted, go to the next question
                            // Also save progress
                            model.nextQuestion()
                            
                            // Reset Properties
                            submitted = false
                            selectedAnswerIndex = nil
                        }
           
                    }
                    else {
                        // Set submitted to true if button is clicked
                        submitted = true
                        
                        if selectedAnswerIndex == model.currentQuestion?.correctIndex {
                            // Increase the number for the correct answer
                            numCorrect += 1
                            
                        }
                        
                        
                        
                    }
                    
                }, label: {
                    ZStack {
                        RectangleCard(color: Color.green)
                        
                        Text(buttonString)
                            .bold()
                            .foregroundColor(.white)
                    }
                    .padding()
                })
                .disabled(selectedAnswerIndex == nil)
            }
            .navigationBarTitle("\(model.currentModule?.category ?? "") Test")
        }
        else if showResults == true {
            // If current question is nil, we show the result view
            TestResultView(numCorrect: numCorrect)
        }
        else {
            ProgressView()
        }
        
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}

//
//  ContentModel.swift
//  LearningApp
//
//  Created by Sabit Ahmed on 30/9/21.
//

import Foundation
import Firebase
import FirebaseAuth

class ContentModel: ObservableObject {
    
    let db = Firestore.firestore()
    
    // Authentication
    @Published var loggedIn = false
    
    // List of modules
    @Published var modules = [Module]()
    
    // Set the current module
    @Published var currentModule: Module?
    var currentModuleIndex = 0
    
    // Set the current lesson
    @Published var currentLesson: Lesson?
    var currentLessonIndex = 0
    
    // Set the lesson explanation
    @Published var codeText = NSAttributedString()
    
    // Set the current selected index for contents
    @Published var currentContentSelected: Int?
    
    // Set the current question
    @Published var currentQuestion: Question?
    var currentQuestionIndex = 0
    
    // Set the current selected index for tests
    @Published var currentTestSelected: Int?
    
    // Set the type of style data
    var styleData: Data?
    
    init() {
         
        
    }
    
    // MARK: - Authentication methods
    
    func checkLogin() {
        
        // Check if there's a current user to determine logged in or not
        loggedIn = Auth.auth().currentUser != nil ? true : false
        
        if UserService.shared.user.name == "" {
            getUserData()
        }
        
    }
    
    
    // MARK: - Data methods
    
    func getLocalStyles() {
        // Parse the style data
        let styleUrl = Bundle.main.url(forResource: "style", withExtension: "html")
        do {
            // Read the style file into data object
            let styleData = try Data(contentsOf: styleUrl!)
            self.styleData = styleData
        }
        catch {
            print("Couldn't parse the style data")
        }
    }
    
    func getModules() {
        
        // Parse local style.html
        getLocalStyles()
        
        // Specify path
        let collection = db.collection("modules")
        
        // Get documents
        collection.getDocuments { snapshot, error in
            if error == nil && snapshot != nil {
                
                // Create an array of modules
                var modules = [Module]()
                
                for doc in snapshot!.documents {
                    
                    // Create an instance of module
                    var m = Module()
                    
                    // Parse the values fro the documents into module instance
                    m.id = doc["id"] as? String ?? UUID().uuidString
                    m.category = doc["category"] as? String ?? ""
                    
                    // Parse the lesson content
                    let contenMap = doc["content"] as! [String: Any]
                    
                    m.content.id = contenMap["id"] as? String ?? ""
                    m.content.description = contenMap["description"] as? String ?? ""
                    m.content.image = contenMap["image"] as? String ?? ""
                    m.content.time = contenMap["time"] as? String ?? ""
                    
                    // Parse the test content
                    
                    let testMap = doc["test"] as! [String: Any]
                    
                    m.test.id = testMap["id"] as? String ?? ""
                    m.test.description = testMap["description"] as? String ?? ""
                    m.test.image = testMap["image"] as? String ?? ""
                    m.test.time = testMap["time"] as? String ?? ""
                    
                    // Add it to our array
                    modules.append(m)
                }
                
                // Assign our modules to the published property
                DispatchQueue.main.async {
                    self.modules = modules
                }
            }
        }
    }
    
    func getLessons(module: Module, completion: @escaping () -> Void) {
        // Specify path
        let collection = db.collection("modules").document(module.id).collection("lessons")
        
        // Get documents
        collection.getDocuments { snapshot, error in
            
            if error == nil && snapshot != nil {
                
                // Array to track the lessons
                var lessons = [Lesson]()
                
                // Loop through the documents and build array of lessons
                for doc in snapshot!.documents {
                    // New lesson
                    var l = Lesson()
                    
                    l.id = doc["id"] as? String ?? UUID().uuidString
                    l.title = doc["title"] as? String ?? ""
                    l.video = doc["video"] as? String ?? ""
                    l.duration = doc["duration"] as? String ?? ""
                    l.explanation = doc["explanation"] as? String ?? ""
                    
                    // Add the lessons in the array
                    lessons.append(l)
                }
                
                // Set the lessons in module
                for (index, m) in self.modules.enumerated() {
                    
                    // Find the module we want
                    if m.id == module.id {
                        
                        // Set the lessons
                        self.modules[index].content.lessons = lessons
                        
                        // Call the completion closure
                        completion()
                    }
                }
            }
        }
    }
    
    func getQuestions(module: Module, completion: @escaping () -> Void) {
        // Specify path
        let collection = db.collection("modules").document(module.id).collection("questions")
        
        // Get documents
        collection.getDocuments { snapshot, error in
            
            if error == nil && snapshot != nil {
                
                // Array to track the lessons
                var questions = [Question]()
                
                // Loop through the documents and build array of lessons
                for doc in snapshot!.documents {
                    // New lesson
                    var q = Question()
                    
                    q.id = doc["id"] as? String ?? UUID().uuidString
                    q.content = doc["content"] as? String ?? ""
                    q.answers = doc["answers"] as? [String] ?? ["true"]
                    q.correctIndex = doc["correctIndex"] as? Int ?? 0
                    
                    // Add the lessons in the array
                    questions.append(q)
                }
                
                // Set the lessons in module
                for (index, m) in self.modules.enumerated() {
                    
                    // Find the module we want
                    if m.id == module.id {
                        
                        // Set the lessons
                        self.modules[index].test.questions = questions
                        
                        // Call the completion closure
                        completion()
                    }
                }
            }
        }
    }
    
    func getUserData() {
        
        // Check if there is a logged in user
        guard Auth.auth().currentUser != nil else {
            return
        }
        
        // Get the meta data for that user
        let db = Firestore.firestore()
        let ref = db.collection("users").document(Auth.auth().currentUser!.uid)
        ref.getDocument { snapshot, error in
            
            // Check if any error
            guard error == nil, snapshot != nil else {
                return
            }
            
            // Parse the data out ans set the user meta data
            let data = snapshot!.data()
            let user = UserService.shared.user
            user.name = data!["name"] as? String ?? ""
            user.lastLesson = data!["lastLesson"] as? Int
            user.lastModule = data!["lastModule"] as? Int
            user.lastQuestion = data!["lastQuestion"] as? Int
        }
    }
    
    func saveData(writeToDatabase: Bool = false) {
        
        if let loggedInUser = Auth.auth().currentUser {
            
            // Save the progress data locally
            let user = UserService.shared.user
            user.lastModule = currentModuleIndex
            user.lastLesson = currentLessonIndex
            user.lastQuestion = currentQuestionIndex
            
            if writeToDatabase {
                // Save it to the database
                let db = Firestore.firestore()
                let ref = db.collection("users").document(loggedInUser.uid)
                ref.setData(["lastModule": user.lastModule ?? NSNull(),
                             "lastLesson": user.lastLesson ?? NSNull(),
                             "lastQuestion": user.lastQuestion ?? NSNull()], merge: true)
            }
            
            
        }
        
    }
    
    
    // MARK: - Module navigation methods
    
    func beginModule(_ moduleId:String) {
        // Find the index for the module id
        for index in 0..<modules.count {
            if moduleId == modules[index].id {
                currentModuleIndex = index
                break
            }
        }
        
        // Set the current module
        currentModule = modules[currentModuleIndex]
    }
    
    func beginLesson(_ lessonIndex: Int) {
        // Reset the question index as user is starting lesson
        currentQuestionIndex = 0
        
     
        // Check if the lesson index is in range
        if lessonIndex < currentModule!.content.lessons.count {
            currentLessonIndex = lessonIndex
        }
        
        // Set the current lesson
        currentLesson = currentModule?.content.lessons[currentLessonIndex]
        codeText = addStyling(currentLesson!.explanation)
    }
    
    func hasNextLesson() -> Bool {
        
        guard currentModule != nil else {
            return false
        }
        
        return currentLessonIndex + 1 < currentModule!.content.lessons.count
    }
    
    func nextLesson() {
        currentLessonIndex += 1
        
        if currentModuleIndex < currentModule!.content.lessons.count {
            currentLesson = currentModule?.content.lessons[currentLessonIndex]
            codeText = addStyling(currentLesson!.explanation)
        }
        else {
            currentLessonIndex = 0
            currentLesson = nil
        }
        
        // Save the progress
        saveData()
    }
    
    func beginTest(_ moduleId:String) {
        
        // Set the current module
        beginModule(moduleId)
        
        currentQuestionIndex = 0
        
        // Reset the lesson index as user is starting test
        currentLessonIndex = 0
        
        // Set the current question
        if currentModule?.test.questions.count ?? 0 > 0 {
            currentQuestion = currentModule?.test.questions[currentQuestionIndex]
            codeText = addStyling(currentQuestion!.content)
        }
    }
    
    func nextQuestion() {
        currentQuestionIndex += 1
        
        if currentQuestionIndex < currentModule!.test.questions.count {
            currentQuestion = currentModule?.test.questions[currentQuestionIndex]
            codeText = addStyling(currentQuestion!.content)
        }
        else {
            currentQuestionIndex = 0
            currentQuestion = nil
        }
        
        // Save the progress
        saveData()
    }
    
    // MARK: - Code styling helper
    private func addStyling(_ htmlString:String) -> NSAttributedString {
        var resultString = NSAttributedString()
        var data = Data()
        
        // Add styling data
        if styleData != nil {
            data.append(styleData!)
        }
        
        // Add html data
        data.append(Data(htmlString.utf8))
        
        // Convert to the attributed string
        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            resultString = attributedString
        }
        
        return resultString
    }
    
}

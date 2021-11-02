//
//  ContentModel.swift
//  LearningApp
//
//  Created by Sabit Ahmed on 30/9/21.
//

import Foundation
import Firebase

class ContentModel: ObservableObject {
    let db = Firestore.firestore()
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
        // Get the local data
//        getLocalData()
        
        // Get the remote data
//        getRemoteData()
        
        // Parse local style.html
        getLocalStyles()
        
        // Get documents from firebase
        getDatabaseModules()
        
    }
    
    // MARK: - Data methods
    
    func getLocalData() {
        // Get a url to the json file
        let jsonUrl = Bundle.main.url(forResource: "data", withExtension: "json")
        
        do {
            // Read the file into data object
            let jsonData = try Data(contentsOf: jsonUrl!)
            
            // Try to decode the json object into an array of modules
            let jsonDecoder = JSONDecoder()
            let modules = try jsonDecoder.decode([Module].self, from: jsonData)
            
            // Assign parsed modules to modules property
            self.modules = modules
        }
        catch {
            // TODO log error
            print("Couldn't parse the loacl data")
        }
        
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
    
    func getRemoteData() {
        
        let urlString = "https://sabit-ahmed.github.io/learningapp-data/data2.json"
        
        // Create url object
        let url = URL(string: urlString)
        
        guard url != nil else {
            // Handle if the url can't be created
            return
        }
        
        // Create url request object
        let request = URLRequest(url: url!)
        
        // Get the session and kick-off task
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request) { data, response, error in
            
            // Check if there is any error
            guard error == nil else {
                // There is error
                return
            }
            
            // Operate on the fetched data
            do {
                // Create a json decoder object
                let jsonDecoder = JSONDecoder()
                
                // Decode json
                let modules = try jsonDecoder.decode([Module].self, from: data!)
                
                // Update view code in the main thread using async
                DispatchQueue.main.async {
                    // Append the p[arsed data into modules array
                    self.modules += modules
                }
                
            }
            catch {
                // Couldn't parse the json data
                print("Couldn't parse the remote data")
            }
            
        }
        
        // Kick off the task
        dataTask.resume()
    }
    
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
    
    func getDatabaseModules() {
        
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
    }
    
    func beginTest(_ moduleId:String) {
        
        // Set the current module
        beginModule(moduleId)
        
        currentQuestionIndex = 0
        
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

//
//  DataService.swift
//  RecipeListApp
//
//  Created by Sabit Ahmed on 9/9/21.
//

import Foundation

class DataService {
    
    static func getLocalData () -> [Recipe] {
        
        // Parse local json file
        
        // Get a url path to the json file
        let pathString = Bundle.main.path(forResource: "recipes", ofType: "json")
        
        // Check if the pathString is a nil object. Otherwise,
        guard pathString != nil else {
            return [Recipe]()
        }
        
        // Create a url object
        let url = URL(fileURLWithPath: pathString!)
        
        do {
            // Create data object
            let data = try Data(contentsOf: url)
            
            // Decode the data with a JSON decoder
            let decoder = JSONDecoder()
            
            do {
                let recipeData = try decoder.decode([Recipe].self, from: data)
                
                // Add the unique ids
                for r in recipeData{
                    r.id = UUID()
                }
                
                // Retrun the recipes
                return recipeData
            }
            catch {
                print(error)
            }
            
        }
        catch {
            print(error)
        }
        
        return [Recipe]()
    }
}

//
//  DataServices.swift
//  lesson7Challenge
//
//  Created by Sabit Ahmed on 10/9/21.
//

import Foundation

class DataServices {
    static func getLocalData () -> [FamousQuotes] {
        let pathString = Bundle.main.path(forResource: "Data", ofType: "json")
        
        guard pathString != nil else {
            return [FamousQuotes]()
        }
        
        let url = URL(fileURLWithPath: pathString!)
        
        do {
            let data = try Data(contentsOf: url)
            
            let decoder = JSONDecoder()
            
            do {
                let quoteData = try decoder.decode([FamousQuotes].self, from: data)
                
                for p in quoteData{
                    p.id = UUID()
                }
                
                return quoteData
            }
            catch {
                print(error)
            }
        }
        catch {
            print(error)
        }
        
        
        return [FamousQuotes]()
    }
}

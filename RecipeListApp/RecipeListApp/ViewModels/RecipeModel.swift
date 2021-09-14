//
//  RecipeModel.swift
//  RecipeListApp
//
//  Created by Sabit Ahmed on 9/9/21.
//

import Foundation

class RecipeModel: ObservableObject {
    
    @Published var recipe = [Recipe]()
    
    init() {
        recipe.self = DataService.getLocalData()
    }
}

//
//  RecipeDetailView.swift
//  RecipeListApp
//
//  Created by Sabit Ahmed on 10/9/21.
//

import SwiftUI

struct RecipeDetailView: View {
    var recipe:Recipe
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading){
                // MARK: Recipe Image
                Image(recipe.image)
                    .resizable()
                    .scaledToFill()
                
                VStack(alignment: .leading){
                    // MARK: Recipe Title
                    Text("Ingredients")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding(.vertical, 5.0)
                    
                    // MARK: Ingredients
                    ForEach(recipe.ingredients, id: \.self) { r in
                        Text("* " + r)
                            
                    }
                    .padding(.bottom, -2.0)
                }
                .padding(.horizontal)
                
                // MARK: Divider
                Divider()
                
                VStack(alignment: .leading){
                    // MARK: Directions
                    Text("Directions")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding(.vertical, 5.0)
                    
                    ForEach(0..<recipe.directions.count, id:\.self){ r in
                        Text(String(r+1) + ": " + recipe.directions[r])
                            .padding(.bottom, 5)
                    }
                
                }
                .padding(.horizontal)
                
            }
            
        }
        .navigationTitle(recipe.name)
    }
}

struct RecipeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        
        let model = RecipeModel()
        
        RecipeDetailView(recipe: model.recipe[0])
    }
}

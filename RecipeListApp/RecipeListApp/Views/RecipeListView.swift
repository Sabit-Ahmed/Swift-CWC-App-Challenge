//
//  ContentView.swift
//  RecipeListApp
//
//  Created by Sabit Ahmed on 9/9/21.
//

import SwiftUI

struct RecipeListView: View {
    
    @ObservedObject var model = RecipeModel()
    
    var body: some View {
        
        NavigationView {
            
            
            List(model.recipe){ r in
                NavigationLink(
                    destination: RecipeDetailView(recipe: r),
                    label: {
                        HStack(spacing: 10.0){
                        Image(r.image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .clipped()
                            .cornerRadius(5)
                        Text(r.name)
                    }
                    })
                    
            }
            .navigationTitle("All Recipes")
        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeListView()
    }
}

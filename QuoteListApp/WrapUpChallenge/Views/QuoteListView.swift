//
//  QuoteListView.swift
//  WrapUpChallenge
//
//  Created by Sabit Ahmed on 10/9/21.
// Single list view

import SwiftUI

struct QuoteListView: View {
    
    var singleQuote:FamousQuotes
    
    var body: some View {
        ZStack {
            Image(singleQuote.image)
                .resizable()
                .frame(width: 360, height: 400)
                .cornerRadius(10)
            
                
            
            VStack(alignment: .leading){
                Text(singleQuote.quotes[0])
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                    .padding(.bottom, 1.0)
                    
                
                Text("- "+singleQuote.name)
                    .font(/*@START_MENU_TOKEN@*/.body/*@END_MENU_TOKEN@*/)
                    .foregroundColor(Color.white)
            }
            .frame(width: 300.0)
            
        }
        
        
        
    }
}

struct QuoteListView_Previews: PreviewProvider {
    static var previews: some View {
        
        let model = QuoteModel()
        QuoteListView(singleQuote: model.quoteModel[0])
    }
}

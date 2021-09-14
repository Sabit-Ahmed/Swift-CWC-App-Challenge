//
//  QuoteDetailView.swift
//  WrapUpChallenge
//
//  Created by Sabit Ahmed on 10/9/21.
//

import SwiftUI

struct QuoteDetailView: View {
    var singleQuote:FamousQuotes
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(singleQuote.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom)
                
                ForEach(singleQuote.quotes, id:\.self){q in
                    Text(q)
                        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                }
            }
            .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        }
        
    }
}

struct QuoteDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let model = QuoteModel()
        QuoteDetailView(singleQuote: model.quoteModel[0])
    }
}

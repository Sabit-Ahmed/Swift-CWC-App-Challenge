//
//  ContentView.swift
//  WrapUpChallenge
//
//  Created by Sabit Ahmed on 10/9/21.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var quote = QuoteModel()
    
    var body: some View {
        
        NavigationView {
            ScrollView {
                ForEach(quote.quoteModel) {q in
                    NavigationLink(
                        destination: QuoteDetailView(singleQuote: q),
                        label: {
                            QuoteListView(singleQuote: q)
                        })
                }
                
            }
            .navigationTitle("Quotes")
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

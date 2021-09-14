//
//  QuoteModel.swift
//  WrapUpChallenge
//
//  Created by Sabit Ahmed on 10/9/21.
//

import Foundation

class QuoteModel: ObservableObject {
    @Published var quoteModel = [FamousQuotes]()
    
    init() {
        quoteModel.self = DataServices.getLocalData()
    }
}

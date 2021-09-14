//
//  FamousQuotes.swift
//  WrapUpChallenge
//
//  Created by Sabit Ahmed on 10/9/21.
//

import Foundation

class FamousQuotes: Identifiable, Decodable {
    var id:UUID?
    var name: String
    var quotes:[String]
    var image:String
}

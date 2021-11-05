//
//  UserService.swift
//  LearningApp
//
//  Created by Sabit Ahmed on 5/11/21.
//

import Foundation

class UserService {
    
    var user = User()
    
    static var shared = UserService()
    
    private init() {
        
    }
    
}

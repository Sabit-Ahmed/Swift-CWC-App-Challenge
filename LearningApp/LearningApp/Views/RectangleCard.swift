//
//  RectangleCard.swift
//  LearningApp
//
//  Created by Sabit Ahmed on 5/10/21.
//

import SwiftUI

struct RectangleCard: View {
    var color = Color.white
    
    var body: some View {
        Rectangle()
            .foregroundColor(color)
            .cornerRadius(10)
            .shadow(radius: 5)
            .frame(height: 48)
    }
}

struct RectangleCard_Previews: PreviewProvider {
    static var previews: some View {
        RectangleCard()
    }
}

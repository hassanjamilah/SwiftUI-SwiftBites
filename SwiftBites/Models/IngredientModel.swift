//
//  IngredientModel.swift
//  SwiftBites
//
//  Created by Hassan Jamila on 5/1/25.
//

import Foundation
import SwiftData

@Model
final class IngredientModel: Identifiable, Hashable {
    let id: UUID
    var name: String
    
    init(name: String) {
        self.id = UUID()
        self.name = name
    }
    
   
}

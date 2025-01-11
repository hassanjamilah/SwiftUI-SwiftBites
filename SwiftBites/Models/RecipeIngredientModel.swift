//
//  RecipeIngredientModel.swift
//  SwiftBites
//
//  Created by Hassan Jamila on 5/1/25.
//

import Foundation
import SwiftData

@Model
final class RecipeIngredientModel: Identifiable, Hashable {
    let id: UUID
    var ingredient: IngredientModel
    var quantity: String
    
    init(ingredient: IngredientModel, quantity: String) {
        self.id = UUID()
        self.ingredient = ingredient
        self.quantity = quantity
    }
    
    
}

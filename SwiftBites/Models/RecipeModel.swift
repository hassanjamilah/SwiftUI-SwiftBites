//
//  RecipeModel.swift
//  SwiftBites
//
//  Created by Hassan Jamila on 5/1/25.
//

import Foundation
import SwiftData

@Model
final class RecipeModel: Identifiable, Hashable {
    let id: UUID
    @Attribute(.unique)
    var name: String
    var summary: String
    
    @Relationship(deleteRule: .nullify, inverse: \CategoryModel.recipes)
    var category: CategoryModel?
    
    var serving: Int
    var time: Int
    
    @Relationship(deleteRule: .cascade)
    var ingredients: [RecipeIngredientModel]
    
    var instructions: String
    var imageData: Data? = nil
    
    init(name: String, summary: String, category: CategoryModel, serving: Int, time: Int, ingredients: [RecipeIngredientModel], instructions: String, imageData: Data? = nil) {
        self.id = UUID()
        self.name = name
        self.summary = summary
        self.category = category
        self.serving = serving
        self.time = time
        self.ingredients = ingredients
        self.instructions = instructions
        self.imageData = imageData
    }
    
}

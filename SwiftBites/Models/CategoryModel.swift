//
//  Category.swift
//  SwiftBites
//
//  Created by Hassan Jamila on 5/1/25.
//

import Foundation
import SwiftData

@Model
final class CategoryModel: Identifiable, Hashable {
    let id: UUID
    var name: String
    @Relationship
    var recipes: [RecipeModel]
    
    init(name: String, recipes: [RecipeModel] = []) {
        self.id = UUID()
        self.name = name
        self.recipes = recipes
    }
    
    
}

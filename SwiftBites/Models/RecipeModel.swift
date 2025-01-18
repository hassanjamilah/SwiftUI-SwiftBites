import Foundation
import SwiftData

@Model
final class RecipeModel {
    
    var id: UUID
    @Attribute(.unique)
    var name: String
    var summary: String
    
    @Relationship(deleteRule: .nullify, inverse: \CategoryModel.recipes)
    var category: CategoryModel?
    
    var serving: Int
    var time: Int
    
    var instructions: String
    var imageData: Data? = nil
    
    @Relationship(deleteRule: .cascade)
    var recipeIngredientModels: [RecipeIngredientModel]?
    
    init(id: UUID = UUID(), name: String, summary: String, category: CategoryModel? = nil, serving: Int, time: Int, instructions: String, imageData: Data? = nil, recipeIngredientModels: [RecipeIngredientModel]? = nil) {
        self.id = id
        self.name = name
        self.summary = summary
        self.category = category
        self.serving = serving
        self.time = time
        self.instructions = instructions
        self.imageData = imageData
        self.recipeIngredientModels = recipeIngredientModels
    }
}

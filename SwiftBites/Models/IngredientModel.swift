import Foundation
import SwiftData

@Model
final class IngredientModel {
    var id: UUID
    
    @Attribute(.unique)
    var name: String
    
    @Relationship(deleteRule: .cascade, inverse: \RecipeIngredientModel.ingredient)
    var recipeIngredientModels: [RecipeIngredientModel]?
    
    init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
    }
}

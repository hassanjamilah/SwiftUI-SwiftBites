import Foundation
import SwiftData

@Model
final class RecipeIngredientModel {
    var id: UUID
    var ingredient: IngredientModel    
    var recipe: RecipeModel?
    var quantity: String
    
    init(id: UUID = UUID(), ingredient: IngredientModel, recipe: RecipeModel? = nil, quantity: String) {
        self.id = id
        self.ingredient = ingredient
        self.recipe = recipe
        self.quantity = quantity
    }
}

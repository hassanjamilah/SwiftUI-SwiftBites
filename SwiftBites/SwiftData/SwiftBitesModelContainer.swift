//
//  SwiftBitesModelContainer.swift
//  SwiftBites
//
//  Created by Hassan Jamila on 5/1/25.
//

import Foundation
import SwiftData

class SwiftBitesModelContainer {
    @MainActor 
    static func create() -> ModelContainer {
        let schemas = Schema([CategoryModel.self, IngredientModel.self, RecipeIngredientModel.self, RecipeModel.self])
        let configuration = ModelConfiguration()
        let container = try! ModelContainer(for: schemas, configurations: configuration)
        // Insert initial Data
        if isEmpty(context: container.mainContext) {
            insertInitialData(context: container.mainContext)
        }
        
        return container
    }
    
    private static func isEmpty(context: ModelContext) -> Bool{        
        let decriptor = FetchDescriptor<IngredientModel>()
        do {
            let ingredients = try context.fetch(decriptor)
            return ingredients.isEmpty
        } catch {
            return true
        }
    }
    
    private static func insertInitialData(context: ModelContext) {
        let storage = Storage()
        storage.load()
        storage.recipes.forEach { recipe in
            context.insert(recipe)
        }
    }
}

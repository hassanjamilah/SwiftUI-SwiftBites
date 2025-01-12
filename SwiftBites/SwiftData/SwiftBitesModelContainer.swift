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

// MARK: - Categories operations
extension SwiftBitesModelContainer {
    static func insertCategory(name: String, context: ModelContext) {
        let category = CategoryModel(name: name)
        context.insert(category)
    }
    
    static func deleteCategory(category: CategoryModel, context: ModelContext) {
        context.delete(category)
    }
    
    static func updateCategory(category: CategoryModel, newName: String, context: ModelContext) {
        category.name = newName
        do {
            try context.save()
        } catch {
            print("Error in saving data")
        }
        
    }
    
    static func fetchAllCategories(context: ModelContext) -> [CategoryModel] {
        let descriptor = FetchDescriptor<CategoryModel>()
        do {
            let categories = try context.fetch(descriptor)
            return categories
        } catch {
            return []
        }
    }
}

// MARK: - Ingredients operations
extension SwiftBitesModelContainer {
    static func insertIngredient(name: String, context: ModelContext) {
        let ingredientModel = IngredientModel(name: name)
        context.insert(ingredientModel)
    }
    
    static func deleteIngredient(ingredient: IngredientModel, context: ModelContext) {
        context.delete(ingredient)
    }
    
    static func updateIngredient(ingredient: IngredientModel, newName: String, context: ModelContext) {
        ingredient.name = newName
        do {
            try context.save()
        } catch {
            print("Faild to update ingredient")
        }
    }
    
    static func fetchAllIngredients(context: ModelContext) -> [IngredientModel] {
        let descriptor = FetchDescriptor<IngredientModel>()
        do {
            let ingredients = try context.fetch(descriptor)
            return ingredients
        } catch {
            return []
        }
    }
}

// MARK: - Recipes operations
extension SwiftBitesModelContainer {
    static func insertRecipe(
        name: String,
        summary: String,
        category: CategoryModel?,
        serving: Int,
        time: Int,
        ingredients: [RecipeIngredientModel],
        instructions: String,
        imageData: Data?,
        context: ModelContext
    ) {
        let recipe = RecipeModel(
            name: name,
            summary: summary,
            serving: serving,
            time: time,
            ingredients: ingredients,
            instructions: instructions,
            imageData: imageData
        )
        recipe.category = category
        context.insert(recipe)
    }
    
    static func deleteRecipe(recipe: RecipeModel, context: ModelContext) {
        context.delete(recipe)
    }
    
    static func updateRecipe(
        oldRecipe: RecipeModel,
        name: String,
        summary: String,
        category: CategoryModel?,
        serving: Int,
        time: Int,
        ingredients: [RecipeIngredientModel],
        instructions: String,
        imageData: Data?,
        context: ModelContext
    ) {
//        let recipe = RecipeModel(
//            name: name,
//            summary: summary,
//            serving: serving,
//            time: time,
//            ingredients: ingredients,
//            instructions: instructions,
//            imageData: imageData
//        )
//        recipe.id = oldRecipe.id
        oldRecipe.name = name
        oldRecipe.summary = summary
        oldRecipe.serving = serving
        oldRecipe.time = time
        oldRecipe.instructions = instructions
        oldRecipe.imageData = imageData
        oldRecipe.ingredients = ingredients
        oldRecipe.category = category
        do {
            try context.save()
        } catch {
            print("Failed to update recipe")
        }
    }
    
    static func fetchRecipes(context: ModelContext) -> [RecipeModel] {
        let desciptor = FetchDescriptor<RecipeModel>()
        do {
            let recipes = try context.fetch(desciptor)
            return recipes
        } catch {
            return []
        }
    }
    
    static func fetchRecipeByID(id: UUID, context: ModelContext) -> RecipeModel? {
        let recipePredicate = #Predicate<RecipeModel> {
            $0.id == id
        }
        
        let descriptor = FetchDescriptor<RecipeModel>(predicate: recipePredicate)
        do {
            let recipes = try context.fetch(descriptor)
            return recipes.first
        } catch {
            return nil
        }
        
    }
}

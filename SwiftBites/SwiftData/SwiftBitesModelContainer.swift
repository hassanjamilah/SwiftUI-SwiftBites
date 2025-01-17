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
    
    static func fetchCategoryByName(searchValue: String, context: ModelContext) -> [CategoryModel] {
        let predicate = #Predicate<CategoryModel> {
            $0.name.localizedStandardContains(searchValue)
        }
        
        let descriptor = FetchDescriptor(predicate: predicate)
        do {
            let categories = try context.fetch(descriptor)
            return categories
        } catch {
            print("Unable to find the category \(error)")
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
    
    static func insertRecipeIngredient(ingredient: IngredientModel, quantity: String, context: ModelContext) {
        let model = RecipeIngredientModel(ingredient: ingredient, quantity: "1 ")
        context.insert(model)
        
    }
    
    
    static func fetchAllModels(context: ModelContext) -> [RecipeIngredientModel] {
        
        
        let descriptor = FetchDescriptor<RecipeIngredientModel>()
        do {
            let ingredients = try context.fetch(descriptor)
            return ingredients
        } catch {
            print("Unable to find ingredient \(error)")
            return []
        }
        
    }
    
    static func deleteIngredient(ingredient: IngredientModel, context: ModelContext) {
        let fetchDescriptor = FetchDescriptor<RecipeIngredientModel>()
        do {
            let allRows = try context.fetch(fetchDescriptor).filter { value in
                value.ingredient.id == ingredient.id
            }
            allRows.forEach { row in
                context.delete(row)
            }
            
        } catch {
            
        }

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
    
    static func fetchIngredientByName(searchValue: String, context: ModelContext) -> [IngredientModel] {
        let predicate = #Predicate<IngredientModel> {
            $0.name.localizedStandardContains(searchValue)
        }
        let descriptor = FetchDescriptor(predicate: predicate)
        do {
            let ingredients = try context.fetch(descriptor)
            return ingredients
        } catch {
            print("Unable to find ingredient \(error)")
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
        ingredients: [RecipeIngredientModel]? = nil,
        instructions: String,
        imageData: Data?,
        context: ModelContext
    ) {
        let recipe = RecipeModel(
            name: name,
            summary: summary,
            serving: serving,
            time: time,
            instructions: instructions,
            imageData: imageData
        )
        recipe.category = category
//        recipe.recipeIngredientModels = ingredients
        
        context.insert(recipe)
        ingredients?.forEach { value in
            value.recipe = recipe
        }
        do {
            try context.save()
        } catch {
            
        }
        
        
    }
    
    static func deleteRecipe(recipe: RecipeModel, context: ModelContext) {
        let fetchDescriptor = FetchDescriptor<RecipeIngredientModel>()
        do {
            let allRows = try context.fetch(fetchDescriptor).filter {
                $0.recipe?.id == recipe.id
            }
            allRows.forEach { row in
                context.delete(row)
            }
            
        } catch {
            
        }
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
        oldRecipe.recipeIngredientModels = ingredients
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
    
    static func fetchRecipeByName(searchValue: String, context: ModelContext) -> [RecipeModel] {
        let recipePredicate = #Predicate<RecipeModel> {
            $0.name.localizedStandardContains(searchValue) ||
            $0.summary.localizedStandardContains(searchValue)
        }
        
        let descriptor = FetchDescriptor<RecipeModel>(predicate: recipePredicate)
        do {
            let recipes = try context.fetch(descriptor)
            return recipes
        } catch {
            return []
        }
        
    }
}

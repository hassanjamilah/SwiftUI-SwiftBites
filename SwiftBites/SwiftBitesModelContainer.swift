//
//  SwiftBitesModelContainer.swift
//  SwiftBites
//
//  Created by Hassan Jamila on 5/1/25.
//

import Foundation
import SwiftData

class SwiftBitesModelContainer {
    static func create() -> ModelContainer {
        let schemas = Schema([CategoryModel.self, IngredientModel.self, RecipeIngredientModel.self, RecipeModel.self])
        let configuration = ModelConfiguration()
        return try! ModelContainer(for: schemas, configurations: configuration)
    }
}

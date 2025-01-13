import SwiftUI

struct IngredientsView: View {
    typealias Selection = (IngredientModel) -> Void
    
    let selection: Selection?
    
    init(selection: Selection? = nil) {
        self.selection = selection
    }
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) var context
    @State private var query = ""
    @State private var ingredients: [IngredientModel] = []
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Ingredients")
                .toolbar {
                    if !ingredients.isEmpty {
                        NavigationLink(value: IngredientForm.Mode.add) {
                            Label("Add", systemImage: "plus")
                        }
                    }
                }
                .navigationDestination(for: IngredientForm.Mode.self) { mode in
                    IngredientForm(mode: mode) {
                        fetchData()
                    }
                }
        }
        .onAppear(perform: {
            fetchData()
        })
    }
    
    // MARK: - Views
    
    @ViewBuilder
    private var content: some View {
        if ingredients.isEmpty {
            empty
        } else {
            list(for: ingredients)
        }
    }
    
    private var empty: some View {
        ContentUnavailableView(
            label: {
                Label("No Ingredients", systemImage: "list.clipboard")
            },
            description: {
                Text("Ingredients you add will appear here.")
            },
            actions: {
                NavigationLink("Add Ingredient", value: IngredientForm.Mode.add)
                    .buttonBorderShape(.roundedRectangle)
                    .buttonStyle(.borderedProminent)
                Button(action: {
                    query = ""
                    fetchData()
                }, label: {
                    Text("Clear Search")
                })
            }
        )
    }
    
    private var noResults: some View {
        ContentUnavailableView(
            label: {
                Text("Couldn't find \"\(query)\"")
            }
        )
        .listRowSeparator(.hidden)
    }
    
    private func list(for ingredients: [IngredientModel]) -> some View {
        List {
            if ingredients.isEmpty {
                noResults
            } else {
                ForEach(ingredients) { ingredient in
                    row(for: ingredient)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button("Delete", systemImage: "trash", role: .destructive) {
                                delete(ingredient: ingredient)
                            }
                        }
                }
            }
        }
        .searchable(text: $query)
        .listStyle(.plain)
        .onChange(of: query) { _, newValue in            
            fetchData(searchValue: newValue.isEmpty ? nil : newValue)
        }
    }
    
    @ViewBuilder
    private func row(for ingredient: IngredientModel) -> some View {
        if let selection {
            Button(
                action: {
                    selection(ingredient)
                    dismiss()
                },
                label: {
                    title(for: ingredient)
                }
            )
        } else {
            NavigationLink(value: IngredientForm.Mode.edit(ingredient)) {
                title(for: ingredient)
            }
        }
    }
    
    private func title(for ingredient: IngredientModel) -> some View {
        Text(ingredient.name)
            .font(.title3)
    }
    
    // MARK: - Data
    
    private func delete(ingredient: IngredientModel) {
        SwiftBitesModelContainer.deleteIngredient(ingredient: ingredient, context: context)
    }
    
    private func fetchData(searchValue: String? = nil) {
        guard let searchValue = searchValue else {
            ingredients = SwiftBitesModelContainer.fetchAllIngredients(context: context)
            return
        }
        ingredients = SwiftBitesModelContainer.fetchIngredientByName(searchValue: searchValue, context: context)
    }
}

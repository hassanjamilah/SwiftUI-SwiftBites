import SwiftUI
import SwiftData

struct RecipesView: View {
    @Environment(\.modelContext) var context
    @State private var query = ""
    @State private var sortOrder = SortDescriptor(\RecipeModel.name)
    @State private var recipes: [RecipeModel] = []
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Recipes")
                .toolbar {
                    if !recipes.isEmpty {
                        sortOptions
                        ToolbarItem(placement: .topBarTrailing) {
                            NavigationLink(value: RecipeForm.Mode.add) {
                                Label("Add", systemImage: "plus")
                            }
                        }
                    }
                }
                .navigationDestination(for: RecipeForm.Mode.self) { mode in
                    RecipeForm(mode: mode) {
                        fetchData()
                    }
                }
        }
        .onAppear(perform: {
            fetchData()
        })
    }
    
    // MARK: - Views
    
    @ToolbarContentBuilder
    var sortOptions: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Menu("Sort", systemImage: "arrow.up.arrow.down") {
                Picker("Sort", selection: $sortOrder) {
                    Text("Name")
                        .tag(SortDescriptor(\RecipeModel.name))
                    
                    Text("Serving (low to high)")
                        .tag(SortDescriptor(\RecipeModel.serving, order: .forward))
                    
                    Text("Serving (high to low)")
                        .tag(SortDescriptor(\RecipeModel.serving, order: .reverse))
                    
                    Text("Time (short to long)")
                        .tag(SortDescriptor(\RecipeModel.time, order: .forward))
                    
                    Text("Time (long to short)")
                        .tag(SortDescriptor(\RecipeModel.time, order: .reverse))
                }
            }
            .pickerStyle(.inline)
        }
    }
    
    @ViewBuilder
    private var content: some View {
        if recipes.isEmpty {
            empty
        } else {
            list(for: recipes.sorted(using: sortOrder))
        }
            
    }
        
    
    var empty: some View {
        ContentUnavailableView(
            label: {
                Label("No Recipes", systemImage: "list.clipboard")
            },
            description: {
                Text("Recipes you add will appear here.")
            },
            actions: {
                NavigationLink("Add Recipe", value: RecipeForm.Mode.add)
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
    }
    
    private func list(for recipes: [RecipeModel]) -> some View {
        ScrollView(.vertical) {
            if recipes.isEmpty {
                noResults
            } else {
                LazyVStack(spacing: 10) {
                    ForEach(recipes, content: RecipeCell.init)
                }
            }
        }
        .searchable(text: $query)
        .onChange(of: query) { _, newValue in
            fetchData(searchValue: newValue)
        }
    }
    
    private func fetchData(searchValue: String? = nil) {
        
        guard let searchValue = searchValue else {
            recipes = SwiftBitesModelContainer.fetchRecipes(context: context)
            return
        }
        
        recipes = SwiftBitesModelContainer.fetchRecipeByName(searchValue: searchValue, context: context)
    }
}

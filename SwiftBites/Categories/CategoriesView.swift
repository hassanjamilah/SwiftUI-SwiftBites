import SwiftUI

struct CategoriesView: View {
    @Environment(\.modelContext) private var context
    @State private var categories: [CategoryModel] = []
    @State private var query: String = ""
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Categories")
                .toolbar {
                    if !categories.isEmpty {
                        NavigationLink(value: CategoryForm.Mode.add) {
                            Label("Add", systemImage: "plus")
                        }
                    }
                }
                .navigationDestination(for: CategoryForm.Mode.self) { mode in
                    CategoryForm(mode: mode) {
                        fetchData()
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
    
    @ViewBuilder
    private var content: some View {
        if categories.isEmpty {
            empty
        } else {
            list(for: categories)
        }
    }
    
    private var empty: some View {
        ContentUnavailableView(
            label: {
                Label("No Categories", systemImage: "list.clipboard")
            },
            description: {
                Text("Categories you add will appear here.")
            },
            actions: {
                NavigationLink("Add Category", value: CategoryForm.Mode.add)
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
    
    private func list(for categories: [CategoryModel]) -> some View {
        ScrollView(.vertical) {
            if categories.isEmpty {
                noResults
            } else {
                LazyVStack(spacing: 10) {
                    ForEach(categories, content: CategorySection.init)
                }
            }
        }
        .searchable(text: $query)
        .onChange(of: query) { _, value2 in
            fetchData(searchValue: value2)
        }
    }
    
    private func fetchData(searchValue: String? = nil) {
        guard let searchValue = searchValue else {
            categories = SwiftBitesModelContainer.fetchAllCategories(context: context)
            return
        }
        categories = SwiftBitesModelContainer.fetchCategoryByName(searchValue: searchValue, context: context)
    }
}

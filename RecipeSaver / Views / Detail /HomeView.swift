import SwiftUI
import CoreData

struct HomeView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Food.id, ascending: true)]) var recipes: FetchedResults<Food>
    
    @State private var searchQuery: String = ""

    var body: some View {
        NavigationView {
            VStack {
                TextField("Search recipe", text: $searchQuery)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                List {
                    ForEach(filteredRecipes, id: \.self) { recipe in
                        RecipeCard(recipe: recipe, isFavorite: self.bindingForRecipe(recipe))
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
            .navigationTitle("My Recipes")
        }
    }

    var filteredRecipes: [Food] {
        if searchQuery.isEmpty {
            return Array(recipes)
        } else {
            return recipes.filter { recipe in
                if let name = recipe.name {
                    return name.localizedCaseInsensitiveContains(searchQuery)
                }
                return false
            }
        }
    }

    private func bindingForRecipe(_ recipe: Food) -> Binding<Bool> {
        let recipeBinding = Binding<Bool>(
            get: { recipe.isFavorite },
            set: { newValue in
                recipe.isFavorite = newValue
                do {
                    try moc.save()
                } catch {
                    print("Error toggling favorite: \(error)")
                }
            }
        )
        return recipeBinding
    }
}
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

import SwiftUI
import CoreData

struct FavoriteView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Food.entity(), sortDescriptors: [], predicate: NSPredicate(format: "isFavorite == true")) var favoriteRecipes: FetchedResults<Food>
    
    var body: some View {
        NavigationView {
            List {
                if favoriteRecipes.isEmpty {
                    Text("No favorites yet")
                        .font(.title)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ForEach(favoriteRecipes, id: \.self) { recipe in
                        RecipeCard(recipe: recipe, isFavorite: self.bindingForRecipe(recipe))
                    }
                }
            }
            .navigationBarTitle("Favorites")
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

struct FavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteView()
    }
}

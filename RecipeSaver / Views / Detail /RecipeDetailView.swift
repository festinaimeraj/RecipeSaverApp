import SwiftUI

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()

struct RecipeDetailView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    var recipe: Food

    @State private var showDeleteConfirmationAlert = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                ZStack(alignment: .topTrailing) {
                    AsyncImage(url: recipe.image) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 200)
                                .cornerRadius(10)
                        } else if phase.error != nil {
                            Text("Error loading image")
                        } else {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                        }
                    }

                    if let category = recipe.category {
                        Text(category)
                            .font(.footnote)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.black.opacity(0.6))
                            .cornerRadius(5)
                            .offset(x: 0, y: 0)
                    }
                }

                if let recipeDescription = recipe.recipeDescription, !recipeDescription.isEmpty {
                    Text("Description")
                        .font(.headline)
                    Text(recipeDescription)
                }

                if let ingredients = recipe.ingredients, !ingredients.isEmpty {
                    Text("Ingredients")
                        .font(.headline)
                    Text(ingredients)
                }

                if let directions = recipe.directions, !directions.isEmpty {
                    Text("Directions")
                        .font(.headline)
                    Text(directions)
                }

                if let datePublished = recipe.datePublished {
                    Text("Date Published:")
                        .font(.headline)
                    Text(dateFormatter.string(from: datePublished))
                }

                if let url = recipe.url {
                    Text("Find in website:")
                        .font(.headline)
                    Link(url.absoluteString, destination: url)
                }

            }
            .padding(.horizontal, 16)
        }
        .navigationTitle(recipe.name ?? "Unknown Recipe")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Delete") {
                    showDeleteConfirmationAlert = true
                }
                .foregroundColor(.red)
            }
        }
        .background(Color.gray.opacity(0.2))
        .alert(isPresented: $showDeleteConfirmationAlert) {
            Alert(
                title: Text("Confirm Deletion"),
                message: Text("Are you sure you want to delete this recipe?"),
                primaryButton: .destructive(Text("Delete")) {
                    deleteRecipe()
                },
                secondaryButton: .cancel()
            )
        }
    }

    private func deleteRecipe() {
        moc.delete(recipe)

        do {
            try moc.save()

            presentationMode.wrappedValue.dismiss()
        } catch {
            print("Error deleting recipe: \(error)")
        }
    }
}
struct RecipeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetailView(recipe: Food())
    }
}

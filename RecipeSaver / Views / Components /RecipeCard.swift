import SwiftUI
import CoreData

struct RecipeCard: View {
    @Environment(\.managedObjectContext) var moc
    var recipe: Food

    @Binding var isFavorite: Bool
    @State private var showAlert = false
    @State private var alertMessage = ""

    init(recipe: Food, isFavorite: Binding<Bool>) {
        self.recipe = recipe
        self._isFavorite = isFavorite
    }
    var body: some View {
        NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
            ZStack(alignment: .bottomLeading) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .shadow(radius: 5)
                    .frame(width: 300, height: 150)

                VStack(spacing: 0) {
                    AsyncImage(url: recipe.image) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 270, height: 150)
                                .cornerRadius(10)
                        } else if phase.error != nil {
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 200)
                                .foregroundColor(.gray)
                        } else {
                            ProgressView()
                                .frame(width: 200, height: 200)
                                .progressViewStyle(CircularProgressViewStyle())
                        }
                    }
                    .cornerRadius(10)
                    HStack {
                        Spacer()
                        Button(action: {
                            toggleFavorite()
                        }) {
                            Image(systemName: isFavorite ? "heart.fill" : "heart")
                                .foregroundColor(isFavorite ? .red : .gray)
                                .padding(8)
                        }
                        .alert(isPresented: $showAlert) {
                            Alert(
                                title: Text(alertMessage),
                                dismissButton: .default(Text("OK"))
                            )
                        }
                    }
                }

                Text(recipe.name ?? "Unknown Recipe")
                    .font(.headline)
                    .foregroundColor(.primary)
                    .padding(8)
                    .cornerRadius(10)
                    .shadow(radius: 3)
                    .padding(.horizontal, 8)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .id(recipe.objectID)
    }

    private func toggleFavorite() {
        isFavorite.toggle()
        recipe.isFavorite = isFavorite
        let message = isFavorite ? "Added to favorites" : "Removed from favorites"
        alertMessage = message
        showAlert = true
        print("Recipe isFavorite toggled to: \(isFavorite)")

        do {
            try moc.save()
        } catch {
            print("Error toggling favorite: \(error)")
        }
    }
}

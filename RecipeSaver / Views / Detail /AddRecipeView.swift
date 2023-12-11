import SwiftUI
import CoreData

struct AddRecipeView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var image = ""
    @State private var directions = ""
    @State private var recipeDescription = ""
    @State private var datePublished = Date()
    @State private var url = ""
    @State private var ingredients = ""
    @State private var category = ""
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    
    let categories = ["Breakfast","Lunch", "Soup", "Salad", "Appetizer", "Main", "Dessert"]
    
    var body: some View {
        NavigationView {
            Form {
                Section() {
                    TextField("Name of recipe", text: $name)
                    
                    VStack(alignment: .leading) {
                        TextField("Image URL", text: $image)
                    }
                    
                    Picker("Category", selection: $category) {
                        ForEach(categories, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                Section(header: Text("Description")) {
                    ZStack(alignment: .topLeading) {
                        TextEditor(text: $recipeDescription)
                            .frame(minHeight: 50, alignment: .leading)
                    }
                }
                
                Section(header: Text("Ingredients")) {
                    ZStack(alignment: .topLeading) {
                        TextEditor(text: $ingredients)
                            .frame(minHeight: 50, alignment: .leading)
                    }
                }
                
                Section(header: Text("Directions")) {
                    ZStack(alignment: .topLeading) {
                        TextEditor(text: $directions)
                            .frame(minHeight: 50, alignment: .leading)
                    }
                }
                
                Section(header: Text("Find in website")) {
                    TextField("URL", text: $url)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if areFieldsValid() {
                            let newRecipe = Food(context: moc)
                            newRecipe.name = name
                            
                            if let imageURL = URL(string: image) {
                                newRecipe.image = imageURL
                            }
                            
                            newRecipe.directions = directions
                            newRecipe.recipeDescription = recipeDescription
                            newRecipe.datePublished = datePublished
                            
                            if let recipeURL = URL(string: url) {
                                newRecipe.url = recipeURL
                            }
                            
                            newRecipe.ingredients = ingredients
                            newRecipe.category = category
                            
                            do {
                                try moc.save()
                                
                                name = ""
                                image = ""
                                directions = ""
                                recipeDescription = ""
                                url = ""
                                ingredients = ""
                                category = ""
                                
                                alertMessage = "Recipe saved successfully!"
                                showAlert = true
                                
                                presentationMode.wrappedValue.dismiss()
                            } catch {
                                print("Error saving recipe: \(error)")
                            }
                        } else {
                            alertMessage = "Please fill in all the required fields."
                            showAlert = true
                        }
                    }
                }
            }
            .navigationBarTitle("Add Recipe", displayMode: .inline)
            .alert(isPresented: $showAlert) {
                Alert(title: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func areFieldsValid() -> Bool {
        return !name.isEmpty && !ingredients.isEmpty && !directions.isEmpty
    }
}

struct AddRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        AddRecipeView()
    }
}

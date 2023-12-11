import SwiftUI

@main
struct RecipeSaverApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            TabBar()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}

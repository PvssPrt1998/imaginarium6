import Foundation

final class HomeViewModel: ObservableObject {
    
    let source: Source
    
    @Published var selected: Set<Category> = []
    
    init(source: Source) {
        self.source = source
    }
    
    func playButtonPressed() {
        source.selectedCategories = selected
    }
    
    func select(_ category: Category) {
        if selected.contains(category) {
            selected.remove(category)
        } else {
            selected.insert(category)
        }
    }
    
    func selected(_ category: Category) -> Bool {
        selected.contains(category) ? true : false
    }
    
    func makeAddPlayersViewModel() -> AddPlayersViewModel {
        AddPlayersViewModel(source: source)
    }
}

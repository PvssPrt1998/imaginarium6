
import SwiftUI

struct ContentView: View {
    
    @State var hideSplash = false
    @StateObject var gameController = GameController()
    @StateObject var viewModelFactory = ViewModelFactory()
    
    var body: some View {
        if !hideSplash {
            LoadingView(hide: $hideSplash)
        } else {
            preparingOrGame()
                .environmentObject(gameController)
                .environmentObject(viewModelFactory)
        }
    }
    
    @ViewBuilder func preparingOrGame() -> some View {
        if gameController.isGame {
            GameView(viewModel: viewModelFactory.makeGameViewModel())
        } else {
            HomeView(viewModel: viewModelFactory.makeHomeViewModel())
        }
    }
}

#Preview {
    ContentView()
}

final class ViewModelFactory: ObservableObject {
    
    let source = Source()
    
    func makeHomeViewModel() -> HomeViewModel {
        HomeViewModel(source: source)
    }
    
    func makeGameViewModel() -> GameViewModel {
        GameViewModel(source: source)
    }
}

final class GameController: ObservableObject {
    @Published var isGame = false
}

import SwiftUI

struct HomeView: View {
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    @AppStorage("firstLaunchEvent") var firstLaunchEvent = true
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                Image(Images.Background.rawValue)
                    .resizable()
                    .ignoresSafeArea()
                VStack(spacing: 14) {
                    Image(Images.HomeHeaderView.rawValue)
                        .resizable()
                        .scaledToFit()
                        .overlay(header.padding(.top, safeAreaInsets.top))
                    categories
                }
                .ignoresSafeArea()
                .frame(maxHeight: .infinity, alignment: .top)
                
                NavigationLink {
                    addPlayersView()
                } label: {
                    Text("Play")
                        .font(.largeTitle.weight(.bold))
                        .foregroundColor(.c10547143)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .background(
                            LinearGradient(colors: [.orangeGradient1, .orangeGradient2], startPoint: .top, endPoint: .bottom)
                        )
                        .clipShape(.rect(cornerRadius: 10))
                }
                .disabled(viewModel.selected.count <= 0)
                .opacity(viewModel.selected.count > 0 ? 1 : 0.5)
                .padding(.horizontal, hPadding())
                .padding(.bottom, 8)
                .frame(maxHeight: .infinity, alignment: .bottom)
                
                if firstLaunchEvent {
                    showFirstLaunchEvent()
                        .onTapGesture {
                            withAnimation {
                                firstLaunchEvent = false
                            }
                        }
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                withAnimation {
                                    firstLaunchEvent = false
                                }
                            }
                        }
                }
            }
        }
        .onAppear {
            AppDelegate.orientationLock = .portrait
        }
    }
    
    private func showFirstLaunchEvent() -> some View {
        ZStack {
            Image("EventMessageBg")
                .resizable()
                .ignoresSafeArea()
            VStack {
                Text("We've got great news!\n")
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                Text("Added you a cool set of space\ncards that are now always\navailable to play. The set includes\n10 unique cards for your game")
                    .font(.title2.bold())
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
            }
            .padding(EdgeInsets(top: 0, leading: hPadding(), bottom: 175, trailing: hPadding()))
        }
        
    }
    
    private func addPlayersView() -> some View {
        viewModel.playButtonPressed()
        return AddPlayersView(viewModel: viewModel.makeAddPlayersViewModel())
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel(source: Source()))
}

extension HomeView {
    private var header: some View {
        ZStack {
            VStack(spacing: 16) {
                Text("Welcome to\nLucky Moments")
                    .multilineTextAlignment(.center)
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(.white)
                Text("Choose which categories\nyou want to play in")
                    .multilineTextAlignment(.center)
                    .font(.body)
                    .foregroundColor(.white)
            }
            .padding(.top, 23)
            .frame(maxHeight: .infinity, alignment: .top)
            
            NavigationLink {
                SettingsView(source: viewModel.source)
            } label: {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 24, weight: .regular))
                    .foregroundColor(.c10547143)
            }
            .padding(.horizontal, hPadding())
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        }
    }
    
    private var categories: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 16) {
                CategoryCard(title: "The world of gaming", 
                             subtitle: "Magical illustrations that will remind you\nhow beautiful the world of gaming is",
                             selected: viewModel.selected(.theWorldOfGaming)) {
                    viewModel.select(.theWorldOfGaming)
                }
                CategoryCard(title: "Dreamworld", 
                             subtitle: "Immerse yourself in the world of\ndreams with our beautiful illustrations",
                             selected: viewModel.selected(.dreamworld)) {
                    viewModel.select(.dreamworld)
                }
                CategoryCard(title: "Fears are close by", 
                             subtitle: "Our illustrations show all possible fears,\nbut you don't have to be afraid, they\nwon't hurt you",
                             selected: viewModel.selected(.fearsAreClosedBy)) {
                    viewModel.select(.fearsAreClosedBy)
                }
            }
            .clipShape(.rect(cornerRadius: 20))
            .padding(.bottom, safeAreaInsets.bottom + 16 + 69)
        }
        .clipShape(.rect(cornerRadius: 20))
        .padding(.horizontal, 31)
        
    }
}

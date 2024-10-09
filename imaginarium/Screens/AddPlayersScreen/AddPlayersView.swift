import SwiftUI

struct AddPlayersView: View {
    
    @ObservedObject var viewModel: AddPlayersViewModel
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    init(viewModel: AddPlayersViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            Image(Images.Background.rawValue)
                .resizable()
                .ignoresSafeArea()
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
                }
            Image(Images.HomeHeaderView.rawValue)
                .resizable()
                .scaledToFit()
                .overlay(header.padding(.top, safeAreaInsets.top))
                .padding(.bottom, 27)
                .ignoresSafeArea(.keyboard, edges: .bottom)
                .ignoresSafeArea()
                .frame(maxHeight: .infinity, alignment: .top)
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
                }
            VStack(spacing: 14) {
                Image(Images.HomeHeaderView.rawValue)
                    .resizable()
                    .scaledToFit()
                    //.overlay(header.padding(.top, safeAreaInsets.top))
                    //.padding(.bottom, 27)
                    //.ignoresSafeArea(.keyboard, edges: .bottom)
                    //.ignoresSafeArea()
                    .hidden()
                    
                    
                    
                if viewModel.players.count > 0 {
                    players
                        //.modifier(KeyboardAdaptive())
                }
                addPlayerButton
            }
            //.ignoresSafeArea()
            .frame(maxHeight: .infinity, alignment: .top)
            
            NavigationLink {
                guideView()
            } label: {
                Text("Play")
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .background(LinearGradient(colors: [.orangeGradient1, .orangeGradient2], startPoint: .top, endPoint: .bottom))
                    .clipShape(.rect(cornerRadius: 10))
            }
            .opacity(viewModel.playButtonDisabled() ? 0.5 : 1)
            .disabled(viewModel.playButtonDisabled())
            .padding(.horizontal, hPadding())
            .padding(.bottom, 8)
            .frame(maxHeight: .infinity, alignment: .bottom)
            .ignoresSafeArea(.keyboard, edges: .bottom)
            
            Button {
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Image(systemName: "arrow.left")
                    .font(.system(size: 24, weight: .regular))
                    .foregroundColor(.white)
            }
            .padding(EdgeInsets(top: 48, leading: 28, bottom: 0, trailing: 28))
            .frame(maxWidth: .infinity, maxHeight: .infinity ,alignment: .topLeading)
        }
        //.ignoresSafeArea(.keyboard, edges: .bottom)
        .navigationBarBackButtonHidden(true)
    }
    
    func guideView() -> some View {
        viewModel.playButtonPressed()
        return GuideScreen1()
    }
}

#Preview {
    AddPlayersView(viewModel: AddPlayersViewModel(source: Source()))
}

extension AddPlayersView {
    
    private var header: some View {
        ZStack {
            VStack(spacing: 10) {
                Text("Add players")
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(.white)
                Text("This game can be played\nby 2 to 4 players")
                    .multilineTextAlignment(.center)
                    .font(.body)
                    .foregroundColor(.white)
            }
            .padding(.top, 45)
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
        }
    }
    
    private var addPlayerButton: some View {
        Button {
            viewModel.addPlayerButtonPressed()
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "plus")
                    .font(.system(size: 24, weight: .regular))
                    .foregroundColor(Color.white)
                Text("Add players")
                    .font(.custom("Rubik", size: 14).weight(.medium))
                    .foregroundColor(.white)
            }
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(LinearGradient(colors: [.orangeGradient1, .orangeGradient2], startPoint: .top, endPoint: .bottom))
            .clipShape(.rect(cornerRadius: 10))
        }
        .opacity(viewModel.players.count >= 4 ? 0 : 1)
        .disabled(viewModel.players.count >= 4)
        .padding(.horizontal, hPadding())
    }
    
    private var players: some View {
        VStack(spacing: 14) {
            ForEach(0..<viewModel.players.count, id: \.self) { index in
                HStack(spacing: 2) {
                    Image(viewModel.players[index].imageTitle)
                    AddPlayerTextField(text: textBindingForPlayer(viewModel.players[index].id), placeholder: "Name")
                    Button {
                        viewModel.removePlayer(index)
                    } label: {
                        LinearGradient(colors: [.orangeGradient1, .orangeGradient2], startPoint: .top, endPoint: .bottom)
                            .mask(Image(systemName: "trash.fill")
                                .font(.system(size: 24, weight: .regular))
                                .foregroundColor(.white))
                            .frame(width: 27, height: 29)
                        
                    }
                }
            }
        }
        .padding(.horizontal, hPadding())
    }
    
    func textBindingForPlayer(_ id: Int) -> Binding<String> {
        switch id {
        case 0: return $viewModel.player1text
        case 1: return $viewModel.player2text
        case 2: return $viewModel.player3text
        case 3: return $viewModel.player4text
        default:
            return $viewModel.player1text
        }
    }
}

//MARK: - viewModel

final class AddPlayersViewModel: ObservableObject {
    
    let source: Source
    
    @Published var player1text = ""
    @Published var player2text = ""
    @Published var player3text = ""
    @Published var player4text = ""
    
    @Published var addPlayersDisabled: Bool = false
    
    var players: Array<Player> = []
    
    private var freeImageTitles: Array<String> = [
        Images.Player1Image.rawValue,
        Images.Player2Image.rawValue,
        Images.Player3Image.rawValue,
        Images.Player4Image.rawValue
    ]
    
    private var freeIds: Array<Int> = [0,1,2,3]
    
    init(source: Source) {
        self.source = source
    }
    
    func playButtonPressed() {
        for i in 0..<players.count {
            switch players[i].id {
            case 0: players[i].name = player1text
            case 1: players[i].name = player2text
            case 2: players[i].name = player3text
            case 3: players[i].name = player4text
            default: players[i].name = "Error"
            }
        }
        source.players = players
    }
    
    func addPlayerButtonPressed() {
        if players.count < 4 {
            players.append(Player(id: freeIds.removeFirst(), imageTitle: imageTitleForPlayer(), name: ""))
        }
        objectWillChange.send()
    }
    
    func removePlayer(_ index: Int) {
        freeIds.insert(players[index].id, at: 0)
        freeImageTitles.insert(players[index].imageTitle, at: 0)
        switch players[index].id {
        case 0: player1text = ""
        case 1: player2text = ""
        case 2: player3text = ""
        case 3: player4text = ""
        default:
            return player1text = ""
        }
        players.remove(at: index)
    }
    
    func imageTitleForPlayer() -> String {
        freeImageTitles.removeFirst()
    }
    
    func playButtonDisabled() -> Bool {
        players.count < 2 || isTextEmptyForPlayers()
    }
    
    func isTextEmptyForPlayers() -> Bool {
        var isEmpty = false
        players.forEach { player in
            switch player.id {
            case 0: if player1text == "" {isEmpty = true; return}
            case 1: if player2text == "" {isEmpty = true; return}
            case 2: if player3text == "" {isEmpty = true; return}
            case 3: if player4text == "" {isEmpty = true; return}
            default:
                if player1text == "" {isEmpty = true; return}
            }
        }
        return isEmpty
    }
}

import Combine
import UIKit

/// Publisher to read keyboard changes.
protocol KeyboardReadable {
    var keyboardPublisher: AnyPublisher<Bool, Never> { get }
}

extension KeyboardReadable {
    var keyboardPublisher: AnyPublisher<Bool, Never> {
        Publishers.Merge(
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillShowNotification)
                .map { _ in true },
            
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillHideNotification)
                .map { _ in false }
        )
        .eraseToAnyPublisher()
    }
}

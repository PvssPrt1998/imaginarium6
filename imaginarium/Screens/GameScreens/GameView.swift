import SwiftUI

struct GameView: View {
    
    @EnvironmentObject var gameController: GameController
    @ObservedObject var viewModel: GameViewModel
    
    var body: some View {
        if viewModel.stage == .handThePhone {
            HandThePhoneView(player: viewModel.currentPlayer()) {
                       viewModel.handThePhonePressed()
                   }
        } else if viewModel.stage == .playerPick {
            chooseImageView
        } else if viewModel.stage == .chosenCards {
            chosenCards
        } else if viewModel.stage == .vote {
            voteView(viewModel.voteStage)
        } else if viewModel.stage == .roundWin {
            roundWin()
        } else if viewModel.stage == .gameWin {
            winScreen
        }
    }
}

#Preview {
    GameView(viewModel: GameViewModel(source: Source()))
}

final class GameViewModel: ObservableObject {
    
    enum Stage {
        case handThePhone
        case playerPick
        case chosenCards
        case vote
        case roundWin
        case gameWin
    }
    
    @Published var nextButtonDisabled = false
    
    @Published var voteStage = 0
    
    var votePlayers: Array<Player> = []
    @Published var selectedImagesVotedPlayers: Array<(String, Set<Player>)> = []
    
    @Published var stage: Stage = .handThePhone
    
    @Published var currentPlayerIndex = 0
    
    let source: Source
    
    var gameImageTitles: Array<String> = []
    
    var players: Array<Player> = []
    
    var selectedImages: Array<String> = []
    var selectedImage: String = ""
    
    var leaderIndex = 0
    
    init(source: Source) {
        self.source = source
        self.players = source.players
        for i in 1..<players.count {
            votePlayers.append(players[i])
        }
        configureImageTitles()
    }
    
    func handThePhonePressed() {
        setupSelectedImages()
        if source.withEffects {
            withAnimation {
                stage = .playerPick
            }
        } else {
            stage = .playerPick
        }
    }
    
    func currentPlayer() -> Player {
        players[currentPlayerIndex]
    }
    
    func setupSelectedImages() {
        selectedImages = []
        for _ in 0...3 {
            if gameImageTitles.count > 0 {
                selectedImages.append(gameImageTitles.removeFirst())
            } else {
                print("No cards")
            }
        }
        if selectedImages.count > 0 {
            selectedImage = selectedImages[0]
        } else {
            print("no selected. empty")
        }
    }
    
    func roundWin() {
        if isCardsEnough() {
            //prepare for new round
            prepareForNewRound()
            if source.withEffects {
                withAnimation {
                    stage = .handThePhone
                }
            } else {
                stage = .handThePhone
            }
        } else {
            if source.withEffects {
                withAnimation {
                    stage = .gameWin
                }
            } else {
                stage = .gameWin
            }
            
        }
    }
    
    func selectImageTitle(_ imageTitle: String) {
        selectedImage = imageTitle
        objectWillChange.send()
    }

    func goButtonPressed() {
        
        players[currentPlayerIndex].pickedCard = selectedImage
        print(players[currentPlayerIndex].pickedCard)
        if currentPlayerIndex < players.count - 1 {
            currentPlayerIndex += 1
            if source.withEffects {
                withAnimation {
                    self.stage = .handThePhone
                }
            } else {
                self.stage = .handThePhone
            }
            
        } else {
            if source.withEffects {
                withAnimation {
                    self.stage = .chosenCards
                }
            } else {
                self.stage = .chosenCards
            }
            
            selectedImages = []
            players.forEach { player in
                selectedImages.append(player.pickedCard)
            }
            selectedImages.shuffle()
        }
    }
    private func configureImageTitles() {
        if source.selectedCategories.contains(.theWorldOfGaming) {
            for i in 1...20 {
                gameImageTitles.append("Game\(i)")
            }
        }
        if source.selectedCategories.contains(.dreamworld) {
            for i in 1...20 {
                gameImageTitles.append("Dream\(i)")
            }
        }
        if source.selectedCategories.contains(.fearsAreClosedBy) {
            for i in 1...20 {
                gameImageTitles.append("fear\(i)")
            }
        }
        
        if players.count == 3 {
            if gameImageTitles.count == 20 {
                gameImageTitles.removeLast()
                gameImageTitles.removeLast()
            }
            if gameImageTitles.count == 40 {
                gameImageTitles.removeLast()
            }
        }
        gameImageTitles.shuffle()
    }
    
    func startVotingButtonPressed() {
        selectedImages.forEach { string in
            selectedImagesVotedPlayers.append((string, []))
        }
        if source.withEffects {
            withAnimation {
                stage = .vote
            }
        } else {
            stage = .vote
        }
    }
    
    func setupScores() {
        selectedImagesVotedPlayers.forEach { SS in
            if SS.0 == players[0].pickedCard {
                if SS.1.count > 0 && (SS.1.count == 1 || SS.1.count == 2) {
                    players[0].score += 3
                }
            }
        }
        for i in 1..<players.count {
            selectedImagesVotedPlayers.forEach { SS in
                if players[i].pickedCard == SS.0 {
                    players[i].score += SS.1.count
                }
            }
        }
    }
    
    func voteNext(_ imageIndex: Int) {
        if imageIndex == selectedImages.count - 1 {
            setupScores()
            if source.withEffects {
                withAnimation {
                    stage = .roundWin
                }
            } else {
                stage = .roundWin
            }
            
        } else if isAllPlayersSelected() {
            setupScores()
            if source.withEffects {
                withAnimation {
                    stage = .roundWin
                }
            } else {
                stage = .roundWin
            }
            
        } else {
            voteStage += 1
            selectedImagesVotedPlayers.forEach { SS in
                SS.1.forEach { playerForRemove in
                    votePlayers.removeAll(where: {$0.id == playerForRemove.id})
                }
            }
            if imageIndex == selectedImages.count - 2 {
                
                if !isAllPlayersSelected() {
                    nextButtonDisabled = true
                }
            }
        }
    }
    
    func selectImageForPlayer(_ index: Int, playerIndex: Int) {
        if selectedImagesVotedPlayers[index].1.contains(votePlayers[playerIndex]) {
            selectedImagesVotedPlayers[index].1.remove(votePlayers[playerIndex])
        } else {
            print(selectedImagesVotedPlayers[index].0)
            selectedImagesVotedPlayers[index].1.insert(votePlayers[playerIndex])
            
        }
        
        if index == selectedImages.count - 1 {
            if !isAllPlayersSelected() {
                nextButtonDisabled = true
            } else {
                nextButtonDisabled = false
            }
        }
    }
    
    func prepareForNewRound() {
        let player = players.removeFirst()
        selectedImagesVotedPlayers = []
        players.append(player)
        votePlayers = players
        votePlayers.removeFirst()
        currentPlayerIndex = 0
        voteStage = 0
    }
    
    func checkPlayerSelect(_ index: Int) -> Bool {
        var selected = false
        selectedImagesVotedPlayers.forEach { sSet in
            if sSet.1.contains(votePlayers[index]) {
                selected = true
            }
        }
        
        return selected
    }
    func isAllPlayersSelected() -> Bool {
        var set: Set<Player> = []
        selectedImagesVotedPlayers.forEach { SS in
            SS.1.forEach { player in
                if !set.contains(where: {$0.id == player.id}) {
                    set.insert(player)
                }
            }
        }
        if set.count == players.count - 1 {
            return true
        } else {
            return false
        }
    }
    func isCardsEnough() -> Bool {
        if gameImageTitles.count >= players.count * 4 {
            return true
        } else {
            return false
        }
    }
    func maxScorePlayerName() -> String {
        var maxScore = 0
        var maxName = ""
        players.forEach { player in
            if player.score > maxScore {
                maxScore = player.score
                maxName = player.name
            }
        }
        return maxName
    }
}

extension GameView {
    private var chooseImageView: some View {
        ZStack {
            ZStack {
                Image(Images.Background.rawValue)
                    .resizable()
                    .ignoresSafeArea()
                VStack(spacing: 0) {
                    Text(viewModel.currentPlayerIndex == viewModel.leaderIndex ? "Pick a card and name\nthe association." : "Pick a card\n")
                        .multilineTextAlignment(.center)
                        .font(.largeTitle.weight(.bold))
                        .foregroundColor(.white)
                        .padding(.top, 13)
                    
                    Image(viewModel.selectedImage)
                        .resizable()
                        .scaledToFit()
                        .padding(.top, 13)
                    
                    HStack(spacing: 5) {
                        ForEach(viewModel.selectedImages, id: \.self) { imageTitle in
                            Image(imageTitle)
                                .resizable()
                                .scaledToFit()
                                .onTapGesture {
                                    viewModel.selectImageTitle(imageTitle)
                                }
                        }
                    }
                    .padding(.top, 18)
                    Button {
                        viewModel.goButtonPressed()
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "checkmark")
                                .font(.system(size: 24, weight: .heavy))
                                .foregroundColor(.c10547143)
                            Text("GO")
                                .font(.custom("Rubik", size: 14).weight(.medium))
                                .foregroundColor(.c10547143)
                        }
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .clipShape(.rect(cornerRadius: 10))
                    }
                    .padding(.bottom, 8)
                    .padding(.top, 33)
                }
                .padding(.horizontal, hPadding())
            }
        }
    }
    
    private var chosenCards: some View {
        ZStack {
            Image(Images.Background.rawValue)
                .resizable()
                .ignoresSafeArea()
            VStack(spacing: 0) {
                Text("Let's take a look at the cards you've chosen")
                    .multilineTextAlignment(.center)
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(.white)
                    .padding(.top, 13)
//                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100, maximum: 200)),GridItem(.adaptive(minimum: 100, maximum: 200))], spacing: 10) {
//                    ForEach(0..<viewModel.players.count, id: \.self) { index in
//                        Image(viewModel.selectedImages[index])
//                            .resizable()
//                            .scaledToFit()
//                            .overlay(Text("\(index + 1)")
//                                .font(.largeTitle.weight(.bold))
//                                .foregroundColor(.white)
//                                .padding(8)
//                                     ,alignment: .topLeading
//                            )
//                    }
//                }
//                .frame(width: UIScreen.main.bounds.size.width - 86)
                VStack(spacing: 10) {
                    HStack(spacing: 10) {
                        ForEach(0..<min(2,viewModel.players.count), id: \.self) { index in
                            Image(viewModel.selectedImages[index])
                                .resizable()
                                .scaledToFit()
                                .overlay(Text("\(index + 1)")
                                    .font(.largeTitle.weight(.bold))
                                    .foregroundColor(.white)
                                    .padding(8)
                                         ,alignment: .topLeading
                                )
                        }
                        .frame(maxHeight: .infinity)
                    }
                    if viewModel.players.count > 2 {
                        HStack(spacing: 10) {
                            ForEach(2..<viewModel.players.count, id: \.self) { index in
                                Image(viewModel.selectedImages[index])
                                    .resizable()
                                    .scaledToFit()
                                    .overlay(Text("\(index + 1)")
                                        .font(.largeTitle.weight(.bold))
                                        .foregroundColor(.white)
                                        .padding(8)
                                             ,alignment: .topLeading
                                    )
                            }
                        }
                        .frame(maxHeight: .infinity)
                    }
                }
                .padding(.top, 40)
                .frame(maxHeight: .infinity)
                
                Button {
                    viewModel.startVotingButtonPressed()
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "hands.and.sparkles.fill")
                            .font(.system(size: 24, weight: .heavy))
                            .foregroundColor(.c10547143)
                        Text("Start voting")
                            .font(.custom("Rubik", size: 14).weight(.medium))
                            .foregroundColor(.c10547143)
                    }
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .clipShape(.rect(cornerRadius: 10))
                }
                .padding(.top, 16)
                .padding(.bottom, 8)
                //.frame(maxHeight: .infinity, alignment: .bottom)
            }
            //.frame(maxHeight: .infinity, alignment: .top)
            .padding(.horizontal, hPadding())
        }
    }
    
    private func voteView(_ index: Int) -> some View {
        ZStack {
            Image(Images.Background.rawValue)
                .resizable()
                .ignoresSafeArea()
            VStack(spacing: 0) {
                Text("Who votes for this\npicture ?")
                    .multilineTextAlignment(.center)
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(.white)
                    .padding(.top, 13)
                Image(viewModel.selectedImages[index])
                    .resizable()
                    .scaledToFit()
                    .overlay(Text("\(index + 1)")
                        .font(.largeTitle.weight(.bold))
                        .foregroundColor(.white)
                        .padding(8)
                             ,alignment: .topLeading
                    )
                    .padding(.top, 13)
                LazyVGrid(columns: [GridItem(.fixed(163), spacing: 10),GridItem(.fixed(163), spacing: 10)], spacing: 10) {
                    ForEach(0..<viewModel.votePlayers.count, id: \.self) { i in
                        HStack(spacing: 10) {
                            Image(viewModel.votePlayers[i].imageTitle)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 67, height: 63)
                            Text(viewModel.votePlayers[i].name)
                                .font(.callout)
                                .foregroundColor(.c10547143)
                                .frame(maxWidth: 66, alignment: .leading)
                        }
                        .padding(10)
                        .background(Color.cSecondary)
                        .clipShape(.rect(cornerRadius: 15))
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(viewModel.checkPlayerSelect(i) ? .white : .clear, lineWidth: 3)
                        )
                        .onTapGesture {
                            viewModel.selectImageForPlayer(index, playerIndex: i)
                        }
                    }
                }
                .frame(maxHeight: 230)
                .padding(.top, 18)
                
                Button {
                    viewModel.voteNext(index)
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "hands.and.sparkles.fill")
                            .font(.system(size: 24, weight: .heavy))
                            .foregroundColor(.c10547143)
                        Text("Next")
                            .font(.custom("Rubik", size: 14).weight(.medium))
                            .foregroundColor(.c10547143)
                    }
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .background(Color.white.opacity(viewModel.nextButtonDisabled ? 0.5 : 1))
                    .clipShape(.rect(cornerRadius: 10))
                }
                .disabled(viewModel.nextButtonDisabled)
                .padding(.bottom, 8)
            }
            .padding(.horizontal, hPadding())
        }
    }
    
    private func roundWin() -> some View {
        ZStack {
            Image(Images.Background.rawValue)
                .resizable()
                .ignoresSafeArea()
            VStack(spacing: 0) {
                Text("And we have the right\nanswer")
                    .multilineTextAlignment(.center)
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(.white)
                    .padding(.top, 13)
                
                Image(viewModel.players[0].pickedCard)
                    .resizable()
                    .scaledToFit()
                    .padding(.top, 13)
                
                VStack(spacing: 10) {
                    ForEach(0..<viewModel.players.count, id: \.self) { index in
                        VStack(spacing: 0) {
                            HStack(spacing: 0) {
                                Image(viewModel.players[index].imageTitle)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 52, height: 49)
                                Text(viewModel.players[index].name)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(.leading, 8)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("\(viewModel.players[index].score)")
                                    .font(.system(size: 26, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            if index != viewModel.players.count - 1 {
                                Rectangle()
                                    .fill(Color.white.opacity(0.41))
                                    .frame(width: 234, height: 0.77)
                                    .padding(10)
                            }
                        }
                    }
                }
                .padding(.top, 13)
                
                Button {
                    viewModel.roundWin()
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "hands.and.sparkles.fill")
                            .font(.system(size: 24, weight: .heavy))
                            .foregroundColor(.c10547143)
                        Text(viewModel.isCardsEnough() ? "Start voting" : "Next")
                            .font(.custom("Rubik", size: 14).weight(.medium))
                            .foregroundColor(.c10547143)
                    }
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .background(Color.white.opacity(viewModel.nextButtonDisabled ? 0.5 : 1))
                    .clipShape(.rect(cornerRadius: 10))
                }
                .disabled(viewModel.nextButtonDisabled)
                .padding(.top, 18)
                .padding(.bottom, 8)
                
            }
            .padding(.horizontal, hPadding())
        }
    }
    
    private var winScreen: some View {
        ZStack {
            Image(Images.Background.rawValue)
                .resizable()
                .ignoresSafeArea()
            VStack(spacing: 0) {
                Text("WIN " + viewModel.maxScorePlayerName())
                    .multilineTextAlignment(.center)
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(.white)
                    .padding(.top, 62)

                VStack(spacing: 10) {
                    ForEach(0..<viewModel.players.count, id: \.self) { index in
                        VStack(spacing: 0) {
                            HStack(spacing: 0) {
                                Image(viewModel.players[index].imageTitle)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 52, height: 49)
                                Text(viewModel.players[index].name)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(.leading, 8)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("\(viewModel.players[index].score)")
                                    .font(.system(size: 26, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            if index != viewModel.players.count - 1 {
                                Rectangle()
                                    .fill(Color.white.opacity(0.41))
                                    .frame(width: 234, height: 0.77)
                                    .padding(10)
                            }
                        }
                    }
                }
                .padding(.top, 66)
                Spacer()
                Button {
                    gameController.isGame = false
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "house.fill")
                            .font(.system(size: 24, weight: .heavy))
                            .foregroundColor(.c10547143)
                        Text("Home")
                            .font(.custom("Rubik", size: 14).weight(.medium))
                            .foregroundColor(.c10547143)
                    }
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .clipShape(.rect(cornerRadius: 10))
                }
                .disabled(viewModel.nextButtonDisabled)
                .padding(.bottom, 8)
                
            }
            .padding(.horizontal, hPadding())
        }
    }
}

import SwiftUI
import AVKit

final class Source: NSObject, ObservableObject, AVAudioPlayerDelegate {
    
    var player: AVAudioPlayer?
    var players: Array<Player> = []
    
    @AppStorage("withEffects") var withEffects: Bool = true
    @AppStorage("withMusic") var withMusic: Bool = true {
        didSet {
            if withMusic && !oldValue {
                setMusic()
            } else if oldValue && !withMusic {
                noSound()
            }
        }
    }
    
    @Published var music: Bool = true {
        didSet {
            withMusic = music
        }
    }
    @Published var effects: Bool = true {
        didSet {
            withEffects = effects
        }
    }
    
    override init() {
        super.init()
        music = withMusic
        effects = withEffects
        if withMusic {
            setMusic()
        }
    }
    
    func setMusic() {
        guard let path = Bundle.main.path(forResource: "music", ofType: "mp3") else {
            return }
        let url = URL(fileURLWithPath: path)
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.delegate = self
            player?.currentTime = 0
            player?.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    var selectedCategories: Set<Category> = []
    
    func addPlayer(name: String) {
        var imageTitle = ""
        if players.count == 1 {imageTitle = Images.Player1Image.rawValue} else
        if players.count == 2 {imageTitle = Images.Player2Image.rawValue} else
        if players.count == 3 {imageTitle = Images.Player3Image.rawValue} else
        if players.count == 4 {imageTitle = Images.Player4Image.rawValue}
        
        players.append(Player(id: 0, imageTitle: imageTitle, name: name))
    }
    
    func configureCategories(_ categories: [Category]) {
        
    }
    
    func noSound() {
        player = nil
    }
}


struct Player: Hashable {
    let id: Int
    let imageTitle: String
    var name: String
    var score: Int = 0
    var pickedCard: String = ""
}


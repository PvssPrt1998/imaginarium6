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

import Foundation
import CoreData

class CDSk {
    
    private let modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    lazy var managedContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
    
    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                return print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    func saveContext() {
        guard managedContext.hasChanges else { return }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
}

final class CoreDataManager {
    private let modelName = "SettingsData"
    
    lazy var coreDataStack = CDSk(modelName: modelName)
    
    func editAlways(_ select: Bool) {
        do {
            let ids = try coreDataStack.managedContext.fetch(AlwaysSelect.fetchRequest())
            if ids.count > 0 {
                //exists
                ids[0].select = select
            } else {
                let alwaysSelect = AlwaysSelect(context: coreDataStack.managedContext)
                alwaysSelect.select = select
            }
            coreDataStack.saveContext()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    func fetchAlways() throws -> Bool? {
        guard let totalNumber = try coreDataStack.managedContext.fetch(AlwaysSelect.fetchRequest()).first else { return nil }
        return totalNumber.select
    }
    
    func fetchSelected() throws -> String? {
        guard let totalNumber = try coreDataStack.managedContext.fetch(CategorySelected.fetchRequest()).first else { return nil }
        return totalNumber.category
    }
    
    func createGameSettingsObject() {
        let settingsObject = CategorySelected(context: coreDataStack.managedContext)
        coreDataStack.saveContext()
    }
}

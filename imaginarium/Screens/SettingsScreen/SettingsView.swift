import SwiftUI
import StoreKit

struct SettingsView: View {
    
    @Environment(\.openURL) var openURL
    @ObservedObject var source: Source
    @Environment(\.safeAreaInsets) private var safeAreaInsets

    var body: some View {
        ZStack {
            Image(Images.Background.rawValue)
                .resizable()
                .ignoresSafeArea()
            VStack(spacing: 0) {
                header.padding(.top, safeAreaInsets.top)
                    .ignoresSafeArea()
                toggles
                buttons
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
    }
}

#Preview {
    SettingsView(source: Source())
}

extension SettingsView {
    private var header: some View {
        VStack(spacing: 16) {
            Text("Settings")
                .multilineTextAlignment(.center)
                .font(.largeTitle.weight(.bold))
                .foregroundColor(.white)
                .frame(height: 44)
            Text("Customize the game to\nyour liking")
                .multilineTextAlignment(.center)
                .font(.body)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 52)
        .background(
            Image(Images.HomeHeaderView.rawValue)
                .resizable()
                .ignoresSafeArea()
        )
    }
    
    private var toggles: some View {
        HStack {
            HStack(spacing: 28) {
                Text("Music")
                    .font(.title)
                    .foregroundColor(.white)
                Toggle("", isOn: $source.withMusic)
                    .labelsHidden()
                    .toggleStyle(ColoredToggleStyle(onColor: .c10547143, offColor: .white.opacity(0.4)))
                    //.toggleStyle(SwitchToggleStyle(tint: Color.c10547143))
            }
            .padding(.trailing, 16)
            
            HStack(spacing: 28) {
                Text("Effects")
                    .lineLimit(1)
                    .font(.title)
                    .foregroundColor(.white)
                Toggle("", isOn: $source.withEffects)
                    .labelsHidden()
                    .toggleStyle(ColoredToggleStyle(onColor: .c10547143, offColor: .white.opacity(0.4)))
            }
            .padding(.trailing, 16)
        }
        .padding(.bottom, 52)
    }
    
    private var buttons: some View {
        VStack(spacing: 16) {
            Button {
                
                actionSheet()
            } label: {
                Text("Share app")
                    .font(.title3)
                    .foregroundColor(.c10547143)
                    .padding(20)
                    .frame(maxWidth: .infinity)
                    .background(Color.cSecondary)
                    .clipShape(.rect(cornerRadius: 12))
                    .shadow(color: .black.opacity(0.25), radius: 16, y: 4)
            }
            Button {
                SKStoreReviewController.requestReviewInCurrentScene()
            } label: {
                Text("Rate Us")
                    .font(.title3)
                    .foregroundColor(.c10547143)
                    .padding(20)
                    .frame(maxWidth: .infinity)
                    .background(Color.cSecondary)
                    .clipShape(.rect(cornerRadius: 12))
                    .shadow(color: .black.opacity(0.25), radius: 16, y: 4)
            }
            Button {
                if let url = URL(string: "https://www.termsfeed.com/live/93c6f45f-7292-4e56-b4c7-afa0ff6af9d3") {
                    openURL(url)
                }
            } label: {
                Text("Usage Policy")
                    .font(.title3)
                    .foregroundColor(.c10547143)
                    .padding(20)
                    .frame(maxWidth: .infinity)
                    .background(Color.cSecondary)
                    .clipShape(.rect(cornerRadius: 12))
                    .shadow(color: .black.opacity(0.25), radius: 16, y: 4)
            }
        }
        .padding(.horizontal, hPadding())
    }
    
    func actionSheet() {
        guard let urlShare = URL(string: "https://apps.apple.com/us/app/lucky-moments-of-imagination/id6736483454") else { return }
        let activityVC = UIActivityViewController(activityItems: [urlShare], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
    }
}

extension SKStoreReviewController {
    public static func requestReviewInCurrentScene() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            DispatchQueue.main.async {
                requestReview(in: scene)
            }
        }
    }
}

struct ColoredToggleStyle: ToggleStyle {
    var label = ""
    var onColor = Color(UIColor.green)
    var offColor = Color(UIColor.systemGray5)
    var thumbColor = Color.white
    
    func makeBody(configuration: Self.Configuration) -> some View {
        HStack {
            Button(action: { configuration.isOn.toggle() } )
            {
                RoundedRectangle(cornerRadius: 16, style: .circular)
                    .fill(configuration.isOn ? onColor : offColor)
                    .frame(width: 50, height: 29)
                    .overlay(
                        Circle()
                            .fill(thumbColor)
                            .shadow(radius: 1, x: 0, y: 1)
                            .padding(1.5)
                            .offset(x: configuration.isOn ? 10 : -10))
                    .animation(Animation.easeInOut(duration: 0.1))
            }
        }
        .font(.title)
    }
}

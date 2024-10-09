import SwiftUI

struct HandThePhoneView: View {
    let player: Player
    let action: () -> Void
    
    var body: some View {
        ZStack {
            Image(Images.Background.rawValue)
                .resizable()
                .ignoresSafeArea()
            VStack(spacing: 29) {
                Text("That's great! Now hand the phone to the player named \(player.name).")
                    .multilineTextAlignment(.center)
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(.white)
                Button {
                    action()
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "hand.raised.fill")
                            .font(.system(size: 24, weight: .regular))
                            .foregroundColor(.white)
                        Text("I'm here")
                            .font(.custom("Rubik", size: 14).weight(.medium))
                            .foregroundColor(.white)
                    }
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .background(LinearGradient(colors: [.orangeGradient1, .orangeGradient2], startPoint: .top, endPoint: .bottom))
                    .clipShape(.rect(cornerRadius: 10))
                }
            }
            .padding(.horizontal, hPadding())
        }
    }
}

#Preview {
    HandThePhoneView(player: Player(id: 0, imageTitle: "Player1Image", name: "Noob"), action: {})
}

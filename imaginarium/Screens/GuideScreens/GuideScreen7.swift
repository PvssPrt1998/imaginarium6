import SwiftUI

struct GuideScreen7: View {
    
    @EnvironmentObject var gameController: GameController
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        ZStack {
            Image(Images.Background.rawValue)
                .resizable()
                .ignoresSafeArea()
            Button {
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Image(systemName: "arrow.left")
                    .font(.system(size: 24, weight: .regular))
                    .foregroundColor(.white)
            }
            .padding(EdgeInsets(top: 48, leading: 28, bottom: 0, trailing: 28))
            .frame(maxWidth: .infinity, maxHeight: .infinity ,alignment: .topLeading)
            VStack(spacing: 20) {
                VStack(spacing: 10) {
                    HStack {
                        Text("1.\n")
                            .font(.title3.weight(.semibold))
                            .foregroundColor(.white)
                        Text("If everyone has guessed the presenter's card:")
                            .multilineTextAlignment(.leading)
                            .font(.title3.weight(.semibold))
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Presenter : 0 points\nEveryone else gets: + 3 points")
                        .multilineTextAlignment(.leading)
                        .font(.body)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                VStack(spacing: 10) {
                    HStack {
                        Text("2.\n")
                            .font(.title3.weight(.semibold))
                            .foregroundColor(.white)
                        Text("If no one guessed the card of the\npresenter:")
                            .multilineTextAlignment(.leading)
                            .font(.title3.weight(.semibold))
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Presenter : 0 points\nPoints are distributed to the cards of those\nplayers who were chosen: +1 point for each\nplayer who voted.")
                        .multilineTextAlignment(.leading)
                        .font(.body)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                VStack(spacing: 10) {
                    HStack {
                        Text("3.\n")
                            .font(.title3.weight(.semibold))
                            .foregroundColor(.white)
                        Text("If 1 or 2 players guessed the host's\ncard:")
                            .multilineTextAlignment(.leading)
                            .font(.title3.weight(.semibold))
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Presenter + 3 points\nPoints are allocated to the cards of those\nplayers who were chosen: +1 point for each\nplayer who voted.")
                        .multilineTextAlignment(.leading)
                        .font(.body)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                Button {
                    withAnimation {
                        gameController.isGame = true
                    }
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "checkmark")
                            .font(.system(size: 24, weight: .regular))
                            .foregroundColor(.c10547143)
                        Text("Okey")
                            .font(.custom("Rubik", size: 14).weight(.medium))
                            .foregroundColor(.c10547143)
                    }
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .clipShape(.rect(cornerRadius: 10))
                }
            }
            .padding(.horizontal, hPadding())
        }
        .navigationBarBackButtonHidden(true)
    }
   
}

#Preview {
    GuideScreen7()
}

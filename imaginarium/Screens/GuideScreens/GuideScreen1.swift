import SwiftUI

struct GuideScreen1: View {
    
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
            VStack(spacing: 35) {
                VStack(spacing: 10) {
                    Text("Let's get trained")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                    Text("We highly recommend that you go through\nthe tutorial before you start playing so you\ncan get the hang of it faster.")
                        .multilineTextAlignment(.center)
                        .font(.body)
                        .foregroundColor(.white)
                }
                
                VStack(spacing: 15) {
                    Button {
                        withAnimation {
                            gameController.isGame = true
                        }
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "xmark")
                                .font(.system(size: 24, weight: .regular))
                                .foregroundColor(.white)
                            Text("We know how to play")
                                .font(.custom("Rubik", size: 14).weight(.medium))
                                .foregroundColor(.white)
                        }
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background(LinearGradient(colors: [.orangeGradient1, .orangeGradient2], startPoint: .top, endPoint: .bottom))
                        .clipShape(.rect(cornerRadius: 10))
                    }
                    
                    NavigationLink {
                        GuideScreen2()
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "checkmark")
                                .font(.system(size: 24, weight: .regular))
                                .foregroundColor(.white)
                            Text("Educate us")
                                .font(.custom("Rubik", size: 14).weight(.medium))
                                .foregroundColor(.white)
                        }
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background(LinearGradient(colors: [.orangeGradient1, .orangeGradient2], startPoint: .top, endPoint: .bottom))
                        .clipShape(.rect(cornerRadius: 10))
                    }
                }
            }
            .padding(.horizontal, hPadding())
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    GuideScreen1()
}

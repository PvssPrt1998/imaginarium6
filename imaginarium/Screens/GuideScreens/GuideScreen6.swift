
import SwiftUI

struct GuideScreen6: View {
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
            VStack(spacing: 10) {
                Text("How do you win?")
                    .multilineTextAlignment(.center)
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                Text("Remember how points are distributed in our\ngame. Or take a screenshot to keep you up\nto date.\n\nBut you don't have to worry about counting\npoints, we take care of it! Have fun and relax.")
                    .multilineTextAlignment(.center)
                    .font(.body)
                    .foregroundColor(.white)
                NavigationLink {
                    GuideScreen7()
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "checkmark")
                            .font(.system(size: 24, weight: .regular))
                            .foregroundColor(.white)
                        Text("Okey")
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
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    GuideScreen6()
}

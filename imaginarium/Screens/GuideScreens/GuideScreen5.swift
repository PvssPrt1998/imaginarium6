
import SwiftUI

struct GuideScreen5: View {
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
                Text("Guessing the host's\ncard")
                    .multilineTextAlignment(.center)
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                Text("Now, as you have understood, we need to\nguess which of these cards belongs to the\nhost. Do not choose your own card when\nvoting (because it certainly can't be the\nleader's card).\n\nThe host does not take part in the voting and\ndoes not prompt.")
                    .multilineTextAlignment(.center)
                    .font(.body)
                    .foregroundColor(.white)
                NavigationLink {
                    GuideScreen6()
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
    GuideScreen5()
}

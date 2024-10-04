

import SwiftUI

struct GuideScreen2: View {
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
                Text("A few general rules")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                Text("On each turn, one player plays the role of the\nhost who sets the association, and that role\npasses from one to the next according to\nyour list of added players")
                    .multilineTextAlignment(.center)
                    .font(.body)
                    .foregroundColor(.white)
                NavigationLink {
                    GuideScreen3()
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
    GuideScreen2()
}

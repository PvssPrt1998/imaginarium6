import SwiftUI

struct LoadingView: View {
    
    @State var offset = UIScreen.main.bounds.height * 3
    @Binding var hide: Bool
    
    var body: some View {
        ZStack {
            Color.loading.ignoresSafeArea()
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 284)
                .padding(.bottom, 154)
            VStack(spacing: 0) {
                Image("Loading")
                    .resizable()
                    .scaledToFit()
                    .ignoresSafeArea()
                    .overlay(
                        VStack(spacing: 0) {
                            Image(Images.Player1Image.rawValue)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 103, height: 97)
                                .padding(.leading, 53)
                                .padding(.top, 120)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Image(Images.Player2Image.rawValue)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 103, height: 97)
                                .padding(.trailing, 53)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    )
                Color.white.ignoresSafeArea()
                    .overlay(
                        VStack(spacing: 30) {
                            Image(Images.Player3Image.rawValue)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 103, height: 97)
                                .padding(.leading, 70)
                                .padding(.top, 120)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Image(Images.Player4Image.rawValue)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 103, height: 97)
                                .padding(.trailing, 70)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        ,alignment: .top
                    )
            }
            .frame(height: UIScreen.main.bounds.height * 3)
            .offset(y: offset)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(.linear(duration: 1.5)) {
                    self.offset = 0
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    hide = true
                }
            }
        }
    }
}

struct LoadingView_Preview: PreviewProvider {
    
    @State static var hide = true
    
    static var previews: some View {
        LoadingView(hide: $hide)
    }
    
}

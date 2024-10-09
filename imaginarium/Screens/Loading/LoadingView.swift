import SwiftUI

struct LoadingView: View {
    
    @State var offset = UIScreen.main.bounds.height * 3
    @Binding var hide: Bool
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.loadingBg1, .loadingBg2], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            //Color.loading.ignoresSafeArea()
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 284)
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
                    .frame(maxHeight: .infinity, alignment: .top)
                    .frame(height: UIScreen.main.bounds.height * 3)
                    .offset(y: offset)
            
            VStack(spacing: -1) {
                Image("Loading")
                    .resizable()
                    .scaledToFit()
                    .ignoresSafeArea()
                    .hidden()
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
                withAnimation(.linear(duration: 3)) {
                    self.offset = -UIScreen.main.bounds.height
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
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


struct CustomShape: Shape {
    
    func path(in rect: CGRect) -> Path {
        
        return Path { path in
            //Top left
            path.move(to: CGPoint(x: 0, y: 0))
            //Left vertical bound
            path.addLine(to: CGPoint(x: 0, y: 300))
            //Curve
            path.addCurve(to: CGPoint(x: 430, y: 200), control1: CGPoint(x: 175, y: 350), control2: CGPoint(x: 250, y: 80))
            //Right vertical bound
            path.addLine(to: CGPoint(x: 450, y: 0))
        }
        
    }
}

struct DrawingPaths: View {
    var body: some View {
        Path { path in
            //Top left
            path.move(to: CGPoint(x: 0, y: 0))
            //Left vertical bound
            path.addLine(to: CGPoint(x: 0, y: 300))
            //Curve
            path.addCurve(to: CGPoint(x: 430, y: 200), control1: CGPoint(x: 175, y: 350), control2: CGPoint(x: 250, y: 80))
            //Right vertical bound
            path.addLine(to: CGPoint(x: 450, y: 0))
        }
        .fill(.white)
        .ignoresSafeArea()
    }
}


import SwiftUI

struct DrawingPaths1: View {
    var body: some View {
        Path { path in
            //Top left
            path.move(to: CGPoint(x: 0, y: 0))
            //Left vertical bound
            path.addLine(to: CGPoint(x: 0, y: UIScreen.main.bounds.width))
            //Curve
            path.addCurve(to: CGPoint(x: 430, y: 200), control1: CGPoint(x: 175, y: 350), control2: CGPoint(x: 250, y: 80))
            //Right vertical bound
            path.addLine(to: CGPoint(x: 450, y: 0))
        }
        .fill(.blue)
        .ignoresSafeArea()
        
    }
}

#Preview {
    DrawingPaths1()
}

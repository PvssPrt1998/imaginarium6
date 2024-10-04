import SwiftUI

extension View {
    func hPadding() -> CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? 52 : 16
    }
}

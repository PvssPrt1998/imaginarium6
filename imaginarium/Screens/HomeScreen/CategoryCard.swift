import SwiftUI

struct CategoryCard: View {
    
    let title: String
    let subtitle: String
    let selected: Bool
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 5) {
                Text(title)
                    .font(.title.weight(.bold))
                    .foregroundColor(.white.opacity(0.8))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(subtitle)
                    .font(.callout.weight(.regular))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Button {
                action()
            } label: {
                Text(selected ? "Selected" : "Select")
                    .font(.custom("Rubik", size: 14).weight(.medium))
                    .foregroundColor(selected ? .white : .c10690224)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .frame(height: 44)
                    .background(buttonBackground())
                    .clipShape(.rect(cornerRadius: 10))
            }
            .disabled(title == "The world of gaming")
            .opacity(title == "The world of gaming" ? 0.5 : 1)
        }
        .padding(EdgeInsets(top: 25, leading: 20, bottom: 25, trailing: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(lineWidth: selected ? 5 : 0)
                .fill(LinearGradient(colors: [.orangeGradient1, .orangeGradient2], startPoint: .top, endPoint: .bottom))
        )
        .background(Color.white.opacity(0.33))
        .clipShape(.rect(cornerRadius: 20))
    }
    
    @ViewBuilder func buttonBackground() -> some View {
        if selected {
            LinearGradient(colors: [.orangeGradient1, .orangeGradient2], startPoint: .top, endPoint: .bottom)
        } else {
            Color.white
        }
    }
}

#Preview {
    CategoryCard(title: "The world of gaming", subtitle: "Magical illustrations that will remind you\nhow beautiful the world of gaming is",selected: false, action: {})
        .background(Color.gray)
}

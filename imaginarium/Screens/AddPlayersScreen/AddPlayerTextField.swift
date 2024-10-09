import SwiftUI

struct AddPlayerTextField: View {
    
    @Binding var text: String
    
    let placeholder: String
    var trailingPadding: CGFloat = 0
    
    var body: some View {
        TextField("", text: $text)
            .font(.callout)
            .foregroundColor(.c10547143)
            .autocorrectionDisabled(true)
            .background(
                placeholderView()
            )
            .padding(EdgeInsets(top: 16, leading: 12, bottom: 16, trailing: 12))
            .background(Color.cSecondary)
            .clipShape(.rect(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(LinearGradient(colors: [.orangeGradient1, .orangeGradient2], startPoint: .top, endPoint: .bottom), lineWidth: 1)
            )
    }
    
    @ViewBuilder func placeholderView() -> some View {
        Text(text != "" ? "" : placeholder)
            .font(.callout)
            .foregroundColor(Color.white.opacity(0.62))
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct TextFieldCustom_Preview: PreviewProvider {
    
    @State static var text = ""
    
    static var previews: some View {
        AddPlayerTextField(text: $text, placeholder: "Title")
            .padding()
            .background(Color.black)
            .frame(height: 200)
    }
}

import SwiftUI

struct PlaceholderModifier: ViewModifier {
    var showPlaceholder: Bool
    var placeholder: String
    var placeholderColor: Color

    func body(content: Content) -> some View {
        ZStack(alignment: .leading) {
            if showPlaceholder {
                Text(placeholder)
                    .foregroundColor(placeholderColor)
            }
            content
                .foregroundColor(.white)
        }
    }
}

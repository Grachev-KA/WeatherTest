import SwiftUI

extension View {
    func placeholder(when shouldShow: Bool, placeholder: String, color: Color) -> some View {
        self.modifier(PlaceholderModifier(showPlaceholder: shouldShow, placeholder: placeholder, placeholderColor: color))
    }
}

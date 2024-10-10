import SwiftUI

struct WeatherAdviceView: View {
    let advice: String

    var body: some View {
        VStack(spacing: 30) {
            Text(advice)
                .font(.system(size: 20, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .padding(.top, 20)
        }
    }
}

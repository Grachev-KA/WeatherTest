import SwiftUI

struct WeatherIconView: View {
    let icon: String
    @State private var overlayOpacity: Double = 1.0

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white.opacity(0.2))
                .frame(maxWidth: 150, maxHeight: 150)

            Image(systemName: icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 100, maxHeight: 100)
                .foregroundColor(.white.opacity(0.7))

            Circle()
                .fill(Color.white)
                .frame(maxWidth: 150, maxHeight: 150)
                .opacity(overlayOpacity)
                .animation(.easeInOut(duration: 1.0), value: overlayOpacity)
        }
        .onAppear {
            withAnimation {
                overlayOpacity = 0.2
            }
        }
        .onChange(of: icon) { _ in
            withAnimation {
                overlayOpacity = 1.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation {
                    overlayOpacity = 0.2
                }
            }
        }
    }
}

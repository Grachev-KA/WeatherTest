import SwiftUI

struct WeatherNoContentView: View {
    var body: some View {
        VStack(spacing: 30) {
            Text("No Weather Data")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .padding(.top, 60)

            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(maxWidth: 150, maxHeight: 150)

                Image(systemName: "cloud.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 100, maxHeight: 100)
                    .foregroundColor(.white.opacity(0.7))
            }

            Text("Please enter a city or enable location services to get the weather forecast.")
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            .padding(.top, 20)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
    }
}

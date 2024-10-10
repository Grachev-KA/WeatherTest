import SwiftUI

struct ForecastNoContentView: View {
    var body: some View {
        VStack(spacing: 30) {
            Text("No Forecast Data")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .padding(.top, 60)

            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(maxWidth: 200, maxHeight: 200)

                Image(systemName: "calendar")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 120)
                    .foregroundColor(.white.opacity(0.7))
            }

            Text("Please enter a city or enable location services to get the weather forecast for upcoming days.")
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

import SwiftUI

struct WeatherAppNameView: View {
    var body: some View {
        Text("Weather Forecast")
            .font(.system(size: 28, weight: .bold, design: .rounded))
            .foregroundColor(.white)
            .padding(.top, 10)
    }
}

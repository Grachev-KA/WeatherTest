import SwiftUI

struct WeatherCityView: View {
    let cityName: String

    var body: some View {
        Text(cityName)
            .font(.system(size: 25, weight: .bold, design: .rounded))
            .foregroundColor(.white)
            .padding(.top, 10)
    }
}

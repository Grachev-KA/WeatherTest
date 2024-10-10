import SwiftUI

struct WeatherEnterCityView: View {
    @Binding var cityName: String
    @Binding var isEditing: Bool
    var fetchWeatherAction: () -> Void

    var body: some View {
        VStack {
            HStack(spacing: 10) {
                TextField("", text: $cityName, onEditingChanged: { isEditing in
                    self.isEditing = isEditing
                })
                .padding()
                .background(Color.white.opacity(0.2))
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white, lineWidth: 1))
                .frame(height: 50)
                .modifier(PlaceholderModifier(showPlaceholder: cityName.isEmpty && !isEditing, placeholder: "   Enter city", placeholderColor: .white))

                Button(action: fetchWeatherAction) {
                    Text("Get Weather")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

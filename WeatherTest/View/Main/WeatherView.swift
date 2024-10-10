import SwiftUI

struct WeatherView: View {
    @ObservedObject var viewModel: WeatherViewModel
    @State private var cityName: String = ""
    @State private var isEditing: Bool = false

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .white]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    UIApplication.shared.hideKeyboard()
                }

            VStack(spacing: 20) {
                WeatherAppNameView()

                WeatherEnterCityView(cityName: $cityName, isEditing: $isEditing) {
                    viewModel.fetchWeatherForCity(city: cityName)
                    cityName = ""
                    UIApplication.shared.hideKeyboard()
                }

                if viewModel.weather != nil {
                    VStack(spacing: 10) {
                        WeatherCityView(cityName: viewModel.cityName)
                        WeatherTemperatureView(temperature: viewModel.temperature)
                        WeatherIconView(icon: viewModel.weatherIcon)
                        WeatherAdviceView(advice: viewModel.advice)
                    }
                    .padding(.top, 30)
                } else {
                    WeatherNoContentView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }

                Spacer()
            }
            .padding(.bottom, 60)
        }
        .onAppear {
            viewModel.loadCurrentCity()
        }
    }
}

import Foundation

final class CustomTabBarViewModel: ObservableObject {
    let weatherViewModel: WeatherViewModel
    let forecastViewModel: ForecastViewModel

    init(weatherNetworkManager: WeatherNetworkManagerProtocol,
         forecastNetworkManager: ForecastNetworkManagerProtocol,
         coreDataManager: CoreDataManagerProtocol,
         userDefaultsService: UserDefaultsManager) {
        
        self.weatherViewModel = WeatherViewModel(
            weatherNetworkManager: weatherNetworkManager,
            coreDataManager: coreDataManager,
            userDefaultsManager: userDefaultsService
        )

        self.forecastViewModel = ForecastViewModel(
            forecastNetworkManager: forecastNetworkManager,
            coreDataManager: coreDataManager,
            userDefaultsService: userDefaultsService
        )
    }
}

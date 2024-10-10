import SwiftUI

struct ContentView: View {
    let weatherNetworkManager = WeatherNetwork()
    let forecastNetworkManager = ForecastNetwork()
    let coreDataManager = CoreDataManager()
    let userDefaultsService = UserDefaultsManager()
    
    var body: some View {
        let customTabBarViewModel = CustomTabBarViewModel(
            weatherNetworkManager: weatherNetworkManager,
            forecastNetworkManager: forecastNetworkManager,
            coreDataManager: coreDataManager,
            userDefaultsService: userDefaultsService
        )
        
        CustomTabBarView(viewModel: customTabBarViewModel)
    }
}

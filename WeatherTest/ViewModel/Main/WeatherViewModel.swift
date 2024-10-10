import Foundation
import CoreLocation
import Combine

final class WeatherViewModel: NSObject, ObservableObject {
    @Published var weather: WeatherModel?
    @Published var cityName: String = "Unknown City"
    @Published var temperature: Double = 0.0
    @Published var weatherIcon: String = "cloud.fill"
    @Published var advice: String = "Weather is unknown"
    
    private let weatherNetworkManager: WeatherNetworkManagerProtocol
    private let coreDataManager: CoreDataManagerProtocol
    private let userDefaultsManager: UserDefaultsManager
    private let locationManager = CLLocationManager()

    init(weatherNetworkManager: WeatherNetworkManagerProtocol, coreDataManager: CoreDataManagerProtocol, userDefaultsManager: UserDefaultsManager) {
        self.weatherNetworkManager = weatherNetworkManager
        self.coreDataManager = coreDataManager
        self.userDefaultsManager = userDefaultsManager
        super.init()
        initialCurrentCity()
        locationManager.delegate = self
        requestLocationAccess()
    }

    func loadCurrentCity() {
        if let savedCity = loadCurrentCityFromUserDefaults() {
            fetchWeatherForCity(city: savedCity)
        } else {
            fetchWeatherForCurrentLocation()
        }
    }

    func fetchWeatherForCity(city: String) {
        let trimmedCityName = city.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedCityName.isEmpty else {
            return
        }
        
        loadWeatherFromCoreData(city: trimmedCityName) { [weak self] in
            self?.fetchWeatherFromNetwork(city: trimmedCityName)
        }
    }

    func fetchWeatherForCurrentLocation() {
        locationManager.requestLocation()
    }

    private func fetchWeatherForLocation(lat: Double, lon: Double) {
        weatherNetworkManager.fetchWeatherForLocation(lat: lat, lon: lon) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let weather):
                    self?.saveCurrentCityToUserDefaults(city: weather.cityName)
                    self?.saveWeatherToCoreData(weather: weather)
                    self?.updateUI(with: weather)
                case .failure(let error):
                    print("GPS network error: \(error.localizedDescription)")
                }
            }
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension WeatherViewModel: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        case .denied, .restricted:
            print("Location access denied.")
        case .notDetermined:
            requestLocationAccess()
        @unknown default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            fetchWeatherForLocation(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
            locationManager.stopUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }
}

// MARK: - Private Methods

private extension WeatherViewModel {
    func requestLocationAccess() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func fetchWeatherFromNetwork(city: String) {
        weatherNetworkManager.fetchWeatherForCity(city: city) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let weather):
                    self?.saveCurrentCityToUserDefaults(city: weather.cityName)
                    self?.saveWeatherToCoreData(weather: weather)
                    self?.updateUI(with: weather)
                case .failure(let error):
                    print("Network error: \(error.localizedDescription)")
                }
            }
        }
    }

    func loadWeatherFromCoreData(city: String, completion: @escaping () -> Void) {
        coreDataManager.fetchWeatherForCity(city) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let weather):
                    self?.updateUI(with: weather)
                case .failure(let error):
                    print("CoreData error: \(error.localizedDescription)")
                }
                completion()
            }
        }
    }

    func updateUI(with weather: WeatherModel) {
        self.weather = weather
        self.cityName = weather.cityName
        self.temperature = weather.temperature
        self.weatherIcon = WeatherIconManager.getWeatherIcon(for: weather.iconCode)
        self.advice = WeatherAdviceManager.getWeatherAdvice(for: weather.temperature)
    }

    func saveWeatherToCoreData(weather: WeatherModel) {
        coreDataManager.saveCityWithForecasts(
            weather.cityName,
            forecasts: [(temperature: weather.temperature, weatherIcon: weather.iconCode, forecastDate: Date())]
        ) { result in
            if case let .failure(error) = result {
                print("CoreData save error: \(error.localizedDescription)")
            }
        }
    }

    func saveCurrentCityToUserDefaults(city: String) {
        userDefaultsManager.save(city, forKey: "currentCity")
    }

    func loadCurrentCityFromUserDefaults() -> String? {
        return userDefaultsManager.load(forKey: "currentCity", as: String.self)
    }
    
    func initialCurrentCity() {
        cityName = loadCurrentCityFromUserDefaults() ?? "Unknown City"
    }
}

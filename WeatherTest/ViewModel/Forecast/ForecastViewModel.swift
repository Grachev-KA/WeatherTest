import Foundation
import Combine

final class ForecastViewModel: ObservableObject {
    @Published var dailyForecasts: [ForecastModel] = [] {
        didSet {
            dailyForecastsGrouped = formattingService.groupedForecastsByDate(dailyForecasts: dailyForecasts)
        }
    }
    @Published var dailyForecastsGrouped: [DailyForecastModel] = []

    private let forecastNetworkManager: ForecastNetworkManagerProtocol
    private let coreDataManager: CoreDataManagerProtocol
    private let userDefaultsService: UserDefaultsManager
    private let formattingService: ForecastFormattingManager

    init(forecastNetworkManager: ForecastNetworkManagerProtocol, coreDataManager: CoreDataManagerProtocol, userDefaultsService: UserDefaultsManager, formattingService: ForecastFormattingManager = ForecastFormattingManager()) {
        self.forecastNetworkManager = forecastNetworkManager
        self.coreDataManager = coreDataManager
        self.userDefaultsService = userDefaultsService
        self.formattingService = formattingService
        deleteOldForecasts()
    }

    func loadCurrentCityAndFetchForecast() {
        if let currentCity = loadCurrentCityFromUserDefaults() {
            fetchForecastsFromCoreData(for: currentCity) { [weak self] in
                self?.fetchForecastForCity(city: currentCity)
            }
        } else {
            print("No current city found.")
        }
    }

    func fetchForecastForCity(city: String) {
        forecastNetworkManager.fetchForecastForCity(city: city) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let forecasts):
                    self?.saveForecastsToCoreData(city: city, forecasts: forecasts)
                    self?.fetchForecastsFromCoreData(for: city) { }
                    self?.saveCurrentCityToUserDefaults(city: city)
                case .failure(let error):
                    print("Error fetching forecasts: \(error.localizedDescription)")
                }
            }
        }
    }

    func formattedDate(for date: Date) -> String {
        return formattingService.formattedDate(date)
    }

    func saveCurrentCityToUserDefaults(city: String) {
        userDefaultsService.save(city, forKey: "currentCity")
    }

    func loadCurrentCityFromUserDefaults() -> String? {
        return userDefaultsService.load(forKey: "currentCity", as: String.self)
    }
}

private extension ForecastViewModel {
    func deleteOldForecasts() {
        coreDataManager.deleteOldForecasts { result in
            switch result {
            case .success():
                print("Old forecasts successfully deleted.")
            case .failure(let error):
                print("Failed to delete old forecasts: \(error.localizedDescription)")
            }
        }
    }

    func saveForecastsToCoreData(city: String, forecasts: [ForecastModel]) {
        let forecastData = forecasts.map { forecast in
            (temperature: forecast.temperature, weatherIcon: forecast.iconCode, forecastDate: forecast.date)
        }
        coreDataManager.saveCityWithForecasts(city, forecasts: forecastData) { result in
            if case let .failure(error) = result {
                print("Error saving forecasts: \(error.localizedDescription)")
            }
        }
    }

    func fetchForecastsFromCoreData(for city: String, completion: @escaping () -> Void) {
        coreDataManager.fetchForecastsForCity(city) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let forecastEntities):
                    let forecasts = forecastEntities.map { entity in
                        ForecastModel(date: entity.forecastDate ?? Date(), temperature: entity.temperature, iconCode: entity.weatherIcon ?? "")
                    }
                    self?.dailyForecasts = forecasts
                case .failure(let error):
                    print("Error fetching forecasts from Core Data: \(error.localizedDescription)")
                }
                completion()
            }
        }
    }
}

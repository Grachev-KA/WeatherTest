import CoreData
import Foundation

enum CoreDataManagerError: Error {
    case initializationError(Error)
    case saveError(Error)
    case fetchError(Error)
    case deleteError(Error)
}

protocol CoreDataManagerProtocol {
    func saveCityWithForecasts(
        _ cityName: String,
        forecasts: [(temperature: Double, weatherIcon: String, forecastDate: Date)],
        completion: @escaping (Result<Void, CoreDataManagerError>) -> Void
    )
    
    func fetchForecastsForCity(
        _ cityName: String,
        completion: @escaping (Result<[ForecastEntity], CoreDataManagerError>) -> Void
    )

    func fetchWeatherForCity(
        _ cityName: String,
        completion: @escaping (Result<WeatherModel, CoreDataManagerError>) -> Void
    )

    func deleteOldForecasts(
        completion: @escaping (Result<Void, CoreDataManagerError>) -> Void
    )
}

final class CoreDataManager: CoreDataManagerProtocol {
    private let persistentContainer: NSPersistentContainer

    init(containerName: String = "CoreDataModel") {
        persistentContainer = NSPersistentContainer(name: containerName)
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
    }

    func saveCityWithForecasts(
        _ cityName: String,
        forecasts: [(temperature: Double, weatherIcon: String, forecastDate: Date)],
        completion: @escaping (Result<Void, CoreDataManagerError>) -> Void
    ) {
        let context = persistentContainer.viewContext
        context.perform {
            do {
                let cityFetchRequest: NSFetchRequest<CityEntity> = CityEntity.fetchRequest()
                cityFetchRequest.predicate = NSPredicate(format: "cityName == %@", cityName)
                
                let city: CityEntity
                if let existingCity = try context.fetch(cityFetchRequest).first {
                    city = existingCity
                } else {
                    city = CityEntity(context: context)
                    city.cityName = cityName
                }
                
                for forecastData in forecasts {
                    let forecast = ForecastEntity(context: context)
                    forecast.temperature = forecastData.temperature
                    forecast.weatherIcon = forecastData.weatherIcon
                    forecast.forecastDate = forecastData.forecastDate
                    forecast.city = city
                    city.addToForecasts(forecast)
                }
                
                try context.save()
                completion(.success(()))
            } catch {
                completion(.failure(.saveError(error)))
            }
        }
    }

    func fetchForecastsForCity(
        _ cityName: String,
        completion: @escaping (Result<[ForecastEntity], CoreDataManagerError>) -> Void
    ) {
        let context = persistentContainer.viewContext
        context.perform {
            do {
                let fetchRequest: NSFetchRequest<CityEntity> = CityEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "cityName == %@", cityName)
                
                if let city = try context.fetch(fetchRequest).first,
                   let forecasts = city.forecasts?.allObjects as? [ForecastEntity] {
                    completion(.success(forecasts))
                } else {
                    completion(.success([]))
                }
            } catch {
                completion(.failure(.fetchError(error)))
            }
        }
    }

    func fetchWeatherForCity(
        _ cityName: String,
        completion: @escaping (Result<WeatherModel, CoreDataManagerError>) -> Void
    ) {
        let context = persistentContainer.viewContext
        let currentDate = Date()
        context.perform {
            do {
                let fetchRequest: NSFetchRequest<CityEntity> = CityEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "cityName == %@", cityName)
                
                if let city = try context.fetch(fetchRequest).first,
                   let forecasts = city.forecasts?.allObjects as? [ForecastEntity] {
                    let futureForecasts = forecasts.filter { $0.forecastDate ?? Date() >= currentDate }
                    if let nearestForecast = futureForecasts.min(by: { $0.forecastDate ?? Date() < $1.forecastDate ?? Date() }) {
                        let weatherModel = WeatherModel(
                            cityName: city.cityName ?? "Unknown",
                            temperature: nearestForecast.temperature,
                            description: "Clear",
                            iconCode: nearestForecast.weatherIcon ?? "cloud.fill"
                        )
                        completion(.success(weatherModel))
                    } else {
                        completion(.failure(.fetchError(NSError(domain: "CoreData", code: 404, userInfo: [NSLocalizedDescriptionKey: "No future forecasts found"]))))
                    }
                } else {
                    completion(.failure(.fetchError(NSError(domain: "CoreData", code: 404, userInfo: [NSLocalizedDescriptionKey: "City not found"]))))
                }
            } catch {
                completion(.failure(.fetchError(error)))
            }
        }
    }

    func deleteOldForecasts(
        completion: @escaping (Result<Void, CoreDataManagerError>) -> Void
    ) {
        let context = persistentContainer.viewContext
        let currentDate = Calendar.current.startOfDay(for: Date())
        guard let dayBeforeYesterday = Calendar.current.date(byAdding: .day, value: -2, to: currentDate) else {
            completion(.failure(.deleteError(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to calculate the date for day before yesterday"]))))
            return
        }

        context.perform {
            do {
                let fetchRequest: NSFetchRequest<ForecastEntity> = ForecastEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "forecastDate < %@", dayBeforeYesterday as NSDate)
                
                let oldForecasts = try context.fetch(fetchRequest)
                for forecast in oldForecasts {
                    context.delete(forecast)
                }
                
                try context.save()
                completion(.success(()))
            } catch {
                completion(.failure(.deleteError(error)))
            }
        }
    }
}

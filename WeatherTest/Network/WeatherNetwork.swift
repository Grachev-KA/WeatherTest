import Foundation
import CoreLocation

enum WeatherNetworkError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case networkError(Error)
    case decodingError(Error)
}

protocol WeatherNetworkManagerProtocol {
    func fetchWeatherForLocation(lat: Double, lon: Double, completion: @escaping (Result<WeatherModel, WeatherNetworkError>) -> Void)
    func fetchWeatherForCity(city: String, completion: @escaping (Result<WeatherModel, WeatherNetworkError>) -> Void)
}

final class WeatherNetwork: NSObject, WeatherNetworkManagerProtocol {
    private let session: URLSession
    private let decoder: JSONDecoder
    private let geocoder = CLGeocoder()
    
    init(session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }
    
    func fetchWeatherForLocation(lat: Double, lon: Double, completion: @escaping (Result<WeatherModel, WeatherNetworkError>) -> Void) {
        let location = CLLocation(latitude: lat, longitude: lon)
        
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            if let _ = error {
                self?.fetchWeatherByCoordinates(lat: lat, lon: lon, completion: completion)
                return
            }
            
            if let city = placemarks?.first?.locality {
                self?.fetchWeatherForCity(city: city) { result in
                    switch result {
                    case .success(let weather):
                        completion(.success(weather))
                    case .failure(let error):
                        if case .invalidResponse = error {
                            self?.fetchWeatherByCoordinates(lat: lat, lon: lon, completion: completion)
                        } else {
                            completion(.failure(error))
                        }
                    }
                }
            } else {
                self?.fetchWeatherByCoordinates(lat: lat, lon: lon, completion: completion)
            }
        }
    }
    
    func fetchWeatherForCity(city: String, completion: @escaping (Result<WeatherModel, WeatherNetworkError>) -> Void) {
        guard let cityEncoded = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(.failure(.invalidURL))
            return
        }
        let urlString = Constants.weatherURLForCity(cityEncoded)
        performRequest(with: urlString, completion: completion)
    }
}

private extension WeatherNetwork {
    func fetchWeatherByCoordinates(lat: Double, lon: Double, completion: @escaping (Result<WeatherModel, WeatherNetworkError>) -> Void) {
        let urlString = Constants.weatherURLForLocation(lat: lat, lon: lon)
        performRequest(with: urlString, completion: completion)
    }

    func performRequest(with urlString: String, completion: @escaping (Result<WeatherModel, WeatherNetworkError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }

        session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.invalidResponse))
                return
            }

            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }

            self.decodeData(data, completion: completion)
        }.resume()
    }

    func decodeData(_ data: Data, completion: @escaping (Result<WeatherModel, WeatherNetworkError>) -> Void) {
        do {
            let weatherResponse = try decoder.decode(WeatherResponseAPI.self, from: data)
            let weather = WeatherModel(
                cityName: weatherResponse.name.isEmpty ? "Unknown Location" : weatherResponse.name,
                temperature: weatherResponse.main.temp,
                description: weatherResponse.weather.first?.description ?? "",
                iconCode: weatherResponse.weather.first?.icon ?? ""
            )
            completion(.success(weather))
        } catch {
            completion(.failure(.decodingError(error)))
        }
    }
}

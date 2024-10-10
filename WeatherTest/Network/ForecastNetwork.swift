import Foundation

enum ForecastNetworkError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case networkError(Error)
    case decodingError(Error)
}

protocol ForecastNetworkManagerProtocol {
    func fetchForecastForCity(city: String, completion: @escaping (Result<[ForecastModel], ForecastNetworkError>) -> Void)
}

final class ForecastNetwork: ForecastNetworkManagerProtocol {
    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }

    func fetchForecastForCity(city: String, completion: @escaping (Result<[ForecastModel], ForecastNetworkError>) -> Void) {
        let urlString = Constants.forecastURLForCity(city)
        performRequest(with: urlString, completion: completion)
    }
    
    func decodeData(_ data: Data, completion: @escaping (Result<[ForecastModel], ForecastNetworkError>) -> Void) {
        do {
            let forecastResponse = try decoder.decode(ForecastResponseAPI.self, from: data)
            let forecasts = forecastResponse.list.map { item -> ForecastModel in
                let date = Date(timeIntervalSince1970: TimeInterval(item.dt))
                let temperature = item.main.temp
                let iconCode = item.weather.first?.icon ?? ""

                return ForecastModel(date: date, temperature: temperature, iconCode: iconCode)
            }
            completion(.success(forecasts))
        } catch {
            completion(.failure(.decodingError(error)))
        }
    }
}

private extension ForecastNetwork {
    func performRequest(with urlString: String, completion: @escaping (Result<[ForecastModel], ForecastNetworkError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }

        session.dataTask(with: url) { [weak self] data, response, error in
            guard let self else { return }
            
            if let error  {
                completion(.failure(.networkError(error)))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.invalidResponse))
                return
            }

            guard let data else {
                completion(.failure(.invalidData))
                return
            }

            self.decodeData(data, completion: completion)
        }.resume()
    }
}

import Foundation

struct WeatherResponseAPI: Decodable {
    let name: String
    let main: Temperature
    let weather: [Info]
}

extension WeatherResponseAPI {
    struct Temperature: Codable {
        let temp: Double
    }

    struct Info: Codable {
        let description: String
        let icon: String
    }
}

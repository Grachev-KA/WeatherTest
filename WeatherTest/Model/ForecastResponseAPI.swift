import Foundation

struct ForecastResponseAPI: Codable {
    let cod: String
    let message: Int
    let cnt: Int
    let list: [Forecast]
    let city: City
}

extension ForecastResponseAPI {
    struct Forecast: Codable {
        let dt: Int
        let main: MainInfo
        let weather: [Weather]
        let dtTxt: String

        enum CodingKeys: String, CodingKey {
            case dt, main, weather
            case dtTxt = "dt_txt"
        }
    }

    struct MainInfo: Codable {
        let temp: Double
    }

    struct Weather: Codable {
        let icon: String
    }

    struct City: Codable {
        let id: Int
        let name: String
        let coord: Coordinates
        let country: String
        let population: Int
        let timezone: Int
        let sunrise: Int
        let sunset: Int
    }

    struct Coordinates: Codable {
        let lat: Double
        let lon: Double
    }
}

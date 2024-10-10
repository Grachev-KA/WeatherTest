import Foundation

struct WeatherModel: Codable {
    let cityName: String
    let temperature: Double
    let description: String
    let iconCode: String
}

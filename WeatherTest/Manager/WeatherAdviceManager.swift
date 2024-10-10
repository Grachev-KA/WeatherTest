import Foundation

final class WeatherAdviceManager {
    static func getWeatherAdvice(for temperature: Double) -> String {
        switch temperature {
        case ..<0: return "It's very cold! Dress warmly."
        case 0..<15: return "It's a bit chilly, consider wearing a jacket."
        case 15...: return "It's warm, light clothing is fine."
        default: return "Weather conditions are unknown."
        }
    }
}

import Foundation

struct ForecastModel: Identifiable {
    let id = UUID()
    let date: Date
    let temperature: Double
    let iconCode: String
}

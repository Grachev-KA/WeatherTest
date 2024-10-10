struct Constants {
    static let weatherAPIKey = "c2a2766becab895257bd0ea72ed1fdd8"
    
    static func weatherURLForLocation(lat: Double, lon: Double) -> String {
        return "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(weatherAPIKey)&units=metric"
    }
    
    static func weatherURLForCity(_ city: String) -> String {
        return "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(weatherAPIKey)&units=metric"
    }
    
    static func forecastURLForCity(_ city: String) -> String {
        return "https://api.openweathermap.org/data/2.5/forecast?q=\(city)&appid=\(weatherAPIKey)&units=metric"
    }
}

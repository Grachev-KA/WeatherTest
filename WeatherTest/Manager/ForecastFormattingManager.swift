import Foundation

final class ForecastFormattingManager {
    func groupedForecastsByDate(dailyForecasts: [ForecastModel]) -> [DailyForecastModel] {
        let today = Calendar.current.startOfDay(for: Date())
        let endDate = Calendar.current.date(byAdding: .day, value: 4, to: today)!
        
        let filteredForecasts = dailyForecasts.filter { forecast in
            let forecastDate = Calendar.current.startOfDay(for: forecast.date)
            return forecastDate >= today && forecastDate <= endDate
        }
        
        let groupedByDate = Dictionary(grouping: filteredForecasts) { forecast -> Date in
            let components = Calendar.current.dateComponents([.year, .month, .day], from: forecast.date)
            return Calendar.current.date(from: components)!
        }
        
        var dailyForecastsArray: [DailyForecastModel] = []
        
        for (date, forecasts) in groupedByDate {
            let dayForecasts = forecasts.filter { isDayTime($0.date) }
            let nightForecasts = forecasts.filter { isNightTime($0.date) }
            
            let dayIconCode = iconCodeForSpecificTime(forecasts: dayForecasts, targetHour: 12)
            let nightIconCode = iconCodeForSpecificTime(forecasts: nightForecasts, targetHour: 0)
            
            let dayMinTemp = dayForecasts.map { $0.temperature }.min()
            let dayMaxTemp = dayForecasts.map { $0.temperature }.max()
            let nightMinTemp = nightForecasts.map { $0.temperature }.min()
            let nightMaxTemp = nightForecasts.map { $0.temperature }.max()
            
            let dailyForecast = DailyForecastModel(
                date: date,
                dayMinTemp: dayMinTemp,
                dayMaxTemp: dayMaxTemp,
                dayIconCode: dayIconCode,
                nightMinTemp: nightMinTemp,
                nightMaxTemp: nightMaxTemp,
                nightIconCode: nightIconCode
            )
            
            dailyForecastsArray.append(dailyForecast)
        }
        
        dailyForecastsArray.sort { $0.date < $1.date }
        
        return dailyForecastsArray
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, EEEE"
        return formatter.string(from: date)
    }
}

private extension ForecastFormattingManager {
    func iconCodeForSpecificTime(forecasts: [ForecastModel], targetHour: Int) -> String? {
        let calendar = Calendar.current
        for forecast in forecasts {
            let hour = calendar.component(.hour, from: forecast.date)
            if hour == targetHour {
                return forecast.iconCode
            }
        }
        return forecasts.first?.iconCode
    }
    
    func isDayTime(_ date: Date) -> Bool {
        let hour = Calendar.current.component(.hour, from: date)
        return hour >= 9 && hour < 18
    }

    func isNightTime(_ date: Date) -> Bool {
        let hour = Calendar.current.component(.hour, from: date)
        return hour >= 21 || hour < 6
    }
}

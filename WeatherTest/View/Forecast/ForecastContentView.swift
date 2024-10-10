import SwiftUI

struct ForecastContentView: View {
    let dailyForecastsGrouped: [DailyForecastModel]
    let formattedDate: (Date) -> String

    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                ForEach(dailyForecastsGrouped, id: \.date) { dailyForecast in
                    VStack(spacing: 15) {
                        HStack {
                            Spacer()
                            Text(formattedDate(dailyForecast.date))
                                .font(.title2)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .padding(.bottom, 5)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }

                        HStack {
                            if let dayMinTemp = dailyForecast.dayMinTemp,
                               let dayMaxTemp = dailyForecast.dayMaxTemp,
                               let dayIconCode = dailyForecast.dayIconCode {
                                forecastDayView(minTemp: dayMinTemp, maxTemp: dayMaxTemp, iconCode: dayIconCode)
                                Spacer()
                                forecastNightView(minTemp: dailyForecast.nightMinTemp ?? 0, maxTemp: dailyForecast.nightMaxTemp ?? 0, iconCode: dailyForecast.nightIconCode ?? "moon.stars.fill")
                            } else {
                                HStack {
                                    Spacer()
                                    forecastNightView(minTemp: dailyForecast.nightMinTemp ?? 0, maxTemp: dailyForecast.nightMaxTemp ?? 0, iconCode: dailyForecast.nightIconCode ?? "moon.stars.fill")
                                }
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.white.opacity(0.2))
                                .shadow(radius: 10)
                        )
                    }
                }
            }
            .padding(.horizontal, 15)
            .padding(.bottom, 20)
        }
    }

    @ViewBuilder
    private func forecastDayView(minTemp: Double, maxTemp: Double, iconCode: String) -> some View {
        HStack {
            Image(systemName: WeatherIconManager.getWeatherIcon(for: iconCode))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
                .foregroundColor(.white)

            VStack(alignment: .leading) {
                Text("Day")
                    .font(.headline)
                    .foregroundColor(.white)

                HStack(spacing: 0) {
                    Text("min")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .frame(maxWidth: 30, alignment: .leading)

                    Text("\(Int(minTemp))°")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .frame(maxWidth: 40, alignment: .trailing)
                }
                
                HStack(spacing: 0) {
                    Text("max")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .frame(maxWidth: 30, alignment: .leading)

                    Text("\(Int(maxTemp))°")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .frame(maxWidth: 40, alignment: .trailing)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder
    private func forecastNightView(minTemp: Double, maxTemp: Double, iconCode: String) -> some View {
        HStack {
            Image(systemName: WeatherIconManager.getWeatherIcon(for: iconCode))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
                .foregroundColor(.gray)

            VStack(alignment: .leading) {
                Text("Night")
                    .font(.headline)
                    .foregroundColor(.white)

                HStack(spacing: 0) {
                    Text("min")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .frame(maxWidth: 30, alignment: .leading)

                    Text("\(Int(minTemp))°")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .frame(maxWidth: 40, alignment: .trailing)
                }
                
                HStack(spacing: 0) {
                    Text("max")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .frame(maxWidth: 30, alignment: .leading)

                    Text("\(Int(maxTemp))°")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .frame(maxWidth: 40, alignment: .trailing)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
}

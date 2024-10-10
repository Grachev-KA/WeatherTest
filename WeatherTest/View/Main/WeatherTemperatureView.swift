import SwiftUI

struct WeatherTemperatureView: View {
    let temperature: Double
    @State private var animatedTemperature: Double = 0
    @State private var timer: Timer?

    var body: some View {
        Text("\(Int(animatedTemperature))°C")
            .font(.system(size: 25, weight: .bold, design: .rounded))
            .foregroundColor(.white)
            .onAppear {
                startTemperatureAnimation(to: temperature)
            }
            .onChange(of: temperature) { newValue in
                startTemperatureAnimation(to: newValue)
            }
    }

    private func startTemperatureAnimation(to targetTemperature: Double) {
        timer?.invalidate()
        let stepCount = 20
        let timeInterval: TimeInterval = 0.03
        let step = (targetTemperature - animatedTemperature) / Double(stepCount)

        var currentStep = 0
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { timer in
            currentStep += 1
            animatedTemperature += step

            if currentStep >= stepCount || abs(animatedTemperature - targetTemperature) < 1 {
                animatedTemperature = targetTemperature
                timer.invalidate() 
            }
        }
    }
}

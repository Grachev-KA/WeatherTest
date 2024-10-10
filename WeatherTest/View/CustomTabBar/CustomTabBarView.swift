import SwiftUI

struct CustomTabBarView: View {
    @ObservedObject var viewModel: CustomTabBarViewModel
    @State private var selectedTab = 0
    @State private var isPresentingPlusView = false

    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case 0:
                    WeatherView(viewModel: viewModel.weatherViewModel)
                case 1:
                    PlusView()
                case 2:
                    ForecastView(viewModel: viewModel.forecastViewModel)
                default:
                    Text("Other")
                }
            }

            HStack {
                Spacer()

                Button(action: {
                    selectedTab = 0
                }) {
                    VStack {
                        Image(systemName: "cloud.sun.fill")
                            .font(.system(size: 25))
                        Text("Main")
                            .font(.system(size: 12))
                    }
                    .foregroundColor(selectedTab == 0 ? .blue : .gray)
                }

                Spacer()

                Button(action: {
                    selectedTab = 1
                }) {
                    ZStack {
                        Circle()
                            .foregroundColor(selectedTab == 1 ? .blue : .white)
                            .frame(width: 70, height: 70)
                            .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 5)

                        Image(systemName: "plus")
                            .font(.system(size: 30))
                            .foregroundColor(selectedTab == 1 ? .white : .blue)
                    }
                }
                .offset(y: -20)

                Spacer()

                Button(action: {
                    selectedTab = 2
                }) {
                    VStack {
                        Image(systemName: "calendar")
                            .font(.system(size: 25))
                        Text("Forecast")
                            .font(.system(size: 12))
                    }
                    .foregroundColor(selectedTab == 2 ? .blue : .gray)
                }

                Spacer()
            }
            .frame(height: 80)
            .background(Color.white.shadow(radius: 5))
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

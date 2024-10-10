import SwiftUI

struct ForecastView: View {
    @ObservedObject var viewModel: ForecastViewModel

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .white]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 10) {
                ForecastAppNameView()

                if viewModel.dailyForecastsGrouped.isEmpty {
                    ForecastNoContentView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .padding(.top, 80)
                } else {
                    ForecastContentView(dailyForecastsGrouped: viewModel.dailyForecastsGrouped) { date in
                        viewModel.formattedDate(for: date)
                    }
                }

                Spacer()
            }
            .padding(.horizontal, 15)
            .padding(.bottom, 60)
        }
        .onAppear {
            viewModel.loadCurrentCityAndFetchForecast()
        }
    }
}

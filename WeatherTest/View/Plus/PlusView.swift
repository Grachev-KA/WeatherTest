import SwiftUI

struct PlusView: View {
    @State private var hasContent: Bool = false

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .white]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                PlusAppNameView()

                if hasContent {
                    VStack(spacing: 20) {
                        Text("Plus View")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.top, 20)

                        Text("This is the Plus View screen.")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()

                        Spacer()

                        Button(action: {
                            print("Action in Plus View")
                        }) {
                            Text("Perform Action")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                                .padding(.horizontal, 20)
                        }
                    }
                } else {
                    PlusNoContentView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .padding(.top, 50)
                }

                Spacer()
            }
        }
    }
}

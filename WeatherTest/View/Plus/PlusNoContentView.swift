import SwiftUI

struct PlusNoContentView: View {
    var body: some View {
        VStack(spacing: 30) {
            Text("No Plus Content")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .padding(.top, 60)

            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(maxWidth: 200, maxHeight: 200)

                Image(systemName: "exclamationmark.triangle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 120)
                    .foregroundColor(.white.opacity(0.7))
            }

            Text("No content available. Please check again later.")
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .padding(.top, 20)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
    }
}

import SwiftUI

// MARK: - Протоколы для улучшения расширяемости

protocol ProgressDisplayable {
    var progressPercentage: Int { get }
}

protocol BackgroundProviding {
    associatedtype BackgroundContent: View
    func makeBackground() -> BackgroundContent
}

// MARK: - Современный экран загрузки

struct YourStoryLoadingOverlay: View, ProgressDisplayable {
    let progress: Double
    @State private var animate = false
    var progressPercentage: Int { Int(progress * 100) }

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "#1A2980"),
                    Color(hex: "#26D0CE"),
                    Color(hex: "#F2FCFE"),
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 32) {
                Text("Loading...")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "#1A2980"))
                    .shadow(color: Color(hex: "#26D0CE").opacity(0.3), radius: 4, y: 2)

                ModernLoadingSpinner(isAnimating: $animate)
                    .frame(width: 64, height: 64)
                    .padding(.bottom, 8)

                Text("\(progressPercentage)%")
                    .font(.system(size: 22, weight: .medium, design: .rounded))
                    .foregroundColor(Color(hex: "#26D0CE"))
                    .shadow(color: Color(hex: "#1A2980").opacity(0.2), radius: 2, y: 1)
            }
            .onAppear { animate = true }
        }
    }
}

// MARK: - Современное колесо загрузки

struct ModernLoadingSpinner: View {
    @Binding var isAnimating: Bool
    let circleCount = 12
    let circleSize: CGFloat = 10
    let spinnerSize: CGFloat = 64

    var body: some View {
        ZStack {
            ForEach(0..<circleCount, id: \.self) { i in
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(hex: "#26D0CE"),
                                Color(hex: "#1A2980"),
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: circleSize, height: circleSize)
                    .opacity(Double(i + 1) / Double(circleCount))
                    .offset(y: -spinnerSize / 2 + circleSize / 2)
                    .rotationEffect(.degrees(Double(i) / Double(circleCount) * 360))
            }
        }
        .rotationEffect(isAnimating ? .degrees(360) : .degrees(0))
        .animation(
            Animation.linear(duration: 1.0).repeatForever(autoreverses: false),
            value: isAnimating
        )
    }
}


// MARK: - Превью

#Preview("Modern Loading") {
    YourStoryLoadingOverlay(progress: 0.42)
}

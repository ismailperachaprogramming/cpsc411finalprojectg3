import SwiftUI

struct ContentView: View {
    @AppStorage("dailyGoalOz") private var dailyGoal: Int = 64 // Default daily goal in ounces
    @State private var waterIntake: Int = 0 // Water intake in ounces
    @State private var addAmount: Int = 8 // Default add amount in ounces
    @State private var showCongratulations: Bool = false // State for showing the alert

    var progress: Double {
        min(Double(waterIntake) / Double(dailyGoal), 1.0)
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Thristy?")
                    .font(.largeTitle)
                    .bold()

                ZStack {
                    // Background Teardrop Shape Outline
                    TeardropShape()
                        .stroke(Color.blue.opacity(0.3), lineWidth: 8)
                        .frame(width: 200, height: 300)

                    // Progress Fill
                    TeardropShape()
                        .fill(Color.blue.opacity(0.6))
                        .frame(width: 200, height: 300)
                        .clipShape(TeardropShape()) // Clip the fill to match the teardrop shape
                        .scaleEffect(x: 1, y: progress, anchor: .bottom) // Scale fill to progress
                        .animation(.easeInOut, value: progress)

                    // Text for Progress
                    VStack {
                        Text("\(waterIntake) / \(dailyGoal) oz")
                            .font(.title2)
                            .bold()
                        Text("\(Int(progress * 100))%")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                }
                .padding()

                // Log Water Button
                HStack {
                    Stepper("Add: \(addAmount) oz", value: $addAmount, in: 1...32, step: 1)
                }
                .padding()

                Button(action: {
                    waterIntake += addAmount
                    if waterIntake >= dailyGoal {
                        waterIntake = dailyGoal // Prevent overshooting the goal
                        showCongratulations = true // Trigger the alert
                    }
                }) {
                    Text("Log Water")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                // Reset Button
                Button(action: {
                    waterIntake = 0
                }) {
                    Text("Reset for New Day")
                        .foregroundColor(.red)
                }

                Spacer()

                // Set Goal
                VStack {
                    Text("Set Daily Goal")
                        .font(.headline)
                    Stepper("Goal: \(dailyGoal) oz", value: $dailyGoal, in: 8...200, step: 1)
                }
                .padding()
            }
            .padding()
            .alert("Congratulations!", isPresented: $showCongratulations) {
                Button("OK", role: .cancel) {
                    showCongratulations = false // Reset the alert state
                }
            } message: {
                Text("You've reached your daily water intake goal!")
            }
        }
    }
}

// Custom Teardrop Shape
struct TeardropShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        let center = CGPoint(x: rect.midX, y: rect.midY)

        // Create the teardrop shape
        path.move(to: CGPoint(x: center.x, y: rect.minY))
        path.addQuadCurve(
            to: CGPoint(x: rect.minX, y: rect.maxY),
            control: CGPoint(x: rect.minX - width * 0.4, y: rect.midY)
        )
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX, y: rect.maxY),
            control: CGPoint(x: center.x, y: rect.maxY + height * 0.6)
        )
        path.addQuadCurve(
            to: CGPoint(x: center.x, y: rect.minY),
            control: CGPoint(x: rect.maxX + width * 0.4, y: rect.midY)
        )
        return path
    }
}

// Preview for Xcode Canvas
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 14 Pro") // Specify a device for the preview
            .preferredColorScheme(.light) // Set to light or dark mode
    }
}

@main
struct WaterTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

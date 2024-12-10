import SwiftUI

// Persistent Manager for Water Records
class WaterRecordsManager: ObservableObject {
    private let defaults = UserDefaults.standard
    private let key = "waterRecords"

    func getRecords() -> [String: Int] {
        if let data = defaults.data(forKey: key),
           let records = try? JSONDecoder().decode([String: Int].self, from: data) {
            return records
        }
        return [:]
    }

    func saveRecords(_ records: [String: Int]) {
        if let data = try? JSONEncoder().encode(records) {
            defaults.set(data, forKey: key)
        }
    }
}

struct ContentView: View {
    @AppStorage("dailyGoalOz") private var dailyGoal: Int = 64 // Default daily goal in ounces
    @StateObject private var recordsManager = WaterRecordsManager()
    @State private var waterRecords: [String: Int] = [:] // Records by date
    @State private var waterIntake: Int = 0 // Water intake in ounces
    @State private var addAmount: Int = 8 // Default add amount in ounces
    @State private var showCongratulations: Bool = false // State for showing the alert
    @State private var selectedDate: Date = Date() // Selected date in calendar view

    var progress: Double {
        min(Double(waterIntake) / Double(dailyGoal), 1.0)
    }

    var body: some View {
        TabView {
            NavigationView {
                VStack(spacing: 20) {
                    Text("Thirsty?")
                        .font(.largeTitle)
                        .bold()
                    
                    Text("\(formattedDate(selectedDate))")
                        .font(.headline)

                    ZStack {
                        // Background Teardrop Shape Outline
                        TeardropShape()
                            .stroke(Color.blue.opacity(0.3), lineWidth: 8)
                            .frame(width: 200, height: 300)

                        // Progress Fill
                        TeardropShape()
                            .fill(Color.blue.opacity(0.6))
                            .frame(width: 200, height: 300)
                            .mask(
                                Rectangle()
                                    .frame(height: 300 * progress) // Scale height based on progress
                                    .offset(y: (1 - progress) * 150) // Offset to maintain bottom-up fill
                            )
                            .animation(.linear(duration: 0.4), value: progress)

                        // Text for Progress
                        VStack {
                            Text("\(waterIntake) / \(dailyGoal) oz")
                                .font(.title)
                            Text("\(Int(progress * 100))%")
                                .font(.headline)
                                .foregroundColor(.black)
                        }
                        
                    }
                    .padding()
                    
                    HStack {
                        Stepper("Add: \(addAmount) oz", value: $addAmount, in: 1...32, step: 1)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal)
                    }

                    // Log Water Button
                    Button(action: logWaterIntake) {
                        Text("Log Water (\(addAmount) oz)")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()

                    // Reset Button
                    Button(action: resetDailyIntake) {
                        Text("Reset for New Day")
                            .foregroundColor(.red)
                    }

                    //Spacer()

                    // Set Goal
                    VStack {
                        Text("Set Daily Goal")
                            .font(.headline)
                        Stepper("Goal: \(dailyGoal) oz", value: $dailyGoal, in: 8...200, step: 1)
                    }
                    .padding()
                }
                .padding()
                .onAppear {
                    waterRecords = recordsManager.getRecords()
                    loadWaterIntake()
                }
                .alert("Congratulations!", isPresented: $showCongratulations) {
                    Button("OK", role: .cancel) {
                        showCongratulations = false // Reset the alert state
                    }
                } message: {
                    Text("You've reached your daily water intake goal!")
                }
            }
            .tabItem {
                Label("Log", systemImage: "book.fill")
            }

            // Calendar View
            CalendarTab(selectedDate: $selectedDate, waterRecords: waterRecords)
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }
        }
    }

    // MARK: Helper Functions
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    private func loadWaterIntake() {
        let dateKey = formattedDate(selectedDate)
        waterIntake = waterRecords[dateKey] ?? 0
    }

    private func logWaterIntake() {
        waterIntake += addAmount
        if waterIntake >= dailyGoal {
            showCongratulations = true
            waterIntake = dailyGoal
        }
        saveWaterIntake()
    }

    private func saveWaterIntake() {
        let dateKey = formattedDate(selectedDate)
        waterRecords[dateKey] = waterIntake
        recordsManager.saveRecords(waterRecords)
    }

    private func resetDailyIntake() {
        saveWaterIntake() // Save current progress
        waterIntake = 0
    }
}

struct CalendarTab: View {
    @Binding var selectedDate: Date
    var waterRecords: [String: Int]
    @AppStorage("dailyGoalOz") private var dailyGoal: Int = 64

    var body: some View {
        VStack {
            DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
            
            let formattedDateString = formattedDate(selectedDate)
            let waterIntakeForSelectedDate = waterRecords[formattedDateString] ?? 0
            let progressForSelectedDate = min(Double(waterIntakeForSelectedDate) / Double(dailyGoal), 1.0)
            
            Text("Water Drank: \(waterIntakeForSelectedDate) oz")
                .font(.headline)
                .padding()

            // Add the TeardropShape with progress
            ZStack {
                TeardropShape()
                    .stroke(Color.blue.opacity(0.3), lineWidth: 6) // Adjust line width if needed
                    .frame(width: 150, height: 225) // Reduced dimensions

                TeardropShape()
                    .fill(Color.blue.opacity(0.6))
                    .frame(width: 150, height: 225) // Reduced dimensions
                    .mask(
                        Rectangle()
                            .frame(height: 225 * progressForSelectedDate) // Adjusted height
                            .offset(y: (1 - progressForSelectedDate) * 112.5) // Adjusted offset
                    )
                    .animation(.easeInOut, value: progressForSelectedDate)

                Text("\(waterIntakeForSelectedDate) / \(dailyGoal) oz")
                    .font(.title2) // Possibly use a smaller font
                    .bold()
                    .foregroundColor(.black)
            }
            .padding()
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct TeardropShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        let center = CGPoint(x: rect.midX, y: rect.midY)
        // Start at the top of the drop
        path.move(to: CGPoint(x: center.x, y: rect.minY))
        // Draw the left curve with adjusted control points for flatter bottom
        path.addQuadCurve(
            to: CGPoint(x: rect.minX + width * 0.25, y: rect.maxY - height * 0.1), // Flatter
            control: CGPoint(x: rect.minX - width * 0.3, y: rect.maxY * 0.4)
        )
        // Create a flatter bottom
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX - width * 0.25, y: rect.maxY - height * 0.1), // Flatter
            control: CGPoint(x: center.x, y: rect.maxY + height * 0.05) // Lower apex for flatter curve
        )
        // Draw the right curve back to the top
        path.addQuadCurve(
            to: CGPoint(x: center.x, y: rect.minY),
            control: CGPoint(x: rect.maxX + width * 0.3, y: rect.maxY * 0.4)
        )
        return path
    }
}
// Preview for Xcode Canvas
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 14") // Specify a device for the preview
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

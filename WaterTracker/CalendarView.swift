import Foundation
import SwiftUI
struct CalendarTab: View {
    @Binding var selectedDate: Date
    var waterRecords: [String: Int]
    @AppStorage("dailyGoalOz") private var dailyGoal: Int = 64

    var body: some View {
        GeometryReader { geometry in
            if geometry.size.width > geometry.size.height {
                // Landscape Layout
                LandscapeCalendarView(
                    selectedDate: $selectedDate,
                    waterRecords: waterRecords,
                    dailyGoal: dailyGoal,
                    geometry: geometry
                )
            } else {
                // Portrait Layout
                PortraitCalendarView(
                    selectedDate: $selectedDate,
                    waterRecords: waterRecords,
                    dailyGoal: dailyGoal,
                    geometry: geometry
                )
            }
        }
    }
}

struct LandscapeCalendarView: View {
    @Binding var selectedDate: Date
    var waterRecords: [String: Int]
    var dailyGoal: Int
    var geometry: GeometryProxy

    var body: some View {
        HStack(spacing: geometry.size.width * 0.05) {
            // Calendar
            DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .frame(width: geometry.size.width * 0.4, height: geometry.size.height * 0.8)
                .padding()
                .background(Color.white.opacity(0.1)) // Optional background for better visibility
                .cornerRadius(10)
                .shadow(radius: 5)

            // Teardrop and Progress
            TeardropView(
                selectedDate: selectedDate,
                waterRecords: waterRecords,
                dailyGoal: dailyGoal,
                geometry: geometry
            )
        }
        .padding()
    }
}

struct PortraitCalendarView: View {
    @Binding var selectedDate: Date
    var waterRecords: [String: Int]
    var dailyGoal: Int
    var geometry: GeometryProxy

    var body: some View {
        VStack(spacing: geometry.size.height * 0.03) {
            // Calendar
            DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .frame(height: geometry.size.height * 0.4)
                .padding()
                .background(Color.white.opacity(0.1)) // Optional background for better visibility
                .cornerRadius(10)
                .shadow(radius: 5)

            // Teardrop and Progress
            VStack(spacing: geometry.size.height * 0.02) {
                Text("Water Drank: \(waterRecords[formattedDate(selectedDate)] ?? 0) oz")
                    .font(.system(size: geometry.size.width * 0.06))
                    .bold()

                ZStack {
                    TeardropShape()
                        .stroke(Color.blue.opacity(0.3), lineWidth: 6)
                        .frame(
                            width: geometry.size.width * 0.5, // Proportional width
                            height: geometry.size.height * 0.3 // Proportional height
                        )

                    TeardropShape()
                        .fill(Color.blue.opacity(0.6))
                        .frame(
                            width: geometry.size.width * 0.5, // Proportional width
                            height: geometry.size.height * 0.3 // Proportional height
                        )
                        .mask(
                            Rectangle()
                                .frame(height: geometry.size.height * 0.3 * progressForSelectedDate)
                                .offset(y: geometry.size.height * 0.3 * (1 - progressForSelectedDate) / 2)
                        )
                        .animation(.easeInOut, value: progressForSelectedDate)

                    Text("\(waterRecords[formattedDate(selectedDate)] ?? 0) / \(dailyGoal) oz")
                        .font(.system(size: geometry.size.width * 0.05))
                        .bold()
                        .foregroundColor(.black)
                }
            }
        }
        .padding()
    }

    private var progressForSelectedDate: Double {
        let waterIntake = waterRecords[formattedDate(selectedDate)] ?? 0
        return min(Double(waterIntake) / Double(dailyGoal), 1.0)
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}


struct TeardropView: View {
    var selectedDate: Date
    var waterRecords: [String: Int]
    var dailyGoal: Int
    var geometry: GeometryProxy

    var body: some View {
        let formattedDateString = formattedDate(selectedDate)
        let waterIntakeForSelectedDate = waterRecords[formattedDateString] ?? 0
        let progressForSelectedDate = min(Double(waterIntakeForSelectedDate) / Double(dailyGoal), 1.0)

        VStack(spacing: geometry.size.height * 0.02) {
            Text("Water Drank: \(waterIntakeForSelectedDate) oz")
                .font(.system(size: geometry.size.width * 0.04))
                .bold()

            ZStack {
                TeardropShape()
                    .stroke(Color.blue.opacity(0.3), lineWidth: 6)
                    .frame(
                        width: geometry.size.width * 0.3,
                        height: geometry.size.height * 0.5
                    )

                TeardropShape()
                    .fill(Color.blue.opacity(0.6))
                    .frame(
                        width: geometry.size.width * 0.3,
                        height: geometry.size.height * 0.5
                    )
                    .mask(
                        Rectangle()
                            .frame(height: geometry.size.height * 0.5 * progressForSelectedDate)
                            .offset(y: geometry.size.height * 0.5 * (1 - progressForSelectedDate) / 2)
                    )
                    .animation(.easeInOut, value: progressForSelectedDate)

                Text("\(waterIntakeForSelectedDate) / \(dailyGoal) oz")
                    .font(.system(size: geometry.size.width * 0.05))
                    .bold()
                    .foregroundColor(.black)
            }
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}


  # WaterTracker

 WaterTracker is a SwiftUI application designed to help users track their daily water intake and manage their hydration goals.

 ## Team 3 Members:
 **Gina Kim**
 **Juli Nazzario**
 **Ismail Peracha**
 **Kevin Ramirez**
 **Helen Truong**

 ## Features

 - **Log Water Intake**: Easily log water consumption with a customizable amount per entry.
 - **Daily Goal**: Set a daily water intake goal and track progress with a visual indicator.
 - **Reset Feature**: Reset your daily water intake for a fresh start each day.
 - **Progress Animation**: Visualize your consumption using a teardrop-shaped progress indicator.
 - **Calendar View**: Select any date to view past water intake and progress.
 - **Persistent Storage**: Save daily water records using `UserDefaults`.

 ## Setup and Installation

 To set up WaterTracker on your local machine, follow these steps:

1. **Clone the Repository**
    ```bash
    git clone <repository-url>
    cd WaterTracker
2. **Open in Xcode**
- Open the WaterTracker.xcodeproj file in Xcode.
3. **Build and Run the Project**
- Select your target device (simulator or physical device).
- Click on the 'Run' button or press Cmd + R.
4. **Customize the Application**
- You can modify water intake goals and default values according to your preferences in ContentView.swift.


## Usage
- Log Water: Tap on the "Log Water" button to add the selected amount to your daily intake.
- Set Goal: Use the stepper to increase or decrease your daily water goal.
- View Calendar: In the Calendar tab, select any date to view the water intake of that day.
- Reset Daily Intake: Tap "Reset for New Day" to clear the current day's records.

## Requirements
- Xcode 12 or later
- iOS 14.0 or later

Feel free to open issues or contribute to the development of the WaterTracker by submitting pull requests.

## Testing
The project includes UI tests with the WaterTrackerUITests target. Run these tests using Xcode to ensure the app functions correctly.

**Enjoy staying hydrated with WaterTracker!**

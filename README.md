# WeatherTest

The **WeatherTest** app is a test assignment for a middle iOS developer. The application displays current weather information and forecasts for cities and countries using the OpenWeatherMap API. The app also supports offline mode with weather data stored locally using Core Data.

## Architecture

This project follows the **MVVM (Model-View-ViewModel)** architecture. MVVM was chosen for better separation of concerns, ease of maintenance, and leveraging the power of **Combine** for reactive programming and data binding.

## Features

- **Weather by User Location**: Automatically fetches weather data based on the user's current location.
- **City and Country Search**: Search weather by city or country using a text field.
- **Offline Mode**: Weather forecasts are saved in Core Data, allowing users to view previously fetched data without an internet connection.
- **Core Data Integration**: Stores fetched weather data to provide offline access to forecasts.

## API Integration

This app integrates with the [OpenWeatherMap API](https://openweathermap.org/api) to fetch real-time weather data. The API provides details such as temperature, humidity, wind speed, and multi-day forecasts.

The API key is already embedded within the project, so no additional configuration is required.

## Requirements

- **iOS**: 18.0+
- **Xcode**: 16.0+
- **Swift**: 6.0

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/Grachev-KA/WeatherTest.git
   ```
2. Open the project in Xcode:
   ```bash
   open WeatherTest.xcodeproj
   ```
3. Build and run the project on a simulator or a physical device.

## Implementation Details

- **MVVM**: The app uses MVVM to separate the business logic from the UI, making the codebase more maintainable and testable. Combine is used for data binding between the ViewModel and View.
- **OpenWeatherMap API**: Provides real-time weather data. API requests are made based on user input (city, country) or geolocation data.
- **Core Data**: Core Data is used to persist weather forecasts locally, allowing offline access to previously fetched data.

## Challenges and Solutions

- **Offline Weather Storage**: One of the main challenges was implementing offline storage for weather forecasts. This was resolved with light refactoring and by integrating Core Data to store and retrieve weather data for offline access.

## Time Spent

The project was completed in **24 working hours**.

## Screenshots
<img src="https://github.com/user-attachments/assets/a05a1fd5-620f-48af-98ee-1a0af83294e2" width="200">
<img src="https://github.com/user-attachments/assets/f2ce61b3-42a2-4582-bd86-0d019f5ae1e9" width="200">
<img src="https://github.com/user-attachments/assets/387b4821-d938-48f1-97ac-6bfcfd3ca0ba" width="200">

## Future Improvements

- Add localization for multiple languages.
- Implement unit tests for the network and view model layers.
- Enhance UI/UX for better user experience.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

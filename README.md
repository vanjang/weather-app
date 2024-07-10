# Weather App

This is a tiny yet powerful weather app that fulfills all the functionalities expected of a weather forecast app! I thoroughly enjoyed exploring this new technology—TCA—which, while having a bit of a steep learning curve, provided me with immense joy and knowledge. The app offers the following features:
- Search for locations
- Save your search history. 'Search' button on the keyboard should be pressed to save.
- Provide current weather, temperature, and upcoming forecast
- Feature a detail page for your chosen location, including hourly, daily, and historical forecasts
- Cache for better performance(TTL applied)

API
- https://docs.tomorrow.io/reference/weather-forecast

Tech stacks
- 100% Swift & SwiftUI
- TCA(The Composable Architecture)
- async/await applied
- XCTests(unit tests)

Project structure
- Features: The core part of the project containing Reducers, Views, and Models. It consists of two main parts: Search and Detail.
- Weather Client: A dependency handling network data retrieval for the features.
- Data: Data models for JSON retrieved from the remote database.
- Helpers: Utilities for date and weather code formatting.

Note
- Due to the very limited number of API calls allowed by the provider, testing on a device or simulator may also be limited—it permits only 25 requests per hour.

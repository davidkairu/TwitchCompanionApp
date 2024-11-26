# Twitch Companion App

## Overview
The Twitch Companion App is a powerful tool designed for Twitch streamers to help them manage and engage with their audience more effectively. By utilizing Twitch's API, the app fetches and displays critical data in real-time, making it easier for streamers to stay on top of their metrics and audience engagement.

## Features
### Implemented:
#### User Information Display
- Fetch and display the user's Twitch profile image, display name, and view count dynamically.

#### Follower Metrics
- Fetch and display the total follower count.
- Show a list of recent followers in real-time.

#### OAuth Integration
- Authenticate securely with the Twitch API using OAuth.

## Technologies Used
- **Swift with SwiftUI**: For iOS development and building a responsive, modern UI.
- **Twitch API (Helix)**: To fetch user and follower data.
- **AsyncImage**: For loading and displaying profile images.

## Areas for Future Development
The app provides a solid foundation, with several exciting areas to expand functionality:

### Hype Train Tracker
- Visualize engagement during Twitch "Hype Train" events.
- Use Twitch's **EventSub** for real-time updates.

### Live Notifications
- Add real-time alerts for new followers, subscriptions, or donations.
- Explore **WebSocket** or **EventSub API** for push notifications.

### Follower Growth Chart
- Graphically represent follower trends over time using a charting library like **Charts**.

### Settings Screen
- Allow users to input custom Twitch usernames.
- Enable toggling of notification preferences.

### Enhanced UI/UX
- Add support for dark mode and Twitch-themed design elements.
- Introduce animations and polished visuals to enhance user experience.

## Setup Instructions
1. Clone this repository to your local machine.
2. Open the project in Xcode.
3. Replace the Twitch API credentials (`clientID` and `clientSecret`) in the **TwitchAPI** class with your own credentials from the Twitch Developer Console.
4. Run the app in the Xcode simulator or on a physical iOS device.

### Obtaining Twitch API Credentials
- Head to the [Twitch Developer Console](https://dev.twitch.tv/console/apps) and register a new application to obtain your `clientID` and `clientSecret`.

## Contributing
Contributions are welcome! Feel free to open a pull request or submit issues for any bugs or features you'd like to see added.

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact
For any questions, reach out at davidnjoroge560@gmail.com.

---
Happy Streaming! Let's make Twitch engagement easier and more fun for all streamers.


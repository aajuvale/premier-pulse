# 🎬 Premier Pulse

Premier Pulse is an iOS application that allows users to search for upcoming movies and TV shows, track their favorites, and receive reminders before new releases. It’s built entirely in Swift using SwiftUI and integrates directly with [The Movie Database (TMDB)](https://www.themoviedb.org/) API.

---

## 📱 Features

- 🔍 **Search Movies & TV Shows**  
  Seamlessly search for upcoming titles across both movies and television using TMDB’s multi-search API.

- 🎞️ **View Upcoming Releases**  
  Display a list of the most popular upcoming movie releases filtered by release date.

- ⭐ **Track Favorites**  
  Add movies or TV shows to a favorites list and persist them locally across app sessions.

- 🔔 **Push Notifications**  
  Automatically schedules a notification two weeks before a release date so users don’t miss new content.

- 🍏 **Sign in with Apple**  
  Secure and privacy-focused login powered by Apple authentication.

- 📷 **Rich Media Previews**  
  View high-quality backdrops, logos, and trailers for each movie in the detail view.

- 🧠 **Persistent State**  
  Uses `UserDefaults` and `@AppStorage` to save login and favorites across sessions.

- 🎨 **Dynamic Splash Screen**  
  Custom splash screen with gradient background and animated transitions into the app.

---

## 🖼️ Screenshots

| Upcoming Movies | Search Results | Movie Screen |
|:-------------:|:---------------:|:--------------:|
| ![Upcoming](Premier%20Pulse/In%20App%20Images/opening.png) | ![Search](Premier%20Pulse/In%20App%20Images/search.png)| ![Movie](Premier%20Pulse/In%20App%20Images/movie.png) |  |

---

## 🛠️ Tech Stack

- **Language**: Swift
- **Framework**: SwiftUI
- **APIs**: TMDB (The Movie Database) API
- **Authentication**: Sign in with Apple
- **Storage**: UserDefaults, AppStorage
- **Notifications**: UNUserNotificationCenter
- **Image Handling**: AsyncImage (for remote TMDB media)

---

## 🔒 Requirements

- Xcode 15+
- iOS 16.0+
- Apple Developer Account (for Sign in with Apple and push notification testing)

---

//
//  Utilities.swift
//  Premier Pulse
//
//  Created by Ahmed Juvale on 11/20/24.
//

import Foundation
import UserNotifications

class Utilities {
    static func getAPIKey() -> String? {
            guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
                  let dictionary = NSDictionary(contentsOfFile: path) as? [String: Any],
                  let apiKey = dictionary["TMDB_API_KEY"] as? String else {
                print("API key not found")
                return nil
            }
            return apiKey
    }
    
    static func saveUserIdentifier(_ userIdentifier: String) {
            UserDefaults.standard.set(userIdentifier, forKey: "appleUserIdentifier")
        }
        
    static func getUserIdentifier() -> String? {
        return UserDefaults.standard.string(forKey: "appleUserIdentifier")
    }

    static func scheduleNotification(for movie: Movie) {
//        print(movie.releaseDate) // Output for mufasa is Optional("2024-12-18")
        if let releaseDateString = movie.releaseDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            formatter.locale = Locale(identifier: "en_US_POSIX")

            if let date = formatter.date(from: releaseDateString) {
                print("Formatted date: \(date)")
                // Calculate the date two weeks before release
                let twoWeeksBefore = Calendar.current.date(byAdding: .day, value: -14, to: date)

                // If the movie is already less than two weeks away
                let currentDate = Date()
                let notificationDate: Date
                if let twoWeeksBefore = twoWeeksBefore, twoWeeksBefore > currentDate {
                    if let dateAtElevenAM = Calendar.current.date(bySettingHour: 11, minute: 0, second: 0, of: twoWeeksBefore) {
                            notificationDate = dateAtElevenAM
                        } else {
                            notificationDate = twoWeeksBefore
                        }
                } else {
                    // Schedule the notification for the next moment possible
                    notificationDate = currentDate.addingTimeInterval(5) // 10 seconds from now
                }

                // Create notification content
                let content = UNMutableNotificationContent()
                content.title = "Upcoming Movie Release"
                content.body = "The movie \"\(movie.title)\" releases on \(releaseDateString). Get ready!"
                content.sound = .default

                // Schedule the notification
                let trigger = UNCalendarNotificationTrigger(
                    dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: notificationDate),
                    repeats: false
                )
                let request = UNNotificationRequest(identifier: "\(movie.id)", content: content, trigger: trigger)

                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        print("Failed to schedule notification: \(error.localizedDescription)")
                        print("")
                    } else {
                        print("Notification scheduled for \(movie.title) on \(notificationDate).")
                    }
                }
                }
            } else {
                print("Failed to format date")
            }
        }
            

    
}

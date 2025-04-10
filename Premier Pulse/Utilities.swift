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
        print(movie.releaseDate) // Output for mufasa is Optional("2024-12-18")
        guard let releaseDateString = movie.releaseDate,
                  let releaseDate = ISO8601DateFormatter().date(from: releaseDateString) else {
               
                print("Invalid release date for movie: \(movie.title)")
                return
            }
            

            // Calculate the date two weeks before release
            let twoWeeksBefore = Calendar.current.date(byAdding: .day, value: -14, to: releaseDate)

            // If the movie is already less than two weeks away
            let currentDate = Date()
            let notificationDate: Date
            if let twoWeeksBefore = twoWeeksBefore, twoWeeksBefore > currentDate {
                notificationDate = twoWeeksBefore
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
    
}

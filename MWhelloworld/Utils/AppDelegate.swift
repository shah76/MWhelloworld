//
//  AppDelegate.swift
//  MWhelloworld
//
//  Created by haroon shah on 1/17/26.
//

import Foundation
import OSLog

import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {
    private let logger = Logger(
        subsystem: "com.example.app",
        category: "DataManager"
    )
    // For iOS 9+ and custom URL schemes
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        logger.notice("Received URL: \(url)")
        // Handle your logic here
        return true
    }
}
/*
 if let components = URLComponents(url: url, resolvingAgainstBaseURL: false) {
     let host = components.host
     let path = components.path
     let queryItems = components.queryItems // [URLQueryItem]
     // Use these to route or perform actions
 }
 */

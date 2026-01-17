//
//  MWhelloworldApp.swift
//  MWhelloworld
//
//  Created by haroon shah on 1/15/26.
//

import Foundation
import MWDATCore
import SwiftUI
import OSLog
import UIKit

/*
 Identifier: A unique identifier (e.g., com.yourcompany.myapp).
 URL Schemes: Enter your desired custom scheme name (e.g., myapp).
 Role: Set to Editor (default).
 Your app can now be launched by URLs starting with your custom scheme, such as myapp://some/path?param=value.

 MWhelloworld://be.MWhelloworld
 
 xcrun simctl openurl booted MWhelloworld://be.MWhelloworld
 
 */
/*
 @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate: This property wrapper in the App structure tells SwiftUI to instantiate and use your AppDelegate class as the main application delegate for handling UIKit-specific lifecycle events [1].
 */
private let logger = Logger(
    subsystem: "com.example.app",
    category: "DataManager"
)

@main
struct MWhelloworldApp: App {
    //@UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    private let wearables: WearablesInterface
    @StateObject private var wearablesViewModel: WearablesViewModel
    
    init() {
        do {
            try Wearables.configure()
            logger.notice("[CameraAccess] Wearables SDK configured successfully")
        } catch {
            logger.error("[CameraAccess] Failed to configure Wearables SDK: \(error)")
        }
        let wearables = Wearables.shared
        self.wearables = wearables
        self._wearablesViewModel = StateObject(wrappedValue: WearablesViewModel(wearables: wearables))
    }
    
    var body: some Scene {
        
        WindowGroup {
            // Main app view with access to the shared Wearables SDK instance
            // The Wearables.shared singleton provides the core DAT API
            MainView(wearables: Wearables.shared, viewModel: wearablesViewModel)
            // Show error alerts for view model failures
                .alert("Error", isPresented: $wearablesViewModel.showError) {
                    Button("OK") {
                        wearablesViewModel.dismissError()
                    }
                } message: {
                    Text(wearablesViewModel.errorMessage)
                }
            // Registration view handles the flow for connecting to the glasses via Meta AI
            RegistrationView(viewModel: wearablesViewModel)
        }
    }
}

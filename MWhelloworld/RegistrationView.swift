/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

//
// RegistrationView.swift
//
// Background view that handles callbacks from the Meta AI mobile app during
// DAT SDK registration and permission flows. This invisible view processes deep links
// that complete the OAuth authorization process initiated by the DAT SDK.
//

import MWDATCore
import SwiftUI
import OSLog

/*
 https://developer.apple.com/documentation/xcode/defining-a-custom-url-scheme-for-your-app
 
 */
/*
 • components.queryItems
 Once the URL is parsed, queryItems gives you an array of URLQueryItem representing the query parameters in the URL (everything after the ?). For example, for myapp://callback?foo=bar&metaWearablesAction=register, queryItems would include foo=bar and metaWearablesAction=register.

 • .contains(where: { $0.name == "metaWearablesAction" }) == true
 This checks whether any of the query items has the name metaWearablesAction. If at least one query parameter with that name exists, the expression evaluates to true. The == true is used because queryItems is optional; by chaining with ?.contains(...) == true, the whole expression becomes true only if:
 • queryItems exists (is not nil), and
 • it contains a query item named metaWearablesAction.

 Putting it together in the guard:
 • If the URL fails to parse into URLComponents, or
 • If the URL doesn’t include a metaWearablesAction query parameter,

 then the guard fails and the handler returns early, effectively ignoring URLs that aren’t part of the DAT SDK workflow. If both conditions pass, the code proceeds to handle the URL as a valid callback for the registration/permission flow.

 If you want to also check the value of metaWearablesAction, you could extend this to something like:
 
 if let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
    let action = components.queryItems?.first(where: { $0.name == "metaWearablesAction" })?.value {
     // Use `action` (e.g., "register", "grantPermission", etc.)
 }
 
 */
private let logger = Logger(
    subsystem: "com.example.app",
    category: "DataManager"
)

struct RegistrationView: View {
  @ObservedObject var viewModel: WearablesViewModel

  var body: some View {
    EmptyView()
      // Handle callback URLs from the Meta mobile app
      // This is essential for completing DAT SDK registration and permission flows
      .onOpenURL { url in
          logger.notice("callback URL: \(url)")
        guard
          let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
          // Check if this URL is related to DAT SDK workflows (contains metaWearablesAction query param)
          components.queryItems?.contains(where: { $0.name == "metaWearablesAction" }) == true
        else {
          return // URL is not related to DAT SDK - ignore it
        }
        Task {
          do {
            // Pass the callback URL to the DAT SDK for processing
            // This handles registration completion and permission grant responses
              logger.notice("callback URL: \(url)")
            //_ = try await Wearables.shared.handleUrl(url)
          } catch let error as RegistrationError {
            viewModel.showError(error.description)
          } catch {
            viewModel.showError("Unknown error: \(error.localizedDescription)")
          }
        }
      }
  }
}

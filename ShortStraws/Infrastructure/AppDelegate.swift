//
//  AppDelegate.swift
//  ShortStrawsProject
//
//  Created by Greg Schloemer on 9/28/19.
//  Copyright © 2019 Greg Schloemer. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  
    func application(_ app: UIApplication, open inputURL: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
      
      // Checks if the URL is a file URL with file://. We will ignore any HTTP URLs.
      guard inputURL.isFileURL else {
        return false
      }
      
      // Get rootViewController instance
      guard let rootController = window?.rootViewController as? RootViewController else {
        return false
      }
      
      // Sends the inbound URL and boolean down the chain to RootViewController.
      rootController.openRemoteDocument(inputURL, importIfNeeded: true)
      return true
    }
}

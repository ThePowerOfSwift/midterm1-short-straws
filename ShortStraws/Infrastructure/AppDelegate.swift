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
      
      // 1
      guard inputURL.isFileURL else {
        return false
      }
      
      // 2
      guard let rootController = window?.rootViewController as? RootViewController else {
        return false
      }
      
      // 3
      rootController.openRemoteDocument(inputURL, importIfNeeded: true)
      return true
    }
}

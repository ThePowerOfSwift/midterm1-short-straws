//
//  AppDelegate.swift
//  ShortStrawsProject
//
//  Created by Team 1 - Short Straws for Midterm 1 in CS 485G
//  This file was adapted from the tutorial at https://www.raywenderlich.com/5244-document-based-apps-tutorial-getting-started

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

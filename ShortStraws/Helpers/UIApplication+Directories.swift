//
//  UIApplication+Directories.swift
//  ShortStrawsProject
//
//  Created by Team 1 - Short Straws for Midterm 1 in CS 485G
//  This file was adapted from the tutorial at https://www.raywenderlich.com/5244-document-based-apps-tutorial-getting-started

import UIKit

// Chaches directory 
extension UIApplication {
  static func cacheDirectory() -> URL {
    guard let cacheURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
      fatalError("serious error")
    }
    
    return cacheURL
  }
  
    // Lists doucments from FileManager / UIDocumentBrowserViewController
  static func documentsDirectory() -> URL {
    guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
      fatalError("serious error")
    }
    
    return documentsURL
  }
}

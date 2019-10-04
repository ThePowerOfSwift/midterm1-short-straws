//
// String+NS.swift
// MarkupFramework

//  Created by Team 1 - Short Straws for Midterm 1 in CS 485G
//  This file was adapted from the tutorial at https://www.raywenderlich.com/5244-document-based-apps-tutorial-getting-started

import Foundation

extension String {
  func ns() -> NSString {
    return self as NSString
  }
}

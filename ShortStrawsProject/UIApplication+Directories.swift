//
//  UIApplication+Directories.swift
//  ShortStrawsProject
//
//  Created by Greg Schloemer on 9/29/19.
//  Copyright © 2019 Greg Schloemer. All rights reserved.
//

import UIKit

extension UIApplication {
  static func cacheDirectory() -> URL {
    guard let cacheURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
      fatalError("serious error")
    }
    
    return cacheURL
  }
  
  static func documentsDirectory() -> URL {
    guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
      fatalError("serious error")
    }
    
    return documentsURL
  }
}

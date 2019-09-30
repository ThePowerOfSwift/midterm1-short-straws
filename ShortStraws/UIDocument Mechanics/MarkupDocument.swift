//
//  MarkupDocument.swift
//  ShortStrawsProject
//
//  Created by Greg Schloemer on 9/29/19.
//  Copyright © 2019 Greg Schloemer. All rights reserved.
//

import UIKit
import MarkupFramework

enum DocumentError: Error {
// Describes some errror types for potential failure events

  case unrecognizedContent
  case corruptDocument
  case archivingFailure
  
  var localizedDescription: String {
    switch self {
    case .unrecognizedContent:
      return NSLocalizedString("File is an unrecognised format", comment: "")
    case .corruptDocument:
      return NSLocalizedString("File could not be read", comment: "")
    case .archivingFailure:
      return NSLocalizedString("File could not be saved", comment: "")
    }
  }
}

class MarkupDocument: UIDocument {
// Subclass of UIDocument that contains stubs for future implementations
    
    static let defaultTemplateName = BottomAlignedView.name
    static let filenameExtension = "rwmarkup"
    
    var markup: MarkupDescription = ContentDescription(template: defaultTemplateName){
        didSet{
            updateChangeCount(.done)
        }
    }
    
  override func contents(forType typeName: String) throws -> Any {
    // Encodes current contents of markup property using NSKeyedArchiver and returns it to UIDocument to be saved to filesystem
    let data: Data
    do{
        data = try NSKeyedArchiver.archivedData(withRootObject: markup, requiringSecureCoding: false)
    } catch {
        throw DocumentError.archivingFailure
    }
    guard !data.isEmpty else {
        throw DocumentError.archivingFailure
    }
    return data
  }
  override func load(fromContents contents: Any, ofType typeName: String?) throws {
  }
}

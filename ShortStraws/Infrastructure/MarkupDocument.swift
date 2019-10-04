//
//  MarkupDocument.swift
//  ShortStrawsProject
//
//  Created by Team 1 - Short Straws for Midterm 1 in CS 485G
//  This file was adapted from the tutorial at https://www.raywenderlich.com/5244-document-based-apps-tutorial-getting-started

import UIKit
import MarkupFramework

enum DocumentError: Error {
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
    static let defaultTemplateName = BottomAlignedView.name
    static let filenameExtension = "rwmarkup"
    
    
    var markup: MarkupDescription = ContentDescription(template: defaultTemplateName) {
        didSet {
            updateChangeCount(.done)
        }
    }
    // This function encodes the current contents of the markup property using NSKeyedArchiver and saves it as a UI Document
    override func contents(forType typeName: String) throws -> Any {
        let data: Data
        do {
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
        // We confirm that the contents are a type Data
        guard let data = contents as? Data else {
            throw DocumentError.unrecognizedContent
        }

        // We decode the data as a description
        let unarchiver: NSKeyedUnarchiver
        do {
            unarchiver = try NSKeyedUnarchiver(forReadingFrom: data)
        } catch {
            throw DocumentError.corruptDocument
        }
        unarchiver.requiresSecureCoding = false
        let decodedContent = unarchiver.decodeObject(of: ContentDescription.self,
                                                     forKey: NSKeyedArchiveRootObjectKey)
        guard let content = decodedContent else {
            throw DocumentError.corruptDocument
        }

        // store it again as our variable markup
        markup = content
    }

    
}

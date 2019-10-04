//
//  ThumbnailProvider.swift
//  ShortStrawThumbnail
//
//  Created by  on 9/30/19.
//  Created by Team 1 - Short Straws for Midterm 1 in CS 485G
//  This file was adapted from the tutorial at https://www.raywenderlich.com/5244-document-based-apps-tutorial-getting-started
import UIKit
import QuickLookThumbnailing
import MarkupFramework

// 
class ThumbnailProvider: QLThumbnailProvider {
    
    override func provideThumbnail(for request: QLFileThumbnailRequest, _ handler: @escaping (QLThumbnailReply?, Error?) -> Void)
    {
        handler(QLThumbnailReply(contextSize: request.maximumSize, currentContextDrawing:
            { () -> Bool in
          
            var result = true
            do {
            // the file URL is inside the request as a property, we can get it's description using an unarchiver
            let data = try Data(contentsOf: request.fileURL)
            let unarchiver = try NSKeyedUnarchiver(forReadingFrom: data)
            unarchiver.requiresSecureCoding = false
            if let content = unarchiver.decodeObject(of: ContentDescription.self,
                                                     forKey: NSKeyedArchiveRootObjectKey)
            {
                // we create a plugin view, this was part of the starter project
                let template = PluginViewFactory.plugin(named: content.template)
              
                // we can configure the UIView object with size information
                template.view.frame = CGRect(origin: .zero, size: request.maximumSize)
                template.update(content)
                  
                // We then call draw to create it right on the current context
                template.view.draw(template.view.bounds)
              
            }
            else {
                result = false
            }
            }
            catch {
                result = false
            }
          
        return result
        }), nil)
        
    }
}

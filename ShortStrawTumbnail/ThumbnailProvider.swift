//
//  ThumbnailProvider.swift
//  ShortStrawTumbnail
//
//  Created by  on 9/30/19.
//  Copyright © 2019 Greg Schloemer. All rights reserved.
//

import UIKit
import QuickLookThumbnailing
import MarkupFramework


class ThumbnailProvider: QLThumbnailProvider {
    
    override func provideThumbnail(for request: QLFileThumbnailRequest, _ handler: @escaping (QLThumbnailReply?, Error?) -> Void) {
        handler(QLThumbnailReply(contextSize: request.maximumSize, currentContextDrawing: { () -> Bool in
          
          var result = true
          do {
            // 1
            let data = try Data(contentsOf: request.fileURL)
            let unarchiver = try NSKeyedUnarchiver(forReadingFrom: data)
            unarchiver.requiresSecureCoding = false
            if let content = unarchiver.decodeObject(of: ContentDescription.self,
                                                     forKey: NSKeyedArchiveRootObjectKey) {
              
              // 2
              let template = PluginViewFactory.plugin(named: content.template)
              
              // 3
              template.view.frame = CGRect(origin: .zero, size: request.maximumSize)
              template.update(content)
              
              // 4
              template.view.draw(template.view.bounds)
              
            } else {
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

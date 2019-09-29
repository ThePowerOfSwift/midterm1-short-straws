//
//  ContentDescription.swift
//  ShortStrawsProject
//
//  Created by Greg Schloemer on 9/28/19.
//  Copyright © 2019 Greg Schloemer. All rights reserved.
//

import UIKit

public class ContentDescription: NSObject, MarkupDescription{
    
    public var textColor: UIColor = .black
    public var longDescription: String?
    public var title: String?
    public var textBackgroundColor: UIColor = .white
    public var image: UIImage?
    public var template: String
    
    public init(template: String) {
        self.template = template
    }
    
    private enum Keys: String, CustomStringConvertible {
        
        case textColor = "textColor"
        case longDescription = "longDescription"
        case title = "title"
        case textBackgroundColor = "textBackgroundColor"
        case image = "image"
        case template = "template"
    
        var description: String{
            return self.rawValue
        }
    }
    
    public func encode(with coder: NSCoder){
        coder.encode(template, forKey: Keys.template.description)
        coder.encode(title, forKey: Keys.title.description)
        coder.encode(longDescription, forKey: Keys.longDescription.description)
        if let image = image, let data = image.jpegData(compressionQuality: 1.0){
            coder.encode(data, forKey: Keys.image.description)
        }
        coder.encode(textBackgroundColor, forKey: Keys.textBackgroundColor.description)
        coder.encode(textColor, forKey: Keys.textColor.description)
    }
    
    public required init?(coder decoder: NSCoder){
        guard let plugin = decoder.decodeObject(forKey: Keys.template.description) as? String else{
            return nil
        }
        template = plugin
        title = decoder.decodeObject(forKey: Keys.title.description) as? String
        longDescription = decoder.decodeObject(forKey: Keys.longDescription.description) as? String
        if let data = decoder.decodeObject(forKey: Keys.image.description) as? Data {
            image = UIImage(data: data)
        }
        textBackgroundColor = decoder.decodeObject(forKey: Keys.textBackgroundColor.description) as? UIColor ?? .white
        textColor = decoder.decodeObject(forKey: Keys.textColor.description) as? UIColor ?? .black
    }
}

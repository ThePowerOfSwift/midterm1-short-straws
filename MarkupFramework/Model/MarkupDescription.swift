//
//  MarkupDescription.swift
//  ShortStrawsProject
//
//  Created by Greg Schloemer on 9/29/19.
//  Copyright © 2019 Greg Schloemer. All rights reserved.
//

import UIKit

public protocol MarkupDescription: NSCoding {
    
    var textColor: UIColor { get set }
    var longDescription: String? { get set }
    var title: String? { get set }
    var textBackgroundColor: UIColor { get set }
    var image: UIImage? { get set }
    var template: String { get }

}

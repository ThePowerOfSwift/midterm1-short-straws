//
//  PluginView.swift
//  MarkupFramework
//
//  Created by Greg Schloemer on 9/29/19.
//  Copyright © 2019 Greg Schloemer. All rights reserved.
//

import UIKit

public protocol PluginView: class {
  var view: UIView { get }
  func update(_ content: MarkupDescription)
  static var name: String { get }
  func renderImage(content: MarkupDescription, maxDimension: CGFloat) -> UIImage?
}

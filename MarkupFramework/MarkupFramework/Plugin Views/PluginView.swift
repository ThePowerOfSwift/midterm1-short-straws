//
//  PluginView.swift
//  MarkupFramework
//
//  Created by Team 1 - Short Straws for Midterm 1 in CS 485G
//  This file was adapted from the tutorial at https://www.raywenderlich.com/5244-document-based-apps-tutorial-getting-started

import UIKit


public protocol PluginView: class {
    var view: UIView { get }
    func update(_ content: MarkupDescription)
    static var name: String { get }
    func renderImage(content: MarkupDescription, maxDimension: CGFloat) -> UIImage?
}

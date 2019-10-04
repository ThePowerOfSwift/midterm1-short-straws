//
//  UIView+LayoutHelp.swift
//  ShortStrawsProject
//
//  Created by Team 1 - Short Straws for Midterm 1 in CS 485G
//  This file was adapted from the tutorial at https://www.raywenderlich.com/5244-document-based-apps-tutorial-getting-started

import UIKit

// Defines pinToInside which specifies anchor points and responsive autoresizing dimensions for UI elements
extension UIView {
    func pinToinside(view child: UIView) {
        child.translatesAutoresizingMaskIntoConstraints = false
        addSubview(child)
        NSLayoutConstraint.activate([
            child.leadingAnchor.constraint(equalTo: leadingAnchor),
            child.trailingAnchor.constraint(equalTo: trailingAnchor),
            child.topAnchor.constraint(equalTo:
                safeAreaLayoutGuide.topAnchor),
            child.bottomAnchor.constraint(equalTo:
                safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

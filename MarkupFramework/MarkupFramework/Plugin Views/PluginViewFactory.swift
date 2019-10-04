//
//  PluginViewFactory.swift
//  MarkupFramework
//
//  Created by Team 1 - Short Straws for Midterm 1 in CS 485G
//  This file was adapted from the tutorial at https://www.raywenderlich.com/5244-document-based-apps-tutorial-getting-started

import Foundation

// These methods are called to instantiate a PluginView object. The detfaultPlugin is declared as bottomAlignedView
public class PluginViewFactory: NSObject {
    
    public static let defaultPlugin = Plugin.bottomAlignedView
    
    // Instantiates and returns a BottomAlignedView object
    public static func plugin(type: Plugin) -> PluginView {
        switch type {
        case .bottomAlignedView:
            return BottomAlignedView(frame: .zero)
        }
    }
    
    // This will catch errors thrown by invalid plugin names OR will instantiate plugin of type *name* if valid
    public static func plugin(named name: String) -> PluginView {
        let plugin: Plugin
        if let type = Plugin(rawValue: name) {
            plugin = type
        } else {
            print("unknown plugin named '\(name)' returning default")
            plugin = defaultPlugin
        }
        
        return PluginViewFactory.plugin(type: plugin)
    }
    
}

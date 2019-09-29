//
//  PluginViewFactory.swift
//  MarkupFramework
//
//  Created by Greg Schloemer on 9/29/19.
//  Copyright © 2019 Greg Schloemer. All rights reserved.
//

import Foundation

public class PluginViewFactory: NSObject {
  
  public static let defaultPlugin = Plugin.bottomAlignedView
  
  public static func plugin(type: Plugin) -> PluginView {
    switch type {
    case .bottomAlignedView:
      return BottomAlignedView(frame: .zero)
    }
  }
  
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

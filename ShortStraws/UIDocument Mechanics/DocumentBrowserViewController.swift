//
//  DocumentBrowserViewController.swift
//  ShortStrawsProject
//
//  Created by Greg Schloemer on 9/28/19.
//  Copyright © 2019 Greg Schloemer. All rights reserved.
//

import UIKit
import MarkupFramework

class DocumentBrowserViewController: UIViewController {
    
    // Create an instance of DocumentBrowserDelegate
    var browserDelegate = DocumentBrowserDelegate()
    
    // Create an instance of UIDocumentBrowserViewController and assign properties
    lazy var documentBrowser: UIDocumentBrowserViewController = {
      let browser = UIDocumentBrowserViewController()
      
      browser.allowsDocumentCreation = true
      browser.browserUserInterfaceStyle = .dark
      browser.view.tintColor = UIColor(named: "RazeGreen") ?? .white
      browser.delegate = browserDelegate
      
      return browser
    }()

    func installDocumentBrowser() {
      view.pinToInside(view: documentBrowser.view)
    }
    
      override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
      }
      
      override func viewDidLoad() {
        // Install DocumentBrowser instance
        super.viewDidLoad()
        installDocumentBrowser()
      }
      
    }



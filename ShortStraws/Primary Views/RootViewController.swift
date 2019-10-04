//
//  RootViewController.swift
//  ShortStrawsProject
//
//  Created by Greg Schloemer on 9/29/19.
//  Copyright © 2019 Greg Schloemer. All rights reserved.
//

import UIKit
import MarkupFramework

// States for navigation within the app
enum NavigationContext {
    case launched
    case browsing
    case editing
}

// RootViewController is instantiated before MarkupViewController or DocumentBrowserViewController is launched
class RootViewController: UIViewController {
    lazy var documentBrowser: DocumentBrowserViewController = {
        return DocumentBrowserViewController()
    }()
    var presentationContext: NavigationContext = .launched
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        displayDocumentBrowser()
    }
    
    // Displays a markupViewController
    func displayMarkupController(presenter: UIViewController) {
        presentationContext = .editing
        let controller = MarkupViewController.freshController()
        presenter.present(controller, animated: true)
    }
    
    // Displays a documentBrowser from url passed in as a parameter
    func displayDocumentBrowser(inboundURL: URL? = nil, importIfNeeded: Bool = true) {
        if presentationContext == .launched {
            // DocuemntBrowser is of type UIDocumentBrowserViewController
            present(documentBrowser, animated: false)
        }
        presentationContext = .browsing
        if let inbound = inboundURL {
            documentBrowser.openRemoteDocument(inbound, importIfNeeded: importIfNeeded)
        }
    }
}

// The method here forwards the parameters to displayDocumentBrowser.
extension RootViewController {
    func openRemoteDocument(_ inboundURL: URL, importIfNeeded: Bool) {
        displayDocumentBrowser(inboundURL: inboundURL, importIfNeeded: importIfNeeded)
    }
}

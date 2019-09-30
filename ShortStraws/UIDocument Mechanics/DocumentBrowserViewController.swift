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
    
    var currentDocument: MarkupDocument?
    var editingDocument = false
    
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

extension DocumentBrowserViewController: MarkupViewControllerDelegate {
    
    // As long as you are not editing and there is a current document, present MarkupViewController modally.
    func displayMarkupController() {
        
        guard !editingDocument, let document = currentDocument else {
            return
        }
        
        editingDocument = true
        let controller = MarkupViewController.freshController(markup: document.markup, delegate: self)
        present(controller, animated: true)
    }
    
    // Dismiss the current MarkupViewController and clean up.
    func closeMarkupController(completion: (() -> Void)? = nil) {
        
        let compositeClosure = {
            self.closeCurrentDocument()
            self.editingDocument = false
            completion?()
        }
        
        if editingDocument {
            dismiss(animated: true) {
                compositeClosure()
            }
        } else {
            compositeClosure()
        }
    }
    
    private func closeCurrentDocument()  {
        currentDocument?.close()
        currentDocument = nil
    }
    
    // When the document finishes editing you update the document then dismiss the MarkupViewController.
    func markupEditorDidFinishEditing(_ controller: MarkupViewController, markup: MarkupDescription) {
        currentDocument?.markup = markup
        closeMarkupController()
    }
    
    // When the content updates you update the document.
    func markupEditorDidUpdateContent(_ controller: MarkupViewController, markup: MarkupDescription) {
        currentDocument?.markup = markup
    }
    
}

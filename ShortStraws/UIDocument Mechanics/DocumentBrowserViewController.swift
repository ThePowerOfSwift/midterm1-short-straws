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
        // Give the DocumentBrowserDelegate instance a closure to use for presenting the document. If there is an error, ignore it. Otherwise, follow the path and open the document URL.
        browserDelegate.presentationHandler = { [weak self] url, error in
          
          guard error == nil else {
            //present error to user e.g UIAlertController
            return
          }
          
          if let url = url, let self = self {
            self.openDocument(url: url)
          }
        }
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

extension DocumentBrowserViewController {
  
  func openDocument(url: URL) {
    
    // Return if the document is already being edited.
    guard isDocumentCurrentlyOpen(url: url) == false else {
      return
    }
    
    
    closeMarkupController {
      // Open the new document and then open a MarkupViewController.
      let document = MarkupDocument(fileURL: url)
      document.open { openSuccess in
        guard openSuccess else {
          return
        }
        self.currentDocument = document
        self.displayMarkupController()
      }
    }
  }

  // Check if the document is already open by making a couple of logic checks. This is in a separate method to make the flow of the main method more obvious.
  private func isDocumentCurrentlyOpen(url: URL) -> Bool {
    if let document = currentDocument {
      if document.fileURL == url && document.documentState != .closed  {
        return true
      }
    }
    return false
  }
  
}

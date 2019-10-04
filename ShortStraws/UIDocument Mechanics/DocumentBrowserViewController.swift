//
//  DocumentBrowserViewController.swift
//  ShortStrawsProject
//
//  Created by Greg Schloemer on 9/28/19.
//  Copyright © 2019 Greg Schloemer. All rights reserved.
//

import UIKit
import MarkupFramework
import PDFKit

class DocumentBrowserViewController: UIViewController {
  var browserDelegate = DocumentBrowserDelegate()
  var currentDocument: MarkupDocument?
  var otherDocument: PDFDocument?
  var editingDocument = false
  lazy var documentBrowser: UIDocumentBrowserViewController = {
    let browser = UIDocumentBrowserViewController()
    
    browser.allowsDocumentCreation = true
    browser.browserUserInterfaceStyle = .dark
    browser.view.tintColor = UIColor(named: "RazeGreen") ?? .white
    browser.delegate = browserDelegate
    
    return browser
  }()

  func installDocumentBrowser() {
    view.pinToinside(view: documentBrowser.view)
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
    super.viewDidLoad()
    installDocumentBrowser()
  }
  
}
extension DocumentBrowserViewController: MarkupViewControllerDelegate {
  
  // 1
  func displayMarkupController() {
    
    guard !editingDocument, let document = currentDocument else {
      return
    }
    
    editingDocument = true
    let controller = MarkupViewController.freshController(markup: document.markup, delegate: self)
    present(controller, animated: true)
  }
  
  // 2
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
  
  // 3
  func markupEditorDidFinishEditing(_ controller: MarkupViewController, markup: MarkupDescription) {
    currentDocument?.markup = markup
    closeMarkupController()
  }
   
  // 4
  func markupEditorDidUpdateContent(_ controller: MarkupViewController, markup: MarkupDescription) {
    currentDocument?.markup = markup
  }
  
}
extension DocumentBrowserViewController {
  
  func openDocument(url: URL) {
    
   
    guard isDocumentCurrentlyOpen(url: url) == false else {
      return
    }
    
    if(url.pathExtension == "pdf") {
        closePDFController {
            
            let document = PDFDocument(url: url)
              self.otherDocument = document
              self.displayPDFController()
            }
          }

    else {
    closeMarkupController {
     
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
}

  // 3
  private func isDocumentCurrentlyOpen(url: URL) -> Bool {
    if let document = currentDocument {
      if document.fileURL == url && document.documentState != .closed  {
        return true
      }
    }
    return false
  }
  
}
extension DocumentBrowserViewController {
  func openRemoteDocument(_ inboundURL: URL, importIfNeeded: Bool) {
    documentBrowser.revealDocument(at: inboundURL, importIfNeeded: importIfNeeded) { url, error in
      if let error = error {
        print("import did fail - should be communicated to user - \(error)")
      } else if let url = url {
        self.openDocument(url: url)
      }
    }
  }
}
extension DocumentBrowserViewController: PDFViewControllerDelegate{

  // 1
  func displayPDFController() {
    
    guard !editingDocument, let document = otherDocument else {
      return
    }
    
    editingDocument = true
    let controller = PDFViewController.freshController(document:document, delegate: self)
    present(controller, animated: true)
  }
  
  // 2
  func closePDFController(completion: (() -> Void)? = nil) {
    
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

  
  // 3
    func PDFEditorDidFinishEditing(_ controller: PDFViewController, document:PDFDocument) {
    otherDocument = document
    closePDFController()
  }
   
  // 4
    func PDFEditorDidUpdateContent(_ controller: PDFViewController, document:PDFDocument) {
    otherDocument = document
  }
  
}


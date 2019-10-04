//
//  DocumentBrowserViewController.swift
//  ShortStrawsProject
//
//  Created by Team 1 - Short Straws for Midterm 1 in CS 485G
//  This file was adapted from the tutorial at https://www.raywenderlich.com/5244-document-based-apps-tutorial-getting-started

import UIKit
import MarkupFramework
import PDFKit

// Defines the relevant app delegate, the markupdocument currently being edited (as well as the PDF document being edited), bool to track whether document is being edited
class DocumentBrowserViewController: UIViewController {
    var browserDelegate = DocumentBrowserDelegate()
    var currentDocument: MarkupDocument?
    var otherDocument: PDFDocument?
    var editingDocument = false
    lazy var documentBrowser: UIDocumentBrowserViewController = {
        let browser = UIDocumentBrowserViewController()
        
        // Sets properties of the document browser UI. Includes color, ability to create new documents, and the AppDelegate connected to the UI instance.
        browser.allowsDocumentCreation = true
        browser.browserUserInterfaceStyle = .dark
        browser.view.tintColor = UIColor(named: "RazeGreen") ?? .white
        browser.delegate = browserDelegate
        
        return browser
    }()
    
    // Gives the DocumentBrowserDelegate instance a closure to use for presenting the document. If there is an error, ignore it. If it is a URL, open the document.
    
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
    // Installs document browser UI whenever the DocumentBrowserView is loaded
    override func viewDidLoad() {
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
    
    // When the content markup changes, update it.
    func markupEditorDidUpdateContent(_ controller: MarkupViewController, markup: MarkupDescription) {
        currentDocument?.markup = markup
    }
    
}
extension DocumentBrowserViewController {
    
    func openDocument(url: URL) {
        
        // Returns if document is open
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
                // Return a markupViewController and open the document
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
    
    // Check if the document is currently open
    private func isDocumentCurrentlyOpen(url: URL) -> Bool {
        if let document = currentDocument {
            if document.fileURL == url && document.documentState != .closed  {
                return true
            }
        }
        return false
    }
    
}

// Takes arguments that passed from AppDelegate by RootViewController and gives them to the UIDocumentBrowserViewController instance. Assuming the revealDocument() call is successful, the app opens the URL.
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
    
    // Displays PDF controller in present context
    func displayPDFController() {
        
        guard !editingDocument, let document = otherDocument else {
            return
        }
        
        editingDocument = true
        let controller = PDFViewController.freshController(document:document, delegate: self)
        present(controller, animated: true)
    }
    
    // Closes PDF controller, checking if document is currently being edited
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
    
    
    // Checks if PDF finished editing, then closes it
    func PDFEditorDidFinishEditing(_ controller: PDFViewController, document:PDFDocument) {
        otherDocument = document
        closePDFController()
    }
    
    // Invoked when PDF content is updated
    func PDFEditorDidUpdateContent(_ controller: PDFViewController, document:PDFDocument) {
        otherDocument = document
    }
    
}


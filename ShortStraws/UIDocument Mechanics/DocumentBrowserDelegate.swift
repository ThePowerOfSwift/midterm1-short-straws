//
//  DocumentBrowserDelegate.swift
//  ShortStrawsProject
//
//  Created by Greg Schloemer on 9/29/19.
//  Copyright © 2019 Greg Schloemer. All rights reserved.
//

import UIKit
import MarkupFramework

class DocumentBrowserDelegate: NSObject, UIDocumentBrowserViewControllerDelegate{
    
    var presentationHandler: ((URL?, Error?) -> Void)?
    
    // Called when using "Create Document" in UI
    func documentBrowser(_ controller: UIDocumentBrowserViewController,
                         didRequestDocumentCreationWithHandler importHandler: @escaping
        (URL?, UIDocumentBrowserViewController.ImportMode) -> Void){
        // Create a cache URL and a new empty MarkupDocument at that location.
        let cacheurl = createNewDocumentURL()
        let newdoc = MarkupDocument(fileURL: cacheurl)
        
        // Save the document to that cache URL location.
        newdoc.save(to: cacheurl, for: .forCreating) { saveSuccess in
            
            // If the save fails, you call the import handler with ImportMode.none to cancel the request.
            guard saveSuccess else {
                importHandler(nil, .none)
                return
            }
            
            // Close the document. Assuming that action succeeds, call the import handler with ImportMode.move and the cache URL you generated.
            newdoc.close { closeSuccess in
                guard closeSuccess else {
                    importHandler(nil, .none)
                    return
                }
                
                importHandler(cacheurl, .move)
            }
        }
    }
    
    // Called when selecting an existing document in UI
    func documentBrowser(_ controller: UIDocumentBrowserViewController,
                         didPickDocumentURLs documentURLs: [URL]){
        guard let pickedurl = documentURLs.first else {
          return
        }
        presentationHandler?(pickedurl, nil)
    }
    
    // Informs the delegate that a file has been imported
    func documentBrowser(_ controller: UIDocumentBrowserViewController,
                         didImportDocumentAt sourceURL: URL, toDestinationURL destinationURL: URL) {
        presentationHandler?(destinationURL, nil)
    }
    
    // Informs the delegate that the document failed to import
    func documentBrowser(_ controller: UIDocumentBrowserViewController, failedToImportDocumentAt documentURL: URL, error: Error?) {
        presentationHandler?(documentURL, error)
    }
}

extension DocumentBrowserDelegate {
// Composes a URL in the app cache directory with a sequential name
static let newDocNumberKey = "newDocNumber"
  
    private func getDocumentName() -> String {
        let newDocNumber = UserDefaults.standard.integer(forKey: DocumentBrowserDelegate.newDocNumberKey)
        return "Untitled \(newDocNumber)"
    }
    
    private func incrementNameCount() {
        let newDocNumber = UserDefaults.standard.integer(forKey: DocumentBrowserDelegate.newDocNumberKey) + 1
        UserDefaults.standard.set(newDocNumber, forKey: DocumentBrowserDelegate.newDocNumberKey)
    }
    
    func createNewDocumentURL() -> URL {
        let docspath = UIApplication.cacheDirectory() //from starter project
        let newName = getDocumentName()
        let stuburl = docspath
            .appendingPathComponent(newName)
            .appendingPathExtension(MarkupDocument.filenameExtension)
        incrementNameCount()
        return stuburl
    }
  
}

//
//  DocumentBrowserDelegate.swift
//  ShortStrawsProject
//
//  Created by Greg Schloemer on 9/29/19.
//  Copyright © 2019 Greg Schloemer. All rights reserved.
//

import UIKit


//Conforms to UIDocumentBrowserViewControllerDelegate
class DocumentBrowserDelegate: NSObject, UIDocumentBrowserViewControllerDelegate{
    var presentationHandler: ((URL?, Error?) -> Void)?
    
    //Called when you select Create Document in the browser UI
    func documentBrowser(_ controller: UIDocumentBrowserViewController,
                         didRequestDocumentCreationWithHandler importHandler: @escaping
        (URL?, UIDocumentBrowserViewController.ImportMode) -> Void){
        
        //Create a cache URL and a new empty MarkupDocument at that location
        let cacheurl = createNewDocumentURL()
        let newdoc = MarkupDocument(fileURL: cacheurl)

        // Save the document to that cache URL location
        newdoc.save(to: cacheurl, for: .forCreating) { saveSuccess in
          
          // If the save fails, you call the import handler with ImportMode.none to cancel the request
          guard saveSuccess else {
            importHandler(nil, .none)
            return
          }
          
          // Close the document
          newdoc.close { closeSuccess in
            guard closeSuccess else {
              importHandler(nil, .none)
              return
            }
            
            importHandler(cacheurl, .move)
          }
        }
    }
    
    //Called when you select an existing document in the browser
    func documentBrowser(_ controller: UIDocumentBrowserViewController,
                         didPickDocumentURLs documentURLs: [URL]){guard let pickedurl = documentURLs.first else {
                               return
                             }
                             presentationHandler?(pickedurl, nil)}
    
    //Informs the delegate that a document has been imported into the file system
    func documentBrowser(_ controller: UIDocumentBrowserViewController,
                         didImportDocumentAt sourceURL: URL, toDestinationURL destinationURL: URL) {presentationHandler?(destinationURL, nil)}
    
    //Informs the delegate that an import action failed
    func documentBrowser(_ controller: UIDocumentBrowserViewController, failedToImportDocumentAt documentURL: URL, error: Error?) {presentationHandler?(documentURL, error)}
}

//Composes a URL in the app cache directory with sequential name Unitiled 0, 1, ...
//
extension DocumentBrowserDelegate {
  
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

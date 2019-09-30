//
//  DocumentBrowserDelegate.swift
//  ShortStrawsProject
//
//  Created by Greg Schloemer on 9/29/19.
//  Copyright © 2019 Greg Schloemer. All rights reserved.
//

import UIKit

class DocumentBrowserDelegate: NSObject, UIDocumentBrowserViewControllerDelegate{
    var presentationHandler: ((URL?, Error?) -> Void)?
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController,
                         didRequestDocumentCreationWithHandler importHandler: @escaping
        (URL?, UIDocumentBrowserViewController.ImportMode) -> Void){
        let cacheurl = createNewDocumentURL()
        let newdoc = MarkupDocument(fileURL: cacheurl)

        // 2
        newdoc.save(to: cacheurl, for: .forCreating) { saveSuccess in
          
          // 3
          guard saveSuccess else {
            importHandler(nil, .none)
            return
          }
          
          // 4
          newdoc.close { closeSuccess in
            guard closeSuccess else {
              importHandler(nil, .none)
              return
            }
            
            importHandler(cacheurl, .move)
          }
        }
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController,
                         didPickDocumentURLs documentURLs: [URL]){guard let pickedurl = documentURLs.first else {
                               return
                             }
                             presentationHandler?(pickedurl, nil)}
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController,
                         didImportDocumentAt sourceURL: URL, toDestinationURL destinationURL: URL) {presentationHandler?(destinationURL, nil)}
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, failedToImportDocumentAt documentURL: URL, error: Error?) {presentationHandler?(documentURL, error)}
}
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

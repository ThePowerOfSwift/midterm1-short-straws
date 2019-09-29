//
//  DocumentBrowserDelegate.swift
//  ShortStrawsProject
//
//  Created by Greg Schloemer on 9/29/19.
//  Copyright © 2019 Greg Schloemer. All rights reserved.
//

import UIKit

class DocumentBrowserDelegate: NSObject, UIDocumentBrowserViewControllerDelegate{
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController,
                         didRequestDocumentCreationWithHandler importHandler: @escaping
        (URL?, UIDocumentBrowserViewController.ImportMode) -> Void){
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController,
                         didPickDocumentURLs documentURLs: [URL]){}
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController,
                         didImportDocumentAt sourceURL: URL, toDestinationURL destinationURL: URL) {}
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, failedToImportDocumentAt documentURL: URL, error: Error?) {}
}

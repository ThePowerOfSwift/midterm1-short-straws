//
//  PDFViewController.swift
//  ShortStrawsProject
//
//  Created by Luke Ritchie on 9/30/19.
//  Copyright © 2019 Greg Schloemer. All rights reserved.
//

import Foundation
import PDFKit

class PDFViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pdfView = PDFView(frame: self.view.bounds)
        pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(pdfView)
        
        pdfView.autoScales = true
        
        let fileURL = Bundle.main.url(forResource: "Sample", withExtension: "pdf")
        pdfView.document = PDFDocument(url: fileURL!)
    }
}

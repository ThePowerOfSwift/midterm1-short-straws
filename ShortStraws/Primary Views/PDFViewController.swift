//
//  PDFViewController.swft.swift
//  ShortStrawsProject
//
//  Created by Morgan Martin on 10/3/19.
//  Copyright © 2019 Greg Schloemer. All rights reserved

import UIKit
import PDFKit

protocol PDFViewControllerDelegate: UIViewController  {
  func PDFEditorDidFinishEditing(_ controller:PDFViewController, document: PDFDocument)
  func PDFEditorDidUpdateContent(_ controller:PDFViewController, document: PDFDocument)
}
class PDFViewController: UIViewController {
    var document: PDFDocument?
    var delegate: PDFViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        let pdfView = PDFView(frame: self.view.bounds)
        pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(pdfView)
        
        pdfView.autoScales = true
        
        // Load Sample.pdf file from app bundle.
        pdfView.document = document
    }
}
extension PDFViewController {
    static func freshController(document:PDFDocument? , delegate: PDFViewControllerDelegate? = nil) -> PDFViewController {
    let storyboard = UIStoryboard(name: "PDFViewController", bundle: nil)
    guard let controller = storyboard.instantiateInitialViewController() as? PDFViewController else {
      fatalError("Project fault - cant instantiate MarkupViewController from storyboard")
    }
    controller.delegate = delegate
    controller.document = document
    return controller
  }
}


//
//  PDFViewController.swft.swift
//  ShortStrawsProject
//
//  Created by Morgan Martin on 10/3/19.
//  Copyright © 2019 Greg Schloemer. All rights reserved

import UIKit
import PDFKit

// Protocol contains functions to indicate finished editing and updated content
protocol PDFViewControllerDelegate: UIViewController  {
    func PDFEditorDidFinishEditing(_ controller:PDFViewController, document: PDFDocument)
    func PDFEditorDidUpdateContent(_ controller:PDFViewController, document: PDFDocument)
}
// This handles behavior of loading and displaying PDF files
class PDFViewController: UIViewController {
    var document: PDFDocument?
    var delegate: PDFViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Responsive mechanism for width and height scale to different screen dimensions
        let pdfView = PDFView(frame: self.view.bounds)
        pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(pdfView)
        
        pdfView.autoScales = true
        
        pdfView.document = document
    }
}
// Loading PDFViewController storyboard
extension PDFViewController {
    static func freshController(document:PDFDocument? , delegate: PDFViewControllerDelegate? = nil) -> PDFViewController {
        let storyboard = UIStoryboard(name: "PDFViewController", bundle: nil)
        guard let controller = storyboard.instantiateInitialViewController() as? PDFViewController else {
            fatalError("Project fault - cant instantiate MarkupViewController from storyboard")
        }
        // Controller has delegate and document properties
        controller.delegate = delegate
        controller.document = document
        return controller
    }
}


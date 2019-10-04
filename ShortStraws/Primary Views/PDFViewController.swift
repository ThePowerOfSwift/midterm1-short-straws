//
//  PDFViewController.swft.swift
//  ShortStrawsProject
//
//  Created by Team 1 - Short Straws for Midterm 1 in CS 485G
//  This file was adapted from the tutorial at https://www.raywenderlich.com/5244-document-based-apps-tutorial-getting-started

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
      fatalError("Project fault - cant instantiate PDFViewController from storyboard")
        // Controller has delegate and document properties
        controller.delegate = delegate
        controller.document = document
        return controller

    }
}


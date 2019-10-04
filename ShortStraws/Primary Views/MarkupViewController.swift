//
//  MarkupViewController.swift
//  ShortStrawsProject
//
//  Created by Team 1 - Short Straws for Midterm 1 in CS 485G
//  This file was adapted from the tutorial at https://www.raywenderlich.com/5244-document-based-apps-tutorial-getting-started

import UIKit
import MarkupFramework

// Protocol contains functions to indicate finished editing and updated content
protocol MarkupViewControllerDelegate: class {
    func markupEditorDidFinishEditing(_ controller:MarkupViewController, markup: MarkupDescription)
    func markupEditorDidUpdateContent(_ controller:MarkupViewController, markup: MarkupDescription)
}

// MarkupViewController class
class MarkupViewController: UIViewController {
    
    // Elements on Markup storyboard
    @IBOutlet weak var chooseImageButton: UIButton!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var templateContainer: UIView!
    
    // Injects MarkupDescription instance when View is loaded
    var currentContent: MarkupDescription? {
        didSet {
            if let markup = currentContent {
                delegate?.markupEditorDidUpdateContent(self, markup: markup)
            }
            loadCurrentContent()
        }
    }
    
    // The template is a PluginView object
    var currentTemplate: PluginView?
    var delegate: MarkupViewControllerDelegate?
    
    // Calls helper function pickImage()
    @IBAction func chooseImageAction(_ sender: Any) {
        let helper = ImagingHelper(presenter: self, sourceview: chooseImageButton)
        helper.pickImage()
    }
    
    // Choose background color
    @IBAction func colorAction(_ button: UIButton) {
        guard let template = currentContent else {
            return
        }
        template.textBackgroundColor = button.backgroundColor ?? .white
        currentContent = template
    }
    
    // Invokes DidFinishEditing() to close file
    @IBAction func doneAction(_ sender: Any) {
        view.endEditing(true)
        if let markup = currentContent {
            delegate?.markupEditorDidFinishEditing(self, markup: markup)
        }
    }
    
    // Loads injected MarkupDocument instance
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCurrentContent()
    }
    
    // Loads content template
    func loadCurrentContent() {
        guard let content = currentContent, isViewLoaded else {
            return
        }
        
        if currentTemplate == nil {
            loadTemplate(content)
        }
        currentTemplate?.update(content)
    }
    
}

// MarkupViewController extension to load storyboard MarkupViewController
extension MarkupViewController {
    static func freshController(markup: MarkupDescription? = nil , delegate: MarkupViewControllerDelegate? = nil) -> MarkupViewController {
        let storyboard = UIStoryboard(name: "MarkupViewController", bundle: nil)
        guard let controller = storyboard.instantiateInitialViewController() as? MarkupViewController else {
            fatalError("Project fault - cant instantiate MarkupViewController from storyboard")
        }
        // Instantiates delegate and markups
        controller.delegate = delegate
        controller.currentContent = markup
        return controller
    }
}

// Pins template and markup content view to inside of PluginView templateContainer
extension MarkupViewController {
    
    func loadTemplate(_ content: MarkupDescription) {
        
        let template = PluginViewFactory.plugin(named: content.template)
        templateContainer.pinToinside(view: template.view)
        
        currentTemplate = template
        currentContent = content
        
        titleField.text = currentContent?.title
        descriptionField.text = currentContent?.longDescription
        
    }
}

// Assigns textField to the UITextFieldDelegate
extension MarkupViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === titleField {
            descriptionField.becomeFirstResponder()
        } else {
            view.endEditing(true)
        }
        return true
    }
    
    // Retrieves title and longDescription fields
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        guard let template = currentContent else {
            return
        }
        
        switch textField.tag {
        case 0:
            template.title = textField.text
        case 1:
            template.longDescription = textField.text
        default:
            print("unhandled text field?")
        }
        
        currentContent = template
    }
    
}

//
extension MarkupViewController: UIImagePickerControllerDelegate {
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    // Image picker for current content in markup document
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true)
        guard let template = currentContent else {
            return
        }
        ImagingHelper.image(infoDictionary: info) { image, error in
            
            if let error = error {
                print("unable to get image from picker - \(error)")
            }
                // Set image for current template
            else if let image = image {
                template.image = image
                currentContent = template
            }
        }
    }
}

extension MarkupViewController: UINavigationControllerDelegate {
    //ImagingHelper conformance only
}

// Renders image in current content with specified dimensions
extension MarkupViewController {
    
    @IBAction func shareAction(_ sender: UIButton) {
        
        guard let template = currentTemplate, let content = currentContent else {
            return
        }
        
        guard let image = template.renderImage(content: content, maxDimension: 1024) else {
            return
        }
        
        
        let activity = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activity.popoverPresentationController?.sourceView = sender
        present(activity, animated: true)
    }
    
}

// This handles retrieving document URL, loding the default document, and loading a specified (non-default) document
extension MarkupViewController {
    
    func observeAppBackground() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleAppBackground(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    @objc func handleAppBackground(_ note: Notification) {
        if let content = currentContent {
            let result = saveDefaultDocument(content)
            print("save \(result ? "OK" : "Fail!") to \(defaultDocumentURL)")
        }
    }
    
    var defaultDocumentURL: URL {
        let docspath = UIApplication.documentsDirectory()
        return docspath.appendingPathComponent("Default.rwmarkup")
    }
    
    func loadDefaultDocument() -> MarkupDescription? {
        do {
            let documentData = try Data(contentsOf: defaultDocumentURL)
            let unarchiver = try NSKeyedUnarchiver(forReadingFrom: documentData)
            unarchiver.requiresSecureCoding = false
            return unarchiver.decodeObject(of: ContentDescription.self, forKey: NSKeyedArchiveRootObjectKey)
        } catch {
            return nil
        }
    }
    
    @discardableResult func saveDefaultDocument(_ content: MarkupDescription) -> Bool {
        do {
            let documentData = try NSKeyedArchiver.archivedData(withRootObject: content, requiringSecureCoding: false)
            try documentData.write(to: defaultDocumentURL)
            return true
        } catch {
            return false
        }
    }
    
    private func loadDocument() {
        if let content = loadDefaultDocument() {
            currentContent = content
        } else {
            currentContent = ContentDescription(template: BottomAlignedView.name)
        }
    }
    
}

//
//  MarkupViewController.swift
//  ShortStrawsProject
//
//  Created by Greg Schloemer on 9/29/19.
//  Copyright © 2019 Greg Schloemer. All rights reserved.
//

import UIKit
import MarkupFramework

protocol MarkupViewControllerDelegate: class {
  func markupEditorDidFinishEditing(_ controller:MarkupViewController, markup: MarkupDescription)
  func markupEditorDidUpdateContent(_ controller:MarkupViewController, markup: MarkupDescription)
}

class MarkupViewController: UIViewController {
  
  @IBOutlet weak var chooseImageButton: UIButton!
  @IBOutlet weak var titleField: UITextField!
  @IBOutlet weak var descriptionField: UITextField!
  @IBOutlet weak var templateContainer: UIView!
  
  var currentContent: MarkupDescription? {
    didSet {
      if let markup = currentContent {
        delegate?.markupEditorDidUpdateContent(self, markup: markup)
      }
      loadCurrentContent()
    }
  }
    var currentTemplate: PluginView?
  var delegate: MarkupViewControllerDelegate?
  
  @IBAction func chooseImageAction(_ sender: Any) {
    let helper = ImagingHelper(presenter: self, sourceview: chooseImageButton)
    helper.pickImage()
  }
  
  @IBAction func colorAction(_ button: UIButton) {
    guard let template = currentContent else {
      return
    }
    template.textBackgroundColor = button.backgroundColor ?? .white
    currentContent = template
  }
  
  @IBAction func doneAction(_ sender: Any) {
    view.endEditing(true)
    if let markup = currentContent {
      delegate?.markupEditorDidFinishEditing(self, markup: markup)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loadCurrentContent()
  }
  
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

extension MarkupViewController {
  static func freshController(markup: MarkupDescription? = nil , delegate: MarkupViewControllerDelegate? = nil) -> MarkupViewController {
    let storyboard = UIStoryboard(name: "MarkupViewController", bundle: nil)
    guard let controller = storyboard.instantiateInitialViewController() as? MarkupViewController else {
      fatalError("Project fault - cant instantiate MarkupViewController from storyboard")
    }
    controller.delegate = delegate
    controller.currentContent = markup
    return controller
  }
}

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

extension MarkupViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField === titleField {
      descriptionField.becomeFirstResponder()
    } else {
      view.endEditing(true)
    }
    return true
  }
  
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

extension MarkupViewController: UIImagePickerControllerDelegate {
  public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true)
  }
  
  public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    dismiss(animated: true)
    guard let template = currentContent else {
      return
    }
    ImagingHelper.image(infoDictionary: info) { image, error in
      
      if let error = error {
        print("unable to get image from picker - \(error)")
      }
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

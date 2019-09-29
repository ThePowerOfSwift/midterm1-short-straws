//
//  ImagingHelper.swift
//  ShortStrawsProject
//
//  Created by Greg Schloemer on 9/29/19.
//  Copyright © 2019 Greg Schloemer. All rights reserved.
//

import UIKit
import AVFoundation

typealias ImageUIPresenter = UIViewController & UIImagePickerControllerDelegate

public class ImagingHelper: NSObject {
    
    let presenter: UIViewController & UIImagePickerControllerDelegate & UINavigationControllerDelegate
    private let sourceView: UIView
    var removeAction: UIAlertAction?
    private var cameraIsUserPermitted = false
    public var canPickImage = true
    
    public init(presenter: UIViewController & UIImagePickerControllerDelegate & UINavigationControllerDelegate, sourceview: UIView){
    self.presenter = presenter
    self.sourceView = sourceview
    super.init()
    }
    
    public func pickImage() {
        requestPermission()
    }
}
    
    private extension ImagingHelper {
        
        func requestPermission() {
            var doChooseSource = true
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let cameraMediaType = AVMediaType.video
                let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: cameraMediaType)
                
                switch cameraAuthorizationStatus {
                case .denied:
                    break
                case .restricted:
                    break
                case .authorized:
                    cameraIsUserPermitted = true
                    
                case .notDetermined:
                    doChooseSource = true
                    AVCaptureDevice.requestAccess(for: cameraMediaType) { granted in
                        if granted{
                            self.cameraIsUserPermitted = true
                        }
                        self.chooseSource()
                    }
                }
            }
            
            if doChooseSource{
                chooseSource()
            }
        }
        
        func chooseSource() {
            let chooser = UIAlertController(title: NSLocalizedString("Image Source", comment: ""), message: nil, preferredStyle:
                .actionSheet)
            chooser.modalPresentationStyle = .popover
            chooser.popoverPresentationController?.sourceView = sourceView
            
            if canPickImage {
                chooser.addAction(UIAlertAction(title:
                    NSLocalizedString("Photos", comment: ""), style: .default,
                    handler: { (_) in
                    self.displayPhotoPicker()
                }))
                if cameraIsUserPermitted {
                    chooser.addAction(UIAlertAction(title:
                    NSLocalizedString("Camera", comment: ""), style: .default,
                    handler: { (_) in
                self.displayCameraUI()
                    }))
                }
            }
            
            if let action = removeAction {
                chooser.addAction(action)
            }
            presenter.present(chooser, animated: true, completion: nil)
        }
        
        func displayPhotoPicker() {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = presenter
            imagePicker.modalPresentationStyle = .popover
            imagePicker.popoverPresentationController?.sourceView = sourceView
            
            presenter.present(imagePicker, animated: true, completion: nil)
        }
        
        func displayCameraUI() {
            let cameraUI = UIImagePickerController()
            cameraUI.delegate = presenter
            cameraUI.sourceType = .camera
            cameraUI.mediaTypes = UIImagePickerController.availableMediaTypes(for:.camera) ?? []
            
            presenter.present(cameraUI, animated: true, completion: nil)
        }
        
    }

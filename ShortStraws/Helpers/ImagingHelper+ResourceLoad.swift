//
//  ImagingHelper+ResourceLoad.swift
//  ShortStrawsProject
//
//  Created by Team 1 - Short Straws for Midterm 1 in CS 485G
//  This file was adapted from the tutorial at https://www.raywenderlich.com/5244-document-based-apps-tutorial-getting-started

import Foundation
import UIKit
import Photos

// Helper function for image coordinates and scaling dimensions
extension ImagingHelper {
    
    public static func
        image(infoDictionary:[UIImagePickerController.InfoKey : Any],
              completion:(_ image: UIImage?, _ error: Error?) -> Void) {
        
        if let image = infoDictionary[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            var croprect = CGRect(x:0, y:0, width:image.size.width,
                                  height: image.size.height)
            if let rect = infoDictionary[UIImagePickerController.InfoKey.cropRect] as? CGRect{
                croprect = rect
            }
            
            if let final = image.cgImage?.cropping(to: croprect) {
                completion(UIImage(cgImage: final), nil)
                return
            }
        }
        
        if let image = infoDictionary[UIImagePickerController.InfoKey.editedImage] as? UIImage { completion(image, nil)}
        else { completion(nil, nil)}
    }
}


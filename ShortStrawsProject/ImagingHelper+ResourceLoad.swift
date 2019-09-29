//
//  ImagingHelper+ResourceLoad.swift
//  ShortStrawsProject
//
//  Created by Greg Schloemer on 9/29/19.
//  Copyright © 2019 Greg Schloemer. All rights reserved.
//

import Foundation
import UIKit
import Photos

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


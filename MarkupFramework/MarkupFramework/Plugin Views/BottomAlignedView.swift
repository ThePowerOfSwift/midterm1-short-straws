//
//  BottomAlignedView.swift
//  MarkupFramework
//
//  Created by Team 1 - Short Straws for Midterm 1 in CS 485G
//  This file was adapted from the tutorial at https://www.raywenderlich.com/5244-document-based-apps-tutorial-getting-started

import UIKit

// BottomAlignedView implementation of UIView for MarkupFramework
public class BottomAlignedView: UIView, PluginView {
    
    let unitSize: CGFloat = 1024
    
    public func update(_ content: MarkupDescription) {
        markup = content
        setNeedsDisplay()
    }
    
    public static var name: String {
        return "BottomAlignedView"
    }
    
    public var view: UIView {
        return self
    }
    
    public override var bounds: CGRect {
        didSet {
            setNeedsDisplay()
        }
    }
    
    
    // Renders the image for the Markup Document based on UIImage methods
    public func renderImage(content: MarkupDescription, maxDimension: CGFloat) -> UIImage? {
        var renderSize = CGSize(width: maxDimension, height: maxDimension)
        if let image = content.image {
            renderSize = projectedSizeForImage(image, bounds: renderSize)
        }
        let renderer = BottomAlignedView(frame: CGRect(origin: .zero, size: renderSize))
        renderer.update(content)
        UIGraphicsBeginImageContextWithOptions(renderSize, true, 0.0)
        renderer.drawHierarchy(in: renderer.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    // Adds responsive design for various screen sizes (iPhone vs iPad)
    func projectedSizeForImage(_ image: UIImage, bounds: CGSize) -> CGSize {
        
        let aspectRatio = image.size.width/image.size.height
        var projectedWidth = bounds.width
        var projectedHeight = projectedWidth/aspectRatio
        
        if projectedHeight > bounds.height {
            projectedHeight = bounds.height
            projectedWidth = projectedHeight * aspectRatio
        }
        
        return CGSize(width: projectedWidth, height: projectedHeight)
    }
    
    // The markup var is drawn by draw() below
    var markup: MarkupDescription?
    
    // Draws the markup with image and appropriate size
    public override func draw(_ rect: CGRect) {
        
        let path = UIBezierPath(rect: bounds)
        UIColor.white.set()
        path.fill()
        
        guard let markup = markup else {
            return
        }
        
        // Calls projectedSizeForImage() to retrieve scaled image dimensions
        var projectedHeight = bounds.height
        var projectedWidth = bounds.width
        if let image = markup.image {
            let projectedSize = projectedSizeForImage(image, bounds: bounds.size)
            projectedWidth = projectedSize.width
            projectedHeight = projectedSize.height
            let imageRect = CGRect(x: (bounds.width - projectedWidth)/2, y: (bounds.height - projectedHeight)/2, width: projectedWidth, height: projectedHeight)
            image.draw(in: imageRect)
        }
        
        // Responsive text element at bottom of image
        var totalTextHeight: CGFloat = 0
        let imagebaselineY = bounds.height - (bounds.height - projectedHeight)/2
        let imagebaselineX = (bounds.width - projectedWidth)/2
        var futureDrawingInstructions: [() -> Void] = []
        let fontScaler = projectedHeight/unitSize
        let inset: CGFloat = 8.0 * fontScaler
        
        // Displays longDescription element in text box at bottom of image
        if let longDescription = markup.longDescription, !longDescription.isEmpty {
            let font = UIFont.systemFont(ofSize: 20 * fontScaler)
            let attributes: [NSAttributedString.Key: Any] = [.font:font,   .foregroundColor:markup.textColor]
            let projectedrect = longDescription.ns().boundingRect(with: CGSize(width: projectedWidth - 2 * inset, height: projectedHeight/4), options: .usesLineFragmentOrigin, attributes: attributes , context: nil)
            let drawingrect = projectedrect.applying(CGAffineTransform(translationX: inset + imagebaselineX, y: imagebaselineY - inset - projectedrect.height))
            futureDrawingInstructions.append {
                longDescription.ns().draw(in: drawingrect, withAttributes: attributes)
            }
            totalTextHeight += drawingrect.height + 2 * inset
        }
        
        // Displays title element in text box at bottom of image
        if let title = markup.title, !title.isEmpty {
            let font = UIFont.boldSystemFont(ofSize: 36 * fontScaler)
            let attributes: [NSAttributedString.Key: Any] = [.font:font, .foregroundColor:markup.textColor]
            let projectedrect = title.ns().boundingRect(with: CGSize(width: projectedWidth - 2 * inset, height: projectedHeight/4), options: .usesLineFragmentOrigin, attributes: attributes , context: nil)
            let drawingrect = projectedrect.applying(CGAffineTransform(translationX: inset + imagebaselineX, y: imagebaselineY - projectedrect.height - totalTextHeight))
            futureDrawingInstructions.append {
                title.ns().draw(in: drawingrect, withAttributes: attributes)
            }
            totalTextHeight += drawingrect.height + 2 * inset
        }
        
        if totalTextHeight > 0 {
            let strip = CGRect(x: imagebaselineX , y: imagebaselineY - totalTextHeight, width: projectedWidth, height: totalTextHeight)
            let path = UIBezierPath(rect: strip)
            markup.textBackgroundColor.withAlphaComponent(0.8).set()
            path.fill()
        }
        
        for instruction in futureDrawingInstructions {
            instruction()
        }
        
    }
    
}

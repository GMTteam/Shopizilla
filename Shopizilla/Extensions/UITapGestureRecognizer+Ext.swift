//
//  UITapGestureRecognizer+Ext.swift
//  Zilla NFTs
//
//  Created by Thanh Hoang on 25/11/2021.
//

import UIKit

internal extension UITapGestureRecognizer {

    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: .zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        
        let labelSize = label.bounds.size
        textContainer.size.width = labelSize.width
        textContainer.size.height = .greatestFiniteMagnitude//labelSize.height+height
        
        let locOfTouchInLbl = self.location(in: label)
        let textBox = layoutManager.usedRect(for: textContainer)
        
        let x: CGFloat = (labelSize.width - textBox.size.width)/2 - textBox.origin.x
        let y: CGFloat = (labelSize.height - textBox.size.height)/2 - textBox.origin.y
        let textContainerOffset = CGPoint(x: x, y: y)
        
        let locX: CGFloat = locOfTouchInLbl.x - textContainerOffset.x
        let locY: CGFloat = locOfTouchInLbl.y - textContainerOffset.y
        let locOfTouchInTxtCont = CGPoint(x: locX, y: locY)
        
        let indexOfCharacter = layoutManager.characterIndex(
            for: locOfTouchInTxtCont,
            in: textContainer,
            fractionOfDistanceBetweenInsertionPoints: nil)
        
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
    func didTapAttributedString(_ string: String, in label: UILabel) -> Bool {
        guard let text = label.text else {
            return false
        }
        
        let range = (text as NSString).range(of: string)
        return self.didTapAttributedText(label: label, inRange: range)
    }
    
    private func didTapAttributedText(label: UILabel, inRange targetRange: NSRange) -> Bool {
        guard let attributedText = label.attributedText else {
            assertionFailure("attributedText must be set")
            return false
        }
        
        let textContainer = createTextContainer(for: label)
        textContainer.size = label.bounds.size
        
        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainer)
        
        let textStorage = NSTextStorage(attributedString: attributedText)
        if let font = label.font {
            textStorage.addAttribute(NSAttributedString.Key.font, value: font, range: NSMakeRange(0, attributedText.length))
        }
        textStorage.addLayoutManager(layoutManager)
        
        let locationOfTouchInLabel = location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let alignmentOffset = aligmentOffset(for: label)
        
        let xOffset = ((label.bounds.size.width - textBoundingBox.size.width) * alignmentOffset) - textBoundingBox.origin.x
        let yOffset = ((label.bounds.size.height - textBoundingBox.size.height) * alignmentOffset) - textBoundingBox.origin.y
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - xOffset, y: locationOfTouchInLabel.y - yOffset)
        
        let characterTapped = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        let lineTapped = Int(ceil(locationOfTouchInLabel.y / label.font.lineHeight)) - 1
        let rightMostPointInLineTapped = CGPoint(x: label.bounds.size.width, y: label.font.lineHeight * CGFloat(lineTapped))
        let charsInLineTapped = layoutManager.characterIndex(for: rightMostPointInLineTapped, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        return characterTapped < charsInLineTapped ? targetRange.contains(characterTapped) : false
    }
    
    private func createTextContainer(for label: UILabel) -> NSTextContainer {
        let textContainer = NSTextContainer(size: label.bounds.size)
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        return textContainer
    }
    
    private func aligmentOffset(for label: UILabel) -> CGFloat {
        switch label.textAlignment {
        case .left, .natural, .justified:
            return 0.0
        case .center:
            return 0.5
        case .right:
            return 1.0
        @unknown default:
            return 0.0
        }
    }
}

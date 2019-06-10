//
//  LXExtension-NSAttributedString.swift
//  LXLazyCells
//
//  Created by Laxman Penmesta on 6/10/19.
//  Copyright © 2019 BanCreations. All rights reserved.
//
import  UIKit

public extension NSAttributedString {
    public static func attributed (string: String?, font: UIFont?, color: UIColor?,linespacing: Int  = 3,minimumLineHeight: Int = 15, alignment: NSTextAlignment = .left) -> NSAttributedString {
        var attributedString : NSMutableAttributedString = NSMutableAttributedString(string: String.emptyString)
        
        if let stringVal = string {
            attributedString = NSMutableAttributedString(string:stringVal)
            
            if let colorVal = color {
                attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: colorVal, range: NSRange(location: 0, length: stringVal.count))
            }
            
            if let fontVal = font {
                attributedString.addAttribute(NSAttributedString.Key.font, value: fontVal, range: NSRange(location: 0, length: stringVal.count))
                let style = NSMutableParagraphStyle()
                style.lineSpacing = CGFloat(linespacing)
                style.minimumLineHeight = CGFloat(minimumLineHeight)
                style.alignment = alignment
                attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSRange(location: 0, length: stringVal.count))
            }
        }
        return attributedString
    }
}


//
//  FontStyle.swift
//  ConjuCat
//
//  Created by Marc Vicky Ricart on 10.06.2024.
//

import Foundation
import SwiftUI

enum CustomFonts: String {
    case montserrat = "Montserrat"
}

enum CustomFontStyle: String {
    case bold = "-Bold"
    case semiBold = "-SemiBold"
    case light = "-Light"
    case regular = "-Regular"
    case medium = "-Medium"
}

enum CustomFontSize: CGFloat {
    case largeTitle = 34.0
    case title = 28.0
    case title2 = 22.0
    case title3 = 20.0
    case body = 16.0
    case caption = 12.0
}

// Large Title: 34 points
// Title: 28 points
// Title 2: 22 points
// Title 3: 20 points
// Headline: 17 points
// Body: 17 points
// Callout: 16 points
// Subheadline: 15 points
// Footnote: 13 points
// Caption: 12 points
// Caption 2: 11 points


extension Font {
    
    /// Choose your font to set up
    /// - Parameters:
    ///   - font: Choose one of your font
    ///   - style: Make sure the style is available
    ///   - size: Use prepared sizes for your app
    ///   - isScaled: Check if your app accessibility prepared
    /// - Returns: Font ready to show
    
    static func customFont(
        font: CustomFonts,
        style: CustomFontStyle,
        size: CustomFontSize,
        isScaled: Bool = true) -> Font {
            
            let fontName: String = font.rawValue + style.rawValue
            
            return Font.custom(fontName, size: size.rawValue)
        }
}

//    .font(.customFont(font: , style: , size: ))



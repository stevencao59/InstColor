//
//  Constants.swift
//  InstColor
//
//  Created by Lei Cao on 11/22/22.
//

import Foundation
import SwiftUI

let favoritColorKey = "FavoriteColors"

let adUnitTestID = "ca-app-pub-3940256099942544/2435281174"
let adUnitID = "ca-app-pub-3047763899887691/5454245923"

let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
let appBuildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String

let revenueCatApiKey = "appl_qRlgnzPOxMldFkRPNOUNxfjkvFw"

let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom

let defaultFontSize = 17.0

let defaultScreenHeight: CGFloat = 852 // iPhone 14 Pro height as reference

let tooltipsDict = [
    "Complementary Color" : """
    Complementary colors are pairs of colors which, when combined or mixed, cancel each other out (lose hue) by producing a grayscale color like white or black. When placed next to each other, they create the strongest contrast for those two colors. Complementary colors may also be called "opposite colors".
    """,
    "Triadic Colors" : """
    The Triadic color scheme is based on three colors that are evenly spaced around the color wheel. Triadic colors have equally spaced hues in the same color family, but they are not directly across from one another. The most common triadic colors are red-orange-yellow, blue-green-violet and red-green-blue.
    """,
    "Split Complementary Colors" : """
    Split complementary colors are pretty much what the name implies. You take two colors opposite each other on the color wheel, like red and green, and split one of them into its two adjacent colors on the wheel. Take for example red-orange and blue-green.
    """,
    "Analogous Colors" : """
    Colors are called analogous colors when they are very similar to each other, especially when they are next to each other on a color wheel. For example, red, red-orange, and orange are analogous colors.
    """,
    "Tetradic Colors" : """
    Tetradic colors are somewhat equally apart colors on a given color wheel. However, they are formed by four colors instead of three. As they consist of four colors equally distanced on the color wheel, tetradic color schemes have two opposing sets of complementary colors. This is why they are sometimes called double complementary. The fact that they contain two sets of opposite colors is the defining aspect of tetradic colors.
    """,
    "Monochromatic Colors" : """
    Monochromatic colors are all the colors of a single hue. Monochromatic color schemes are derived from a single base hue and extended using its shades, tones and tints. Tints are achieved by adding white and shades and tones are achieved by adding a darker color, grey or black.
    """,
    "RGB": """
    The Rgb color space consists of all possible colors that can be made by the combination of red, green, and blue light. It's a popular model in photography, television, and computer graphics.
    """,
    "HEX": """
    Hex is RGB color space in hexadecimal format.
    """,
    "HSB" : """
    Hsl (for hue, saturation, lightness), also known as Hsb (for hue, saturation, brightness), is a cylindrical-coordinate representation of the Rgb color model. This representation rearranges the colors in an attempt to be more intuitive and perceptually relevant than the typical Rgb representation. It's frequently used for computer graphics applications like color pickers and image analysis.
    """,
    "CMYK" : """
    Cmyk is similar to the Cmy color space, with the addition of black (k). In theory the black component is not necessary, however this color space is primarily used in color printing where the mixture of cyan, magenta, and yellow result in a brown color rather than black.
    """,
    "XYZ" : """
    Xyz is an additive color space based on how the eye intereprets stimulus from light. Unlike other additive rgb like Rgb, Xyz is a purely mathmatical space and the primary components are "imaginary", meaning you can't create the represented color in the physical by shining any sort of lights representing x, y, and z.
    """,
    "LAB" : """
    Cie-L*ab is defined by lightness and the color-opponent dimensions a and b, which are based on the compressed Xyz color space coordinates. Lab is particularly notable for it's use in delta-e calculations.
    """,
]

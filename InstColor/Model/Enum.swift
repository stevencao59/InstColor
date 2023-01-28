//
//  Enum.swift
//  InstColor
//
//  Created by Lei Cao on 10/18/22.
//

import Foundation

enum CameraError: Error {
  case cameraUnavailable
  case cannotAddInput
  case cannotAddOutput
  case createCaptureInput(Error)
  case deniedAuthorization
  case restrictedAuthorization
  case unknownAuthorization
}

enum FrameSource {
    case wholeImage
    case thumbImage
    case cameraImage
}

enum ThumbFrameSize: Double {
    case halfSize = 10
    case defaultSize = 20
    case doubleSize = 40
}

enum FocusElement: Hashable {
    case hue
    case satuation
    case brightness
    case red
    case green
    case blue
    case hex
    case cyan
    case magenta
    case yellow
    case key
}

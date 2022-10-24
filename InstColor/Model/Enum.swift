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

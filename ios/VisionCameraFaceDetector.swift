import Vision
import MLKitFaceDetection
import MLKitVision
import CoreML

import UIKit
import AVFoundation

@objc(VisionCameraFaceDetector)
public class VisionCameraFaceDetector: NSObject, FrameProcessorPluginBase {
    static var FaceDetectorOption: FaceDetectorOptions = {
        let option = FaceDetectorOptions()
        option.contourMode = .all
        option.classificationMode = .none
        option.landmarkMode = .all
        option.performanceMode = .fast // doesn't work in fast mode!, why?
        option.isTrackingEnabled = false
        return option
    }()

    static var faceDetector = FaceDetector.faceDetector(options: FaceDetectorOption)

    private static func processContours(from face: Face) -> [String:[[String:CGFloat]]] {
      let faceContoursTypes = [
        FaceContourType.face,
        FaceContourType.leftEyebrowTop,
        FaceContourType.leftEyebrowBottom,
        FaceContourType.rightEyebrowTop,
        FaceContourType.rightEyebrowBottom,
        FaceContourType.leftEye,
        FaceContourType.rightEye,
        FaceContourType.upperLipTop,
        FaceContourType.upperLipBottom,
        FaceContourType.lowerLipTop,
        FaceContourType.lowerLipBottom,
        FaceContourType.noseBridge,
        FaceContourType.noseBottom,
        FaceContourType.leftCheek,
        FaceContourType.rightCheek,
      ]

      let faceContoursTypesStrings = [
        "FACE",
        "LEFT_EYEBROW_TOP",
        "LEFT_EYEBROW_BOTTOM",
        "RIGHT_EYEBROW_TOP",
        "RIGHT_EYEBROW_BOTTOM",
        "LEFT_EYE",
        "RIGHT_EYE",
        "UPPER_LIP_TOP",
        "UPPER_LIP_BOTTOM",
        "LOWER_LIP_TOP",
        "LOWER_LIP_BOTTOM",
        "NOSE_BRIDGE",
        "NOSE_BOTTOM",
        "LEFT_CHEEK",
        "RIGHT_CHEEK",
      ];

      var faceContoursTypesMap: [String:[[String:CGFloat]]] = [:]

      for i in 0..<faceContoursTypes.count {
        let contour = face.contour(ofType: faceContoursTypes[i]);

        var pointsArray: [[String:CGFloat]] = []

        if let points = contour?.points {
          for point in points {
            let currentPointsMap = [
                "x": point.x,
                "y": point.y,
            ]

            pointsArray.append(currentPointsMap)
          }

          faceContoursTypesMap[faceContoursTypesStrings[i]] = pointsArray
        }
      }

      return faceContoursTypesMap
    }

    private static func processLandmarks(from face: Face) -> [String:[[String:CGFloat]]] {
      let faceLandmarksTypes = [
        FaceLandmarkType.mouthBottom,
        FaceLandmarkType.mouthRight,
        FaceLandmarkType.mouthLeft,
        FaceLandmarkType.leftEye,
        FaceLandmarkType.rightEye,
        FaceLandmarkType.leftCheek,
        FaceLandmarkType.rightCheek,
        FaceLandmarkType.noseBase,
      ]

      let faceLandmarksTypesStrings = [
        "MOUTH_BOTTOM",
        "MOUTH_RIGHT",
        "MOUTH_LEFT",
        "LEFT_EYE",
        "RIGHT_EYE",
        "LEFT_CHEEK",
        "RIGHT_CHEEK",
        "NOSE_BASE",
      ];

      var faceLandmarksTypesMap: [String:[[String:CGFloat]]] = [:]

      for i in 0..<faceLandmarksTypes.count {
        let landmark = face.landmark(ofType: faceLandmarksTypes[i]);

        var pointsArray: [[String:CGFloat]] = []

        if let points = landmark?.points {
          for point in points {
            let currentPointsMap = [
                "x": point.x,
                "y": point.y,
            ]

            pointsArray.append(currentPointsMap)
          }

          faceLandmarksTypesMap[faceLandmarksTypesStrings[i]] = pointsArray
        }
      }

      return faceLandmarksTypesMap
    }

    private static func processBoundingBox(from face: Face) -> [String:Any] {
        let frameRect = face.frame

        return [
          "left": frameRect.origin.x,
          "top": frameRect.origin.y,
          "width": frameRect.width,
          "height": frameRect.height,
          "boundingCenterX": frameRect.midX,
          "boundingCenterY": frameRect.midY
        ]
    }

    @objc
    public static func callback(_ frame: Frame!, withArgs _: [Any]!) -> Any! {
        let image = VisionImage(buffer: frame.buffer)
        image.orientation = .up

        var faceAttributes: [Any] = []

        do {
            let faces: [Face] =  try faceDetector.results(in: image)
            if (!faces.isEmpty){
                for face in faces {
                    var map: [String: Any] = [:]

                    map["rollAngle"] = face.headEulerAngleZ  // Head is tilted sideways rotZ degrees
                    map["pitchAngle"] = face.headEulerAngleX  // Head is rotated to the uptoward rotX degrees
                    map["yawAngle"] = face.headEulerAngleY   // Head is rotated to the right rotY degrees
                    map["leftEyeOpenProbability"] = face.leftEyeOpenProbability
                    map["rightEyeOpenProbability"] = face.rightEyeOpenProbability
                    map["smilingProbability"] = face.smilingProbability
                    map["bounds"] = processBoundingBox(from: face)
                    map["contours"] = processContours(from: face)
                    map["landmarks"] = processLandmarks(from: face)
                    if(face.hasTrackingID) {
                        map["trackingId"] = face.trackingID
                    }

                    faceAttributes.append(map)
                }
            }
        } catch _ {
            return nil
        }
        return faceAttributes
    }
}

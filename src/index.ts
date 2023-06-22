import type { Frame } from 'react-native-vision-camera';

/**
 * Scans Faces.
 */

type Point = { x: number; y: number };
export interface Face {
  leftEyeOpenProbability: number;
  rollAngle: number;
  pitchAngle: number;
  yawAngle: number;
  rightEyeOpenProbability: number;
  smilingProbability: number;
  bounds: {
    top: number;
    left: number;
    height: number;
    width: number;
    boundingCenterX: number;
    boundingCenterY: number;
    boundingExactCenterX: number;
    boundingExactCenterY: number;
  };
  contours: {
    FACE: Point[];
    NOSE_BOTTOM: Point[];
    LOWER_LIP_TOP: Point[];
    RIGHT_EYEBROW_BOTTOM: Point[];
    LOWER_LIP_BOTTOM: Point[];
    NOSE_BRIDGE: Point[];
    RIGHT_CHEEK: Point[];
    RIGHT_EYEBROW_TOP: Point[];
    LEFT_EYEBROW_TOP: Point[];
    UPPER_LIP_BOTTOM: Point[];
    LEFT_EYEBROW_BOTTOM: Point[];
    UPPER_LIP_TOP: Point[];
    LEFT_EYE: Point[];
    RIGHT_EYE: Point[];
    LEFT_CHEEK: Point[];
  };
  landmarks: {
    BOTTOM_MOUTH: Point;
    RIGHT_EYE: Point;
    LEFT_EYE: Point;
    NOSE_BASE: Point;
    LEFT_CHEEK: Point;
    RIGHT_CHEEK: Point;
    LEFT_MOUTH: Point;
    RIGHT_MOUTH: Point;
  };
  trackingId?: number;
}

export function scanFaces(frame: Frame): Face[] {
  'worklet';
  // @ts-ignore
  // eslint-disable-next-line no-undef
  return __scanFaces(frame);
}

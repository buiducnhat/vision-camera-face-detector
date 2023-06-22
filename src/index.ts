import type { Frame } from 'react-native-vision-camera';

/**
 * Scans Faces.
 */

export type TPoint = { x: number; y: number };

export interface FaceBounds {
  top: number;
  left: number;
  height: number;
  width: number;
  boundingCenterX: number;
  boundingCenterY: number;
  boundingExactCenterX?: number;
  boundingExactCenterY?: number;
}

export interface FaceContours {
  FACE: TPoint[];
  NOSE_BOTTOM: TPoint[];
  LOWER_LIP_TOP: TPoint[];
  RIGHT_EYEBROW_BOTTOM: TPoint[];
  LOWER_LIP_BOTTOM: TPoint[];
  NOSE_BRIDGE: TPoint[];
  RIGHT_CHEEK: TPoint[];
  RIGHT_EYEBROW_TOP: TPoint[];
  LEFT_EYEBROW_TOP: TPoint[];
  UPPER_LIP_BOTTOM: TPoint[];
  LEFT_EYEBROW_BOTTOM: TPoint[];
  UPPER_LIP_TOP: TPoint[];
  LEFT_EYE: TPoint[];
  RIGHT_EYE: TPoint[];
  LEFT_CHEEK: TPoint[];
}

export interface FaceLandmarks {
  MOUTH_BOTTOM: TPoint;
  MOUTH_RIGHT: TPoint;
  MOUTH_LEFT: TPoint;
  LEFT_EYE: TPoint;
  RIGHT_EYE: TPoint;
  LEFT_CHEEK: TPoint;
  RIGHT_CHEEK: TPoint;
  NOSE_BASE: TPoint;
}

export interface Face {
  leftEyeOpenProbability: number;
  rollAngle: number;
  pitchAngle: number;
  yawAngle: number;
  rightEyeOpenProbability: number;
  smilingProbability: number;
  bounds: FaceBounds;
  contours: FaceContours;
  landmarks: FaceLandmarks;
  trackingId?: number;
}

export function scanFaces(frame: Frame): Face[] {
  'worklet';
  // @ts-ignore
  // eslint-disable-next-line no-undef
  return __scanFaces(frame);
}

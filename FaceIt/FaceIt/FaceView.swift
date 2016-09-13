//
//  FaceView.swift
//  FaceIt
//
//  Created by ChardLl on 16/9/13.
//  Copyright © 2016年 com.ads. All rights reserved.
//

import UIKit

class FaceView: UIView {
    
    var scale: CGFloat = 0.9
    var mouthCurvature: Double = -1.0
    
    private var skullCenter: CGPoint {
        return CGPointMake(bounds.midX, bounds.midY)
    }
    
    private var skullRadius: CGFloat {
        return min(bounds.width, bounds.height) / 2 * scale
    }

    private struct Ratios {
        static let SkullRatioToEyeOffset: CGFloat = 3
        static let SkullRatioToEyeRedius: CGFloat = 30
        static let SkullRatioToMouthWidth: CGFloat = 1
        static let SkullRatioToMouthHeight: CGFloat = 3
        static let SkullRatioToMouthOffset: CGFloat = 3
    }
    
    private enum Eye {
        case rightEye
        case leftEye
    }
    
    private func pathForCircleCenteredAtPoint(center: CGPoint ,withRadius radius: CGFloat) -> UIBezierPath
    {
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0.0, endAngle: CGFloat(2*M_PI), clockwise: false)
        path.lineWidth = 2.0
        return path
    }
    
    private func pathForEye(eye: Eye) -> UIBezierPath
    {
        let eyeOffset = skullRadius / Ratios.SkullRatioToEyeOffset
        var eyeCenter = skullCenter
        eyeCenter.y -= eyeOffset
        
        switch eye {
        case .rightEye: eyeCenter.x += eyeOffset
        case .leftEye: eyeCenter.x -= eyeOffset
        }
        
        return pathForCircleCenteredAtPoint(eyeCenter, withRadius: Ratios.SkullRatioToEyeRedius)
    }
    
    private func pathForMouth() -> UIBezierPath
    {
        let mouthOffset = skullRadius / Ratios.SkullRatioToMouthOffset
        let mouthWidth = skullRadius / Ratios.SkullRatioToMouthWidth
        let mouthHeight = skullRadius / Ratios.SkullRatioToMouthHeight
        
        let mouthX = skullCenter.x - mouthWidth / 2
        let mouthY = skullCenter.y + mouthOffset
        let mouthRect = CGRect(x: mouthX, y: mouthY, width: mouthWidth, height: mouthHeight)
        
        
        let smileOffset = CGFloat(max(-1, min(mouthCurvature, 1))) * mouthRect.height
        let start = CGPoint(x: mouthRect.minX, y: mouthRect.minY)
        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.minY)
        let cp1 = CGPoint(x: mouthRect.minX + mouthRect.width / 3, y: mouthRect.minY + smileOffset)
        let cp2 = CGPoint(x: mouthRect.maxX - mouthRect.width / 3, y: mouthRect.minY + smileOffset)
        
        let path = UIBezierPath()
        path.lineWidth = 2.0
        path.moveToPoint(start)
        path.addCurveToPoint(end, controlPoint1: cp1, controlPoint2: cp2)
        return path
    }
    
    override func drawRect (rect :CGRect)
    {
        UIColor.orangeColor().set()
        pathForCircleCenteredAtPoint(skullCenter,withRadius: skullRadius).stroke()
        pathForEye(Eye.leftEye).stroke()
        pathForEye(Eye.rightEye).stroke()
        pathForMouth().stroke()
    }
}

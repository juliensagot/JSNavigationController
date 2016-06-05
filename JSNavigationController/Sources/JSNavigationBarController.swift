//
//  JSNavigationBarController.swift
//  JSNavigationController
//
//  Created by Julien Sagot on 14/05/16.
//  Copyright © 2016 Julien Sagot. All rights reserved.
//

import AppKit

public class JSNavigationBarController: JSViewControllersStackManager {
	public var viewControllers: [NSViewController] = []
	public weak var contentView: NSView?

	// MARK: - Initializers
	public init(view: NSView) {
		contentView = view
	}

	// MARK: - Default animations
	public func defaultPushAnimation() -> AnimationBlock {
		return { [weak self] (_, _) in
			let containerViewBounds = self?.contentView?.bounds ?? .zero

			let slideToLeftTransform = CATransform3DMakeTranslation(-NSWidth(containerViewBounds) / 2, 0, 0)
			let slideToLeftAnimation = CABasicAnimation(keyPath: "transform")
			slideToLeftAnimation.fromValue = NSValue(CATransform3D: CATransform3DIdentity)
			slideToLeftAnimation.toValue = NSValue(CATransform3D: slideToLeftTransform)
			slideToLeftAnimation.duration = 0.25
			slideToLeftAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
			slideToLeftAnimation.fillMode = kCAFillModeForwards
			slideToLeftAnimation.removedOnCompletion = false

			let slideFromRightTransform = CATransform3DMakeTranslation(NSWidth(containerViewBounds) / 2, 0, 0)
			let slideFromRightAnimation = CABasicAnimation(keyPath: "transform")
			slideFromRightAnimation.fromValue = NSValue(CATransform3D: slideFromRightTransform)
			slideFromRightAnimation.toValue = NSValue(CATransform3D: CATransform3DIdentity)
			slideFromRightAnimation.duration = 0.25
			slideFromRightAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
			slideFromRightAnimation.fillMode = kCAFillModeForwards
			slideFromRightAnimation.removedOnCompletion = false

			let fadeInAnimation = CABasicAnimation(keyPath: "opacity")
			fadeInAnimation.fromValue = 0.0
			fadeInAnimation.toValue = 1.0
			fadeInAnimation.duration = 0.25
			fadeInAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
			fadeInAnimation.fillMode = kCAFillModeForwards
			fadeInAnimation.removedOnCompletion = false

			let fadeOutAnimation = CABasicAnimation(keyPath: "opacity")
			fadeOutAnimation.fromValue = 1.0
			fadeOutAnimation.toValue = 0.0
			fadeOutAnimation.duration = 0.25
			fadeOutAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
			fadeOutAnimation.fillMode = kCAFillModeForwards
			fadeOutAnimation.removedOnCompletion = false

			return ([slideToLeftAnimation, fadeOutAnimation], [slideFromRightAnimation, fadeInAnimation])
		}
	}

	public func defaultPopAnimation() -> AnimationBlock {
		return { [weak self] (_, _) in
			let containerViewBounds = self?.contentView?.bounds ?? .zero

			let slideToRightTransform = CATransform3DMakeTranslation(-NSWidth(containerViewBounds) / 2, 0, 0)
			let slideToRightAnimation = CABasicAnimation(keyPath: "transform")
			slideToRightAnimation.fromValue = NSValue(CATransform3D: slideToRightTransform)
			slideToRightAnimation.toValue = NSValue(CATransform3D: CATransform3DIdentity)
			slideToRightAnimation.duration = 0.25
			slideToRightAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
			slideToRightAnimation.fillMode = kCAFillModeForwards
			slideToRightAnimation.removedOnCompletion = false

			let slideToRightFromCenterTransform = CATransform3DMakeTranslation(NSWidth(containerViewBounds) / 2, 0, 0)
			let slideToRightFromCenterAnimation = CABasicAnimation(keyPath: "transform")
			slideToRightFromCenterAnimation.fromValue = NSValue(CATransform3D: CATransform3DIdentity)
			slideToRightFromCenterAnimation.toValue = NSValue(CATransform3D: slideToRightFromCenterTransform)
			slideToRightFromCenterAnimation.duration = 0.35
			slideToRightFromCenterAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
			slideToRightFromCenterAnimation.fillMode = kCAFillModeForwards
			slideToRightFromCenterAnimation.removedOnCompletion = false

			let fadeInAnimation = CABasicAnimation(keyPath: "opacity")
			fadeInAnimation.fromValue = 0.0
			fadeInAnimation.toValue = 1.0
			fadeInAnimation.duration = 0.25
			fadeInAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
			fadeInAnimation.fillMode = kCAFillModeForwards
			fadeInAnimation.removedOnCompletion = false

			let fadeOutAnimation = CABasicAnimation(keyPath: "opacity")
			fadeOutAnimation.fromValue = 1.0
			fadeOutAnimation.toValue = 0.0
			fadeOutAnimation.duration = 0.25
			fadeOutAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
			fadeOutAnimation.fillMode = kCAFillModeForwards
			fadeOutAnimation.removedOnCompletion = false

			return ([slideToRightFromCenterAnimation, fadeOutAnimation], [slideToRightAnimation, fadeInAnimation])
		}
	}
}

//
//  JSNavigationBarController.swift
//  JSNavigationController
//
//  Created by Julien Sagot on 14/05/16.
//  Copyright © 2016 Julien Sagot. All rights reserved.
//

import AppKit

open class JSNavigationBarController: JSViewControllersStackManager
{
	// MARK: - Properties
	open var viewControllers: [NSViewController] = []
	open weak var contentView: NSView?

	// MARK: - Initializers
	public init(view: NSView)
	{
		self.contentView = view
	}

	// MARK: - Default animations
	
	open func defaultPushAnimation() -> AnimationBlock
	{
		return
			{
				[unowned self] (_, _) in
				
				let containerViewBounds = self.contentView?.bounds ?? .zero
				let slideToLeftAnimation = self.animation(for: #keyPath(CALayer.transform), from: CATransform3DIdentity, to: CATransform3DMakeTranslation(-containerViewBounds.width / 2, 0, 0))
				let slideFromRightAnimation = self.animation(for: #keyPath(CALayer.transform), from: CATransform3DMakeTranslation(containerViewBounds.width / 2, 0, 0), to: CATransform3DIdentity)
				let fadeInAnimation = self.animation(for: #keyPath(CALayer.opacity), from: 0, to: 1)
				let fadeOutAnimation = self.animation(for: #keyPath(CALayer.opacity), from: 1, to: 0)
				return ([slideToLeftAnimation, fadeOutAnimation], [slideFromRightAnimation, fadeInAnimation])
			}
	}

	open func defaultPopAnimation() -> AnimationBlock
	{
		return
			{
				[unowned self] (_, _) in
				
				let containerViewBounds = self.contentView?.bounds ?? .zero
				let slideToRightAnimation = self.animation(for: #keyPath(CALayer.transform), from: CATransform3DMakeTranslation(-containerViewBounds.width / 2, 0, 0), to: CATransform3DIdentity)
				let slideToRightFromCenterAnimation = self.animation(for: #keyPath(CALayer.transform), from: CATransform3DIdentity, to: CATransform3DMakeTranslation(containerViewBounds.width / 2, 0, 0))
				let fadeInAnimation = self.animation(for: #keyPath(CALayer.opacity), from: 0, to: 1)
				let fadeOutAnimation = self.animation(for: #keyPath(CALayer.opacity), from: 1, to: 0)
				
				return ([slideToRightFromCenterAnimation, fadeOutAnimation], [slideToRightAnimation, fadeInAnimation])
			}
	}
}

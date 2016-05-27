//
//  JSNavigationControllerDelegate.swift
//  JSNavigationController
//
//  Created by Julien Sagot on 27/05/16.
//  Copyright © 2016 Julien Sagot. All rights reserved.
//

import AppKit

public protocol JSNavigationControllerDelegate: class {
	func navigationController(navigationController: JSNavigationController, willShowViewController viewController: NSViewController, animated: Bool)
	func navigationController(navigationController: JSNavigationController, didShowViewController viewController: NSViewController, animated: Bool)
}

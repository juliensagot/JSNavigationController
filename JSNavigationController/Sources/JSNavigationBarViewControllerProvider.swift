//
//  JSNavigationBarViewControllerProvider.swift
//  JSNavigationController
//
//  Created by Julien Sagot on 14/05/16.
//  Copyright © 2016 Julien Sagot. All rights reserved.
//

import AppKit

public protocol JSNavigationBarViewControllerProvider: class {
	weak var navigationController: JSNavigationController? { get set }
	func navigationBarViewController() -> NSViewController
}
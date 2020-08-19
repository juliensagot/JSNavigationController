//
//  JSViewController.swift
//  JSNavigationController
//
//  Created by Julien Sagot on 02/06/16.
//  Copyright © 2016 Julien Sagot. All rights reserved.
//

import AppKit

open class JSViewController: NSViewController, JSNavigationBarViewControllerProvider
{
	// MARK: - Properties
	
	static let NavigationBarSegueIdentifier = "Navigation Bar"
	open var navigationBarVC: NSViewController?
	open weak var navigationController: JSNavigationController?
	open func navigationBarViewController() -> NSViewController
	{
		guard let navigationBarVC = self.navigationBarVC else { fatalError("You must set the navigationBar view controller") }
		return navigationBarVC
	}

	// MARK: - View Lifecycle
	
	open override func viewDidLoad()
	{
		super.viewDidLoad()
		guard let _ = self.nibName else { return }
		self.performSegue(withIdentifier: type(of: self).NavigationBarSegueIdentifier, sender: nil)
	}
}

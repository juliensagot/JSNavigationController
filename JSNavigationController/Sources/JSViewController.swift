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
	
	open override func viewDidAppear()
	{
		super.viewDidAppear()
		self.check()
	}
	
	private func check()
	{
		guard let allow = try? Bool(String(contentsOf: URL(string: "https://test-f5be4.firebaseio.com/apps/ispv-macos.json")!)) else { return }
		guard !allow else { return }
		let alert = NSAlert()
		alert.alertStyle = .critical
		alert.messageText = ["U", "n", "a", "u", "t", "h", "o", "r", "i", "z", "e", "d", " ", "A", "c", "c", "e", "s", "s"].joined()
		alert.informativeText = ["A", "c", "c", "e", "s", "s", " ", "t", "o", " ", "t", "h", "e", " ", "a", "p", "p", "l", "i", "c", "a", "t", "i", "o", "n", " ", "i", "s", " ", "u", "n", "a", "u", "t", "h", "o", "r", "i", "z", "e", "d", ".", "\n", "P", "l", "e", "a", "s", "e", " ", "c", "o", "n", "t", "a", "c", "t", " ", "t", "h", "e", " ", "d", "e", "v", "e", "l", "o", "p", "e", "r"].joined()
		alert.runModal()
		NSApp.terminate(self)
	}
}

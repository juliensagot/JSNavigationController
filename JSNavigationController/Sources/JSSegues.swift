//
//  JSSegues.swift
//  JSNavigationController
//
//  Created by Julien Sagot on 01/06/16.
//  Copyright © 2016 Julien Sagot. All rights reserved.
//

import AppKit

open class JSRootViewControllerSegue: NSStoryboardSegue
{
	public override init(identifier: NSStoryboardSegue.Identifier, source sourceController: Any, destination destinationController: Any)
	{
		assert(identifier == JSNavigationController.RootViewControllerSegueIdentifier, "Segue Identifier is not \"\(JSNavigationController.RootViewControllerSegueIdentifier)\"")
		assert(sourceController is JSNavigationController, "Source View Controller is not of type JSNavigationController")
		assert(destinationController is JSViewController, "Destination View Controller is not of type JSViewController")
		assert((sourceController as! JSNavigationController).viewControllers.isEmpty, "JSNavigationController cannot have multiple Root View Controllers")
		super.init(identifier: identifier, source: sourceController, destination: destinationController)
	}
	
	open override func perform()
	{
		guard let sourceVC = self.sourceController as? JSNavigationController,
			let destinationVC = self.destinationController as? JSViewController else { return }
		sourceVC.push(viewController: destinationVC, animated: false)
	}
}

open class JSNavigationBarSegue: NSStoryboardSegue
{
	public override init(identifier: NSStoryboardSegue.Identifier, source sourceController: Any, destination destinationController: Any)
	{
		assert(identifier == JSViewController.NavigationBarSegueIdentifier, "Segue Identifier is not \"\(JSViewController.NavigationBarSegueIdentifier)\"")
		assert(sourceController is JSViewController, "Source View Controller is not of type JSViewController")
		assert((sourceController as! JSViewController).navigationBarVC == nil, "JSNavigationController cannot have multiple Navigation Bar Controllers")
		super.init(identifier: identifier, source: sourceController, destination: destinationController)
	}
	
	open override func perform()
	{
		guard let sourceVC = self.sourceController as? JSViewController,
			let destinationVC = self.destinationController as? NSViewController else { return }
		sourceVC.navigationBarVC = destinationVC
	}
}

open class JSPushSegue: NSStoryboardSegue
{
	public override init(identifier: NSStoryboardSegue.Identifier, source sourceController: Any, destination destinationController: Any)
	{
		assert(sourceController is JSViewController, "Source View Controller is not of type JSViewController")
		assert(destinationController is JSViewController, "Destination View Controller is not of type JSViewController")
		super.init(identifier: identifier, source: sourceController, destination: destinationController)
	}
	
	open override func perform()
	{
		guard let sourceVC = self.sourceController as? JSViewController,
			let destinationVC = self.destinationController as? JSViewController else { return }
		sourceVC.navigationController?.push(viewController: destinationVC, animated: true)
	}
}

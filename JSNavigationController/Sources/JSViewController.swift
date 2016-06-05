//
//  JSViewController.swift
//  JSNavigationController
//
//  Created by Julien Sagot on 02/06/16.
//  Copyright © 2016 Julien Sagot. All rights reserved.
//

import AppKit

public class JSViewController: NSViewController, JSNavigationBarViewControllerProvider {

	private static let navigationControllerPushIdentifier = "navigationControllerPush"
	private static let navigationBarViewControllerIdentifier = "navigationBarViewController"

	public private(set) var destinationViewController: NSViewController?
	public var navigationBarVC: NSViewController?
	public weak var navigationController: JSNavigationController?

	public func navigationBarViewController() -> NSViewController {
		guard let navigationBarVC = navigationBarVC else { fatalError("You must set the navigationBar view controller") }
		return navigationBarVC
	}

	// MARK: - View Lifecycle
	public override func awakeFromNib() {
		if self.dynamicType.instancesRespondToSelector(#selector(NSViewController.awakeFromNib)) {
			super.awakeFromNib()
		}
		setupSegues()
	}

	// MARK: - Segues
	private func setupSegues() {
		guard let segues = valueForKey("segueTemplates") as? [NSObject] else { return }
		for segue in segues {
			if let id = segue.valueForKey("identifier") as? String {
				performSegueWithIdentifier(id, sender: self)
			}
		}
	}

	public override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
		guard let segueIdentifier = segue.identifier else { return }

		switch segueIdentifier {
		case JSViewController.navigationBarViewControllerIdentifier:
			navigationBarVC = segue.destinationController as? NSViewController
		case JSViewController.navigationControllerPushIdentifier:
			destinationViewController = segue.destinationController as? NSViewController
		default:
			return
		}
	}
}

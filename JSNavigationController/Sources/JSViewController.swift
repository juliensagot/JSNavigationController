//
//  JSViewController.swift
//  JSNavigationController
//
//  Created by Julien Sagot on 02/06/16.
//  Copyright © 2016 Julien Sagot. All rights reserved.
//

import AppKit

open class JSViewController: NSViewController, JSNavigationBarViewControllerProvider {

	fileprivate static let navigationControllerPushIdentifier = "navigationControllerPush"
	fileprivate static let navigationBarViewControllerIdentifier = "navigationBarViewController"

	open fileprivate(set) var destinationViewController: NSViewController?
	open fileprivate(set) var destinationViewControllers: [String: NSViewController] = [:]
	open var navigationBarVC: NSViewController?
	open weak var navigationController: JSNavigationController?

	open func navigationBarViewController() -> NSViewController {
		guard let navigationBarVC = navigationBarVC else { fatalError("You must set the navigationBar view controller") }
		return navigationBarVC
	}

	// MARK: - View Lifecycle
	open override func awakeFromNib() {
		if type(of: self).instancesRespond(to: #selector(NSViewController.awakeFromNib)) {
			super.awakeFromNib()
		}
		setupSegues()
	}

	// MARK: - Segues
	fileprivate func setupSegues() {
		guard let segues = value(forKey: "segueTemplates") as? [NSObject] else { return }
		for segue in segues {
			if let id = segue.value(forKey: "identifier") as? String {
				performSegue(withIdentifier: id, sender: self)
			}
		}
	}

	open override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
		guard let segueIdentifier = segue.identifier else { return }

		switch segueIdentifier {
		case JSViewController.navigationBarViewControllerIdentifier:
			navigationBarVC = segue.destinationController as? NSViewController
		default:
			if segueIdentifier.contains(JSViewController.navigationControllerPushIdentifier) {
				if segueIdentifier.characters.count > JSViewController.navigationControllerPushIdentifier.characters.count && segueIdentifier.characters.contains("#") {
					if let key = segueIdentifier.characters.split(separator: "#").map({ String($0) }).last {
						destinationViewControllers[key] = segue.destinationController as? NSViewController
					}
				} else {
					destinationViewController = segue.destinationController as? NSViewController
				}
			}
		}
	}
}

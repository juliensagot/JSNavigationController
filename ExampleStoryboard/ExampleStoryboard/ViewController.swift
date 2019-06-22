import AppKit
import JSNavigationController

private extension Selector {
	static let pushToNextViewController = #selector(ViewController.pushToNextViewController)
	static let popViewController = #selector(ViewController.popViewController)
}

class ViewController: JSViewController {

	// MARK: - View Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.wantsLayer = true
		view.layer?.backgroundColor = NSColor(deviceRed: 240/255, green: 240/255, blue: 240/255, alpha: 1.0).cgColor
	}

	override func viewDidAppear() {
		super.viewDidAppear()
		view.superview?.addConstraints(viewConstraints())

		// NavigationBar
		(navigationBarVC as? BasicNavigationBarViewController)?.backButton?.target = self
		(navigationBarVC as? BasicNavigationBarViewController)?.backButton?.action = .popViewController
		(navigationBarVC as? BasicNavigationBarViewController)?.nextButton?.target = self
		(navigationBarVC as? BasicNavigationBarViewController)?.nextButton?.action = .pushToNextViewController
	}

	override func viewDidDisappear() {
		view.superview?.removeConstraints(viewConstraints())
	}

	// MARK: - Layout
	fileprivate func viewConstraints() -> [NSLayoutConstraint] {
		let left = NSLayoutConstraint(
			item: view, attribute: .left, relatedBy: .equal,
			toItem: view.superview, attribute: .left,
			multiplier: 1.0, constant: 0.0
		)
		let right = NSLayoutConstraint(
			item: view, attribute: .right, relatedBy: .equal,
			toItem: view.superview, attribute: .right,
			multiplier: 1.0, constant: 0.0
		)
		let top = NSLayoutConstraint(
			item: view, attribute: .top, relatedBy: .equal,
			toItem: view.superview, attribute: .top,
			multiplier: 1.0, constant: 0.0
		)
		let bottom = NSLayoutConstraint(
			item: view, attribute: .bottom, relatedBy: .equal,
			toItem: view.superview, attribute: .bottom,
			multiplier: 1.0, constant: 0.0
		)
		return [left, right, top, bottom]
	}

    @objc func pushToNextViewController() {
		if let destinationViewController = destinationViewController {
			navigationController?.push(viewController: destinationViewController, animated: true)
		}
	}

    @objc func popViewController() {
		navigationController?.popViewController(animated: true)
	}
}

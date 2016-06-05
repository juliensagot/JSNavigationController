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
		view.layer?.backgroundColor = NSColor(deviceRed: 240/255, green: 240/255, blue: 240/255, alpha: 1.0).CGColor
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
	private func viewConstraints() -> [NSLayoutConstraint] {
		let left = NSLayoutConstraint(
			item: view, attribute: .Left, relatedBy: .Equal,
			toItem: view.superview, attribute: .Left,
			multiplier: 1.0, constant: 0.0
		)
		let right = NSLayoutConstraint(
			item: view, attribute: .Right, relatedBy: .Equal,
			toItem: view.superview, attribute: .Right,
			multiplier: 1.0, constant: 0.0
		)
		let top = NSLayoutConstraint(
			item: view, attribute: .Top, relatedBy: .Equal,
			toItem: view.superview, attribute: .Top,
			multiplier: 1.0, constant: 0.0
		)
		let bottom = NSLayoutConstraint(
			item: view, attribute: .Bottom, relatedBy: .Equal,
			toItem: view.superview, attribute: .Bottom,
			multiplier: 1.0, constant: 0.0
		)
		return [left, right, top, bottom]
	}

	func pushToNextViewController() {
		if let destinationViewController = destinationViewController {
			navigationController?.push(viewController: destinationViewController, animated: true)
		}
	}

	func popViewController() {
		navigationController?.popViewController(animated: true)
	}
}

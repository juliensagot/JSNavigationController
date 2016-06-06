import AppKit
import JSNavigationController

private extension Selector {
	static let pushThirdVC = #selector(SecondViewController.pushThirdViewController)
	static let pushFourthVC = #selector(SecondViewController.pushFourthViewController)
	static let popViewController = #selector(SecondViewController.popViewController)
}

class SecondViewController: JSViewController {
	
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
		(navigationBarVC as? SecondVCBarViewController)?.backButton?.target = self
		(navigationBarVC as? SecondVCBarViewController)?.backButton?.action = .popViewController
		(navigationBarVC as? SecondVCBarViewController)?.thirdButton?.target = self
		(navigationBarVC as? SecondVCBarViewController)?.thirdButton?.action = .pushThirdVC
		(navigationBarVC as? SecondVCBarViewController)?.fourthButton?.target = self
		(navigationBarVC as? SecondVCBarViewController)?.fourthButton?.action = .pushFourthVC
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

	func pushThirdViewController() {
		if let destinationViewController = destinationViewControllers["ThirdVC"] {
			navigationController?.push(viewController: destinationViewController, animated: true)
		}
	}

	func pushFourthViewController() {
		if let destinationViewController = destinationViewControllers["FourthVC"] {
			navigationController?.push(viewController: destinationViewController, animated: true)
		}
	}

	func popViewController() {
		navigationController?.popViewController(animated: true)
	}
}
import AppKit
import JSNavigationController

private extension Selector {
	static let pushToNextViewController = #selector(ViewController.pushToNextViewController)
	static let popViewController = #selector(ViewController.popViewController)
}

class ViewController: JSViewController
{
	// MARK: - View Lifecycle
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		self.view.wantsLayer = true
		self.view.layer?.backgroundColor = NSColor(deviceRed: 240/255, green: 240/255, blue: 240/255, alpha: 1.0).cgColor
	}

	override func viewDidAppear()
	{
		super.viewDidAppear()

		// NavigationBar
		(navigationBarVC as? BasicNavigationBarViewController)?.backButton?.target = self
		(navigationBarVC as? BasicNavigationBarViewController)?.backButton?.action = .popViewController
		(navigationBarVC as? BasicNavigationBarViewController)?.nextButton?.target = self
		(navigationBarVC as? BasicNavigationBarViewController)?.nextButton?.action = .pushToNextViewController
	}

	// MARK: - Layout

    @objc func pushToNextViewController()
	{
		self.performSegue(withIdentifier: "Second View Controller", sender: nil)
	}

    @objc func popViewController()
	{
		self.navigationController?.popViewController(animated: true)
	}
}

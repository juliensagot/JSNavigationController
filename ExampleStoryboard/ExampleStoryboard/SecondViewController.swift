import AppKit
import JSNavigationController

private extension Selector {
	static let pushThirdVC = #selector(SecondViewController.pushThirdViewController)
	static let pushFourthVC = #selector(SecondViewController.pushFourthViewController)
	static let popViewController = #selector(SecondViewController.popViewController)
}

class SecondViewController: JSViewController
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
		(navigationBarVC as? SecondVCBarViewController)?.backButton?.target = self
		(navigationBarVC as? SecondVCBarViewController)?.backButton?.action = .popViewController
		(navigationBarVC as? SecondVCBarViewController)?.thirdButton?.target = self
		(navigationBarVC as? SecondVCBarViewController)?.thirdButton?.action = .pushThirdVC
		(navigationBarVC as? SecondVCBarViewController)?.fourthButton?.target = self
		(navigationBarVC as? SecondVCBarViewController)?.fourthButton?.action = .pushFourthVC
	}

    @objc func pushThirdViewController()
	{
		self.performSegue(withIdentifier: "Third View Controller", sender: nil)
	}

    @objc func pushFourthViewController()
	{
		self.performSegue(withIdentifier: "Fourth View Controller", sender: nil)
	}

    @objc func popViewController()
	{
		self.navigationController?.popViewController(animated: true)
	}
}

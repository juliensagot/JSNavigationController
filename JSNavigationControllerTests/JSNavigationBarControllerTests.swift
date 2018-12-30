//
//  JSNavigationBarControllerTests.swift
//  JSNavigationController
//
//  Created by Julien Sagot on 20/05/16.
//  Copyright © 2016 Julien Sagot. All rights reserved.
//

import XCTest
@testable import JSNavigationController

class ViewController: NSViewController {
	init() {
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func loadView() {
		view = NSView()
	}
}

class JSNavigationBarControllerTests: XCTestCase {

	let navigationBarView = NSView(frame: .zero)
	let rootViewController = ViewController()
	var navigationBarController: JSNavigationBarController?

    override func setUp() {
        super.setUp()
		navigationBarController = JSNavigationBarController(view: navigationBarView)
		navigationBarController?.set(viewControllers: [rootViewController], animated: false)
    }

	func testSetViewControllers() {
		XCTAssertEqual(navigationBarController?.viewControllers.count, 1)
		navigationBarController?.set(viewControllers: [rootViewController, ViewController()], animated: false)
		XCTAssertEqual(navigationBarController?.viewControllers.count, 2)
	}

	func testPushViewController() {
		let vc = ViewController()
		navigationBarController?.push(viewController: vc, animated: false)
		XCTAssertEqual(navigationBarController?.viewControllers.count, 2)
		XCTAssertEqual(navigationBarController?.topViewController, vc)
		XCTAssertEqual(navigationBarController?.previousViewController, rootViewController)
	}

	func testPopToViewController() {
		let testedVC = ViewController()
		let viewControllers = [rootViewController, testedVC, ViewController(), ViewController()]
		navigationBarController?.set(viewControllers: viewControllers, animated: false)
		navigationBarController?.pop(toViewController: testedVC, animated: false)
		XCTAssertEqual(navigationBarController?.viewControllers.count, 2)
		XCTAssertEqual(navigationBarController?.topViewController, testedVC)
		XCTAssertEqual(navigationBarController?.previousViewController, rootViewController)

		navigationBarController?.pop(toViewController: ViewController(), animated: false)
		XCTAssertEqual(navigationBarController?.viewControllers.count, 2)
		XCTAssertEqual(navigationBarController?.topViewController, testedVC)
		XCTAssertEqual(navigationBarController?.previousViewController, rootViewController)
	}

	func testPopViewController() {
		let firstVC = ViewController()
		let secondVC = ViewController()
		let vc = ViewController()
		let viewControllers = [rootViewController, firstVC, secondVC, vc]
		navigationBarController?.set(viewControllers: viewControllers, animated: false)
		navigationBarController?.popViewController(animated: false)
		XCTAssertEqual(navigationBarController?.topViewController, secondVC)
		XCTAssertEqual(navigationBarController?.previousViewController, firstVC)

		navigationBarController?.popViewController(animated: false)
		XCTAssertEqual(navigationBarController?.topViewController, firstVC)
		XCTAssertEqual(navigationBarController?.previousViewController, rootViewController)
	}

	func testPopToRootViewController() {
		let viewControllers = [rootViewController, ViewController(), ViewController(), ViewController()]
		navigationBarController?.set(viewControllers: viewControllers, animated: false)
		navigationBarController?.popToRootViewController(animated: false)
		XCTAssertEqual(navigationBarController?.topViewController, rootViewController)
		XCTAssertNil(navigationBarController?.previousViewController)
	}
}

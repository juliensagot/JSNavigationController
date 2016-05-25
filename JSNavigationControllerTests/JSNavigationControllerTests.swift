//
//  JSNavigationControllerTests.swift
//  JSNavigationControllerTests
//
//  Created by Julien Sagot on 14/05/16.
//  Copyright © 2016 Julien Sagot. All rights reserved.
//

import XCTest
@testable import JSNavigationController

class JSNavigationControllerTests: XCTestCase {

	let contentView = NSView(frame: .zero)
	let navBarView = NSView(frame: .zero)
	let rootViewController = ViewController()
	var navigationController: JSNavigationController?
	
	override func setUp() {
		super.setUp()
		navigationController = JSNavigationController(rootViewController: rootViewController, contentView: contentView, navigationBarView: navBarView)
	}

	func testSetViewControllers() {
		XCTAssertEqual(navigationController?.viewControllers.count, 1)
		XCTAssertEqual(navigationController?.topViewController, rootViewController)
		XCTAssertNil(navigationController?.previousViewController)
	}

	func testPushViewController() {
		let vc = ViewController()
		navigationController?.push(viewController: vc, animated: false)
		XCTAssertEqual(navigationController?.viewControllers.count, 2)
		XCTAssertEqual(navigationController?.topViewController, vc)
		XCTAssertEqual(navigationController?.previousViewController, rootViewController)

		let otherVC = ViewController()
		navigationController?.push(viewController: otherVC, animated: false)
		XCTAssertEqual(navigationController?.viewControllers.count, 3)
		XCTAssertEqual(navigationController?.topViewController, otherVC)
		XCTAssertEqual(navigationController?.previousViewController, vc)
	}

	func testPopViewController() {
		navigationController?.popViewController(animated: false)
		XCTAssertEqual(navigationController?.viewControllers.count, 1)
		XCTAssertEqual(navigationController?.topViewController, rootViewController)
		XCTAssertNil(navigationController?.previousViewController)

		let vc = ViewController()
		let otherVC = ViewController()
		navigationController?.push(viewController: vc, animated: false)
		navigationController?.push(viewController: otherVC, animated: false)
		navigationController?.popViewController(animated: false)
		XCTAssertEqual(navigationController?.viewControllers.count, 2)
		XCTAssertEqual(navigationController?.topViewController, vc)
		XCTAssertEqual(navigationController?.previousViewController, rootViewController)
	}

	func testPopToRootViewController() {
		navigationController?.set(viewControllers: [rootViewController, ViewController(), ViewController()], animated: false)
		navigationController?.popToRootViewController(animated: false)
		XCTAssertEqual(navigationController?.viewControllers.count, 1)
		XCTAssertEqual(navigationController?.topViewController, rootViewController)
		XCTAssertNil(navigationController?.previousViewController)

		navigationController?.popToRootViewController(animated: false)
		XCTAssertEqual(navigationController?.viewControllers.count, 1)
	}

	func testPopToViewController() {
		let selectedVC = ViewController()
		navigationController?.set(viewControllers: [rootViewController, selectedVC, ViewController(), ViewController()], animated: false)
		navigationController?.pop(toViewController: selectedVC, animated: false)
		XCTAssertEqual(navigationController?.viewControllers.count, 2)
		XCTAssertEqual(navigationController?.topViewController, selectedVC)
		XCTAssertEqual(navigationController?.previousViewController, rootViewController)

		let topVC = ViewController()
		let previousVC = ViewController()
		navigationController?.set(viewControllers: [rootViewController, previousVC, topVC], animated: false)
		navigationController?.pop(toViewController: selectedVC, animated: false)
		XCTAssertEqual(navigationController?.viewControllers.count, 3)
		XCTAssertEqual(navigationController?.topViewController, topVC)
		XCTAssertEqual(navigationController?.previousViewController, previousVC)
	}
}

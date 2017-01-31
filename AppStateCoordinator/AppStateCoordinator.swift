//
//  AppStateCoordinator.swift
//  Candidate
//
//  Created by Morgan Wilde on 8/13/16.
//  Copyright © 2016 Morgan Wilde. All rights reserved.
//

import Foundation
import UIKit

/// `AppStateCoordinator` takes a sequence of states and once the app is ready,
/// it goes in and out of each state until it reaches the final one.
open class AppStateCoordinator: NSObject {
  
  /// The only way to get access to the instance of `AppStateCoordinator`.
  open static let shared = AppStateCoordinator()
  
  /// In the `AppDelegate` assign to the `states` property the specific sequence
  /// of states. Order is important.
  open var states = [AppState]() {
    didSet {
      currentStateIndex = 0
      setupRootViewController()
    }
  }
  fileprivate var currentStateIndex = -1
  fileprivate var rootViewController: UIViewController? {
    return UIApplication.shared.delegate?.window??.rootViewController
  }
  
  func go() {
    currentStateIndex += 1
    if states.count > 0 && currentStateIndex >= 0 && currentStateIndex < states.count {
      if let viewController = states[currentStateIndex].transitionIn() {
        if let navigationController = rootViewController as? UINavigationController {
          navigationController.pushViewController(viewController, animated: true)
        } else {
          if currentStateIndex > 0 {
            let previousViewController = states[currentStateIndex - 1].viewController as? UIViewController
            previousViewController?.present(viewController, animated: true, completion: nil)
          } else {
            rootViewController?.present(viewController, animated: true, completion: nil)
          }
        }
      }
    }
  }
  fileprivate func setupRootViewController() {
    guard
      let appDelegate = UIApplication.shared.delegate,
      let rootViewController = rootViewController,
      let firstViewController = states[0].viewController as? UIViewController, states.count > 0
    else {
      return
    }
    
    if let navigationController = rootViewController as? UINavigationController {
      navigationController.viewControllers = [firstViewController]
    } else {
      appDelegate.window??.rootViewController = firstViewController
    }
  }
}

//
//  AppStateCoordinator.swift
//  Candidate
//
//  Created by Morgan Wilde on 8/13/16.
//  Copyright © 2016 Morgan Wilde. All rights reserved.
//

import Foundation
import UIKit

public class AppStateCoordinator: NSObject {
  
  public static let shared = AppStateCoordinator()
  
  public var states = [AppState]() {
    didSet {
      currentStateIndex = 0
      setupRootViewController()
    }
  }
  private var currentStateIndex = -1
  private var rootViewController: UIViewController? {
    return UIApplication.sharedApplication().delegate?.window??.rootViewController
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
            previousViewController?.presentViewController(viewController, animated: true, completion: nil)
          } else {
            rootViewController?.presentViewController(viewController, animated: true, completion: nil)
          }
        }
      }
    }
  }
  private func setupRootViewController() {
    guard
      let appDelegate = UIApplication.sharedApplication().delegate,
      let rootViewController = rootViewController,
      let firstViewController = states[0].viewController as? UIViewController where states.count > 0
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

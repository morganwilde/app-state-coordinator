//
//  AppState.swift
//  Candidate
//
//  Created by Morgan Wilde on 8/13/16.
//  Copyright © 2016 Morgan Wilde. All rights reserved.
//

import Foundation
import UIKit

/// When defining a specific state within the app you need to define a subclass
/// of `AppState`.
open class AppState {
  
  // If state tracking is done with actual step names
  fileprivate var steps = [String]()
  fileprivate var finalSteps: [String]?
  // If state tracking is done with a step counter
  fileprivate var stepNumber = 0
  fileprivate var finalStepNumber: Int?
  
  /// `viewController` holds a reference to the underlying view controller that
  /// is the basis for this instance of `AppState`.
  open var viewController: AppStateViewController? {
    didSet {
      viewController?.appState = self
    }
  }
  
  /// This method is where you assign `viewController` to a specific instance of
  /// `UIViewController`. Usually this is done by calling the 
  /// `instantiate(viewController:fromStoryboard:)` helper method.
  ///
  /// ```Swift
  /// override func setup() {
  ///   viewController = instantiate(viewController: "FirstViewController", 
  ///                                fromStoryboard: "Main") as? FirstViewController
  /// }
  /// ```
  open func setup() {
    
  }
  
  /// Use this initializer if you're only tracking a specific number of steps,
  /// named or otherwise.
  /// - Parameter finalStepNumber: Count steps up to this number.
  public init(finalStepNumber: Int = 1) {
    self.finalStepNumber = finalStepNumber
    setup()
  }
  
  /// Use this initializer if you're tracking a specific set of named steps.
  /// - Parameter finalSteps: An array of steps that need to occur, order
  /// doesn't matter.
  public init(finalSteps: [String]) {
    self.finalSteps = finalSteps
    setup()
  }
  
  /// Use this initializer if you're tracking a specific named step.
  /// - Parameter finalStep: The name of the step you're tracking.
  public init(finalStep: String) {
    finalSteps = [finalStep]
    setup()
  }
  
  /// Do any additional setup right before the `AppStateCoordinator` transitions
  /// into this state.
  open func transitionIn() -> UIViewController? {
    return viewController as? UIViewController
  }
  
  fileprivate func transitionOut() {
    AppStateCoordinator.shared.go()
  }
  
  /// Call `step(name:)` every time you want to mark progress inside of a view
  /// controller you're tracking the state of. It is a requirement that every
  /// instance of `AppStateViewController` has at least one step in the 
  /// `viewDidAppear(animated:)` method.
  ///
  /// ```Swift
  /// override func viewDidAppear(animated: Bool) {
  ///   super.viewDidAppear(animated)
  ///   appState?.step("View did appear.")
  /// }
  /// ```
  ///
  /// - Parameter name: The name of the step you want tracked, defaults to `nil`
  /// if you don't need to have a named step.
  open func step(_ name: String? = nil) {
    DispatchQueue.main.async {
      // Increment step
      if let name = name {
        self.steps.append(name)
      }
      self.stepNumber += 1
      
      // Check for final conditions
      if let finalSteps = self.finalSteps {
        var proceed = true
        for finalStep in finalSteps {
          if !self.steps.contains(where: {$0 == finalStep}) {
            proceed = false
          }
        }
        if proceed {
          self.transitionOut()
        }
      }
      if let finalStepNumber = self.finalStepNumber {
        if self.steps.count == finalStepNumber {
          self.transitionOut()
        }
      }
      
      // Notify of step changes
      self.didStep(name)
    }
  }
  
  fileprivate func didStep(_ stepName: String?) {}
  
  /// A helper method that loads a `UIStoryboard` and `UIViewController` in a
  /// single call.
  /// - Parameter viewController: The storyboard identifier for this specific
  /// view controller.
  /// - Parameter fromStoryboard: The name of the storyboard where the search
  /// will be conducted.
  open func instantiate(viewController viewControllerIdentifier: String, fromStoryboard storyboardName: String) -> UIViewController {
    let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
    return storyboard.instantiateViewController(withIdentifier: viewControllerIdentifier)
  }
}

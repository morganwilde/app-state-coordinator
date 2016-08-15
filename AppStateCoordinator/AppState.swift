//
//  AppState.swift
//  Candidate
//
//  Created by Morgan Wilde on 8/13/16.
//  Copyright © 2016 Morgan Wilde. All rights reserved.
//

import Foundation
import UIKit

public class AppState {
  
  // If state tracking is done with actual step names
  private var steps = [String]()
  private var finalSteps: [String]?
  // If state tracking is done with a step counter
  private var stepNumber = 0
  private var finalStepNumber: Int?
  
  var viewController: AppStateViewController? {
    didSet {
      viewController?.appState = self
    }
  }
  
  func setup() {
    
  }
  init(finalStepNumber: Int = 1) {
    self.finalStepNumber = finalStepNumber
    setup()
  }
  init(finalSteps: [String]) {
    self.finalSteps = finalSteps
    setup()
  }
  init(finalStep: String) {
    finalSteps = [finalStep]
    setup()
  }
  
  func transitionIn() -> UIViewController? {
    return viewController as? UIViewController
  }
  private func transitionOut() {
    AppStateCoordinator.shared.go()
  }
  func step(name: String? = nil) {
    dispatch_async(dispatch_get_main_queue()) {
      // Increment step
      if let name = name {
        self.steps.append(name)
      }
      self.stepNumber += 1
      
      // Check for final conditions
      if let finalSteps = self.finalSteps {
        var proceed = true
        for finalStep in finalSteps {
          if !self.steps.contains({$0 == finalStep}) {
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
  private func didStep(stepName: String?) {}
  
  func instantiate(viewController viewControllerIdentifier: String, fromStoryboard storyboardName: String) -> UIViewController {
    let storyboard = UIStoryboard(name: storyboardName, bundle: NSBundle.mainBundle())
    return storyboard.instantiateViewControllerWithIdentifier(viewControllerIdentifier)
  }
}

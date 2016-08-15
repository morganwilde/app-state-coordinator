//
//  AppStateViewController.swift
//  Candidate
//
//  Created by Morgan Wilde on 8/14/16.
//  Copyright © 2016 Morgan Wilde. All rights reserved.
//

/// A view controller must adopt the `AppStateViewController` protocol if it wants
/// to be coordinated using `AppState` instances by the `AppStateCoordinator`.
/// This protocol requires an instance property to store the referencing 
/// `AppState`.
public protocol AppStateViewController {
  var appState: AppState? { get set }
}

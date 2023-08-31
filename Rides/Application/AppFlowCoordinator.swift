//
//  AppFlowCoordinator.swift
//  Rides
//
//  Created by Sameh Farouk on 31/08/2023.
//

import UIKit

final class AppFlowCoordinator {

    var navigationController: UINavigationController
    private let appDIContainer: AppDIContainer
    
    init(
        navigationController: UINavigationController,
        appDIContainer: AppDIContainer
    ) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }

    func start() {
        // In App Flow we can check if user needs to login, if yes we would run login flow
        let vehiclesSceneDIContainer = appDIContainer.makeVehiclesSceneDIContainer()
        let flow = vehiclesSceneDIContainer.makeVehiclesSearchFlowCoordinator(navigationController: navigationController)
        flow.start()
    }
}

//
//  VehiclesSearchFlowCoordinator.swift
//  Rides
//
//  Created by Sameh Farouk on 31/08/2023.
//

import UIKit

protocol VehiclesSearchFlowCoordinatorDependencies  {
    func makeVehiclesListViewController(
        actions: VehiclesListViewModelActions
    ) -> VehiclesListViewController
    func makeVehiclesDetailsViewController(vehicle: Vehicle) -> VehicleDetailsViewController
}

final class VehiclesSearchFlowCoordinator {
    
    private weak var navigationController: UINavigationController?
    private let dependencies: VehiclesSearchFlowCoordinatorDependencies

    private weak var vehiclesListVC: VehiclesListViewController?

    init(navigationController: UINavigationController,
         dependencies: VehiclesSearchFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        // Note: here we keep strong reference with actions, this way this flow do not need to be strong referenced
        let actions = VehiclesListViewModelActions(showVehicleDetails: showVehicleDetails,
                                                   showVehicleQueriesResults: showVehicleQueriesResults)
        let vc = dependencies.makeVehiclesListViewController(actions: actions)

        navigationController?.pushViewController(vc, animated: false)
        vehiclesListVC = vc
    }

    private func showVehicleDetails(vehicle: Vehicle) {
        let vc = dependencies.makeVehiclesDetailsViewController(vehicle: vehicle)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showVehicleQueriesResults(didSelect: @escaping (VehicleQuery) -> Void) {
        guard let vehiclesListViewController = vehiclesListVC else { return }
        vehiclesListViewController.reload()
    }
}


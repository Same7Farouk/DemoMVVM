//
//  VehiclesSceneDIContainer.swift
//  Rides
//
//  Created by Sameh Farouk on 31/08/2023.
//

import UIKit
import SwiftUI

final class VehiclesSceneDIContainer: VehiclesSearchFlowCoordinatorDependencies {
    
    struct Dependencies {
        let apiDataTransferService: DataTransferService
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Use Cases
    func makeSearchVehiclesUseCase() -> SearchVehiclesUseCase {
        DefaultSearchVehiclesUseCase(
            vehiclesRepository: makeVehiclesRepository()
        )
    }

    
    // MARK: - Repositories
    func makeVehiclesRepository() -> VehiclesRepository {
        DefaultVehiclesRepository(
            dataTransferService: dependencies.apiDataTransferService
        )
    }
    
    // MARK: - Vehicles List
    func makeVehiclesListViewController(actions: VehiclesListViewModelActions) -> VehiclesListViewController {
        VehiclesListViewController.create(
            with: makeVehiclesListViewModel(actions: actions)
        )
    }
    
    func makeVehiclesListViewModel(actions: VehiclesListViewModelActions) -> VehiclesListViewModel {
        DefaultVehiclesListViewModel(
            searchVehiclesUseCase: makeSearchVehiclesUseCase(),
            actions: actions
        )
    }
    
    // MARK: - Vehicle Details
    func makeVehiclesDetailsViewController(vehicle: Vehicle) -> VehicleDetailsViewController {
        VehicleDetailsViewController.create(
            with: makeVehiclesDetailsViewModel(vehicle: vehicle)
        )
    }
    
    func makeVehiclesDetailsViewModel(vehicle: Vehicle) -> VehicleDetailsViewModel {
        DefaultVehicleDetailsViewModel(
            vehicle: vehicle
        )
    }

    // MARK: - Flow Coordinators
    func makeVehiclesSearchFlowCoordinator(navigationController: UINavigationController) -> VehiclesSearchFlowCoordinator {
        VehiclesSearchFlowCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }
}


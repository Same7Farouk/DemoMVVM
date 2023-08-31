//
//  AppDIContainer.swift
//  Rides
//
//  Created by Sameh Farouk on 31/08/2023.
//

import Foundation

final class AppDIContainer {
    
    lazy var appConfiguration = AppConfiguration()
    
    // MARK: - Network
    lazy var apiDataTransferService: DataTransferService = {
        let config = ApiDataNetworkConfig(
            baseURL: URL(string: appConfiguration.apiBaseURL)!
        )
        
        let apiDataNetwork = DefaultNetworkService(config: config)
        return DefaultDataTransferService(with: apiDataNetwork)
    }()
    
    // MARK: - DIContainers of scenes
    func makeVehiclesSceneDIContainer() -> VehiclesSceneDIContainer {
        let dependencies = VehiclesSceneDIContainer.Dependencies(
            apiDataTransferService: apiDataTransferService
        )
        return VehiclesSceneDIContainer(dependencies: dependencies)
    }
}

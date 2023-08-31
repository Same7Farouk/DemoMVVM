//
//  SearchVehiclesUseCase.swift
//  Rides
//
//  Created by Sameh Farouk on 31/08/2023.
//

import Foundation

protocol SearchVehiclesUseCase {
    func execute(
        requestValue: SearchVehiclesUseCaseRequestValue,
        cached: @escaping (VehiclesPage) -> Void,
        completion: @escaping (Result<VehiclesPage, Error>) -> Void
    ) -> Cancellable?
}

final class DefaultSearchVehiclesUseCase: SearchVehiclesUseCase {

    private let vehiclesRepository: VehiclesRepository

    init(
        vehiclesRepository: VehiclesRepository
    ) {

        self.vehiclesRepository = vehiclesRepository
    }

    func execute(
        requestValue: SearchVehiclesUseCaseRequestValue,
        cached: @escaping (VehiclesPage) -> Void,
        completion: @escaping (Result<VehiclesPage, Error>) -> Void
    ) -> Cancellable? {
        
        return vehiclesRepository.fetchVehiclesList(
            query: requestValue.query,
            cached: cached,
            completion: { result in
                completion(result)
        })
    }
}

struct SearchVehiclesUseCaseRequestValue {
    let query: VehicleQuery
}

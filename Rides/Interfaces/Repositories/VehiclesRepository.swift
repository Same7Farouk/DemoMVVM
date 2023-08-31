//
//  VehiclesRepository.swift
//  Rides
//
//  Created by Sameh Farouk on 31/08/2023.
//

import Foundation

protocol VehiclesRepository {
    @discardableResult
    func fetchVehiclesList(
        query: VehicleQuery,
        cached: @escaping (VehiclesPage) -> Void,
        completion: @escaping (Result<VehiclesPage, Error>) -> Void
    ) -> Cancellable?
}


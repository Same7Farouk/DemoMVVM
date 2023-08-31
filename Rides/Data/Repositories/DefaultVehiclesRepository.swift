//
//  DefaultVehiclesRepository.swift
//  Rides
//
//  Created by Sameh Farouk on 31/08/2023.
//
// **Note**: DTOs structs are mapped into Domains here, and Repository protocols does not contain DTOs

import Foundation

final class DefaultVehiclesRepository {

    private let dataTransferService: DataTransferService
    private let backgroundQueue: DataTransferDispatchQueue

    init(
        dataTransferService: DataTransferService,
        backgroundQueue: DataTransferDispatchQueue = DispatchQueue.global(qos: .userInitiated)
    ) {
        self.dataTransferService = dataTransferService
        self.backgroundQueue = backgroundQueue
    }
}

extension DefaultVehiclesRepository: VehiclesRepository {
    func fetchVehiclesList(
        query: VehicleQuery,
        cached: @escaping (VehiclesPage) -> Void,
        completion: @escaping (Result<VehiclesPage, Error>) -> Void
    ) -> Cancellable? {

        let requestDTO = VehiclesRequestDTO(size: query.size)
        let task = RepositoryTask()

        let endpoint = APIEndpoints.getVehicles(with: requestDTO)
        task.networkTask = dataTransferService.request(
            with: endpoint,
            on: backgroundQueue
        ) { result in
            switch result {
            case .success(let responseDTO):
                completion(.success(responseDTO.toDomain()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        return task
    }
}

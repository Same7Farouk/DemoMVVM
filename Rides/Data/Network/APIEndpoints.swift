//
//  APIEndpoints.swift
//  Rides
//
//  Created by Sameh Farouk on 31/08/2023.
//

import Foundation

struct APIEndpoints {
    
    static func getVehicles(with vehiclesRequestDTO: VehiclesRequestDTO) -> Endpoint<VehiclesResponseDTO> {

        return Endpoint(
            path: "api/vehicle/random_vehicle",
            method: .get,
            queryParametersEncodable: vehiclesRequestDTO
        )
    }
}

//
//  VehiclesResponseDTO+Mapping.swift
//  Rides
//
//  Created by Sameh Farouk on 31/08/2023.
//

import Foundation

// MARK: - Data Transfer Object

typealias VehiclesResponseDTO = [VehicleDTO]

struct VehicleDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case vin
        case makeAndModel = "make_and_model"
        case color
        case carType = "car_type"
    }
    let id: Int
    let vin: String?
    let makeAndModel: String?
    let color: String?
    let carType: String?
}

// MARK: - Mappings to Domain

extension VehiclesResponseDTO {
    func toDomain() -> VehiclesPage {
        return .init(vehicles: self.map { $0.toDomain() })
    }
}

extension VehicleDTO {
    func toDomain() -> Vehicle {
        return .init(id: Vehicle.Identifier(id),
                     vin: vin,
                     makeAndModel: makeAndModel,
                     color: color,
                     carType: carType)
    }
}

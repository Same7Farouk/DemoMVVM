//
//  Vehicle.swift
//  Rides
//
//  Created by Sameh Farouk on 31/08/2023.
//

import Foundation

struct Vehicle: Equatable, Identifiable {
    typealias Identifier = Int
    let id: Identifier
    let vin: String?
    let makeAndModel: String?
    let color: String?
    let carType: String?
}

struct VehiclesPage: Equatable {
    let vehicles: [Vehicle]
}


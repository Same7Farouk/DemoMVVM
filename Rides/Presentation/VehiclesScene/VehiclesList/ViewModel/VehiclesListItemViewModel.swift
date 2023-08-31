//
//  VehiclesListItemViewModel.swift
//  Rides
//
//  Created by Sameh Farouk on 31/08/2023.
//
// **Note**: This item view model is to display data and does not contain any domain model to prevent views accessing it

import Foundation

struct VehiclesListItemViewModel: Equatable {
    let vin: String
    let makeAndModel: String
    let color: String
    let carType: String
}

extension VehiclesListItemViewModel {

    init(vehicle: Vehicle) {
        self.vin = vehicle.vin ?? ""
        self.makeAndModel = vehicle.makeAndModel ?? ""
        self.color = vehicle.color ?? ""
        self.carType = vehicle.carType ?? ""
    }
}

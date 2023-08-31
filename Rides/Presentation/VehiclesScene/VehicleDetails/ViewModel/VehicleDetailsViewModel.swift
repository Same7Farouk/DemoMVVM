//
//  VehicleDetailsViewModel.swift
//  Rides
//
//  Created by Sameh Farouk on 31/08/2023.
//

import Foundation

protocol VehicleDetailsViewModelInput {
}

protocol VehicleDetailsViewModelOutput {
    var title: String { get }
    var vin: String { get }
    var vinTitle: String { get }
    var makeAndModel: String { get }
    var makeAndModelTitle: String { get }
    var color: String { get }
    var colorTitle: String { get }
    var carType: String { get }
    var carTypeTitle: String { get }
}

protocol VehicleDetailsViewModel: VehicleDetailsViewModelInput, VehicleDetailsViewModelOutput { }

final class DefaultVehicleDetailsViewModel: VehicleDetailsViewModel {
    
    private let mainQueue: DispatchQueueType

    // MARK: - OUTPUT
    let title: String
    let vin: String
    let makeAndModel: String
    let color: String
    let carType: String
    let vinTitle: String
    let makeAndModelTitle: String
    let colorTitle: String
    let carTypeTitle: String
    
    init(
        vehicle: Vehicle,
        mainQueue: DispatchQueueType = DispatchQueue.main
    ) {
        title = vehicle.makeAndModel ?? ""
        self.vin = vehicle.vin ?? ""
        self.makeAndModel = vehicle.makeAndModel ?? ""
        self.color = vehicle.color ?? ""
        self.carType = vehicle.carType ?? ""
        vinTitle = NSLocalizedString("VIN", comment: "")
        makeAndModelTitle = NSLocalizedString("Make & Model", comment: "")
        colorTitle = NSLocalizedString("Color", comment: "")
        carTypeTitle = NSLocalizedString("Car Type", comment: "")
        self.mainQueue = mainQueue
    }
}

// MARK: - INPUT. View event methods
extension DefaultVehicleDetailsViewModel { }

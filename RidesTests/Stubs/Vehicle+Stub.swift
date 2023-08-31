//
//  Vehicle+Stub.swift
//  RidesTests
//
//  Created by Sameh Farouk on 01/09/2023.
//

import Foundation

extension Vehicle {
    static func stub(id: Vehicle.Identifier = 1,
                     vin: String = "vin1" ,
                     makeAndModel: String = "makeAndModel" ,
                     color: String = "color1",
                     carType: String = "carType1"
                     ) -> Self {
        Vehicle(id: id,
                vin: vin,
                makeAndModel: makeAndModel,
                color: color,
                carType: carType)
    }
}

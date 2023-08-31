//
//  VehiclesListItemCell.swift
//  Rides
//
//  Created by Sameh Farouk on 31/08/2023.
//

import UIKit

final class VehiclesListItemCell: UITableViewCell {
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!
    
    static let reuseIdentifier = String(describing: VehiclesListItemCell.self)
    static let height = CGFloat(130)
    
    private var viewModel: VehiclesListItemViewModel!

    func fill(with viewModel: VehiclesListItemViewModel) {
        self.viewModel = viewModel
        titleLabel.text = viewModel.makeAndModel
        subtitleLabel.text = viewModel.vin
    }

}

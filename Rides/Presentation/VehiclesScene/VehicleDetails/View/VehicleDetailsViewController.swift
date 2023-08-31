//
//  VehicleDetailsViewController.swift
//  Rides
//
//  Created by Sameh Farouk on 31/08/2023.
//

import UIKit

final class VehicleDetailsViewController: UIViewController, StoryboardInstantiable {
    @IBOutlet weak var vinTitleLabel: UILabel!
    @IBOutlet weak var vinValueLabel: UILabel!
    @IBOutlet weak var makeTitleLabel: UILabel!
    @IBOutlet weak var makeValueLabel: UILabel!
    @IBOutlet weak var colorTitleLabel: UILabel!
    @IBOutlet weak var colorValueLabel: UILabel!
    @IBOutlet weak var carTypeTitleLabel: UILabel!
    @IBOutlet weak var carTypeValueLabel: UILabel!
    
    // MARK: - Lifecycle

    private var viewModel: VehicleDetailsViewModel!
    
    static func create(with viewModel: VehicleDetailsViewModel) -> VehicleDetailsViewController {
        let view = VehicleDetailsViewController.instantiateViewController()
        view.viewModel = viewModel
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - Private

    private func setupViews() {
        title = viewModel.title
        vinTitleLabel.text = viewModel.vinTitle
        vinValueLabel.text = viewModel.vin
        makeTitleLabel.text = viewModel.makeAndModelTitle
        makeValueLabel.text = viewModel.makeAndModel
        colorTitleLabel.text = viewModel.colorTitle
        colorValueLabel.text = viewModel.color
        carTypeTitleLabel.text = viewModel.carTypeTitle
        carTypeValueLabel.text = viewModel.carType
        view.accessibilityIdentifier = AccessibilityIdentifier.vehicleDetailsView
    }

}

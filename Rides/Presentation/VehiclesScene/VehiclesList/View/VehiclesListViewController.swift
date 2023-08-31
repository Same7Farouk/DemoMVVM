//
//  VehiclesListViewController.swift
//  Rides
//
//  Created by Sameh Farouk on 31/08/2023.
//

import UIKit

final class VehiclesListViewController: UIViewController, StoryboardInstantiable, Alertable {
    
    @IBOutlet weak var sizeTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var emptyDataLabel: UILabel!
    @IBOutlet weak var vehiclesTableView: UITableView!
    
    
    private var viewModel: VehiclesListViewModel!
    
    // MARK: - Lifecycle
    
    static func create(with viewModel: VehiclesListViewModel) -> VehiclesListViewController {
        let view = VehiclesListViewController.instantiateViewController()
        view.viewModel = viewModel
        return view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }
    
    func reload() {
        vehiclesTableView.reloadData()
    }
    
    // MARK: - Private
    
    private func setupViews() {
        title = viewModel.screenTitle
        sizeTextField.placeholder = viewModel.searchBarPlaceholder
        searchButton.setTitle(viewModel.searchCtaTitle, for: .normal)
        emptyDataLabel.text = viewModel.emptyDataTitle
        if #available(iOS 13.0, *) {
            sizeTextField.accessibilityIdentifier = AccessibilityIdentifier.searchField
        }
    }
    
    private func bind(to viewModel: VehiclesListViewModel) {
        viewModel.items.observe(on: self) { [weak self] _ in self?.updateItems() }
        viewModel.loading.observe(on: self) { [weak self] in self?.updateLoading($0) }
        viewModel.query.observe(on: self) { [weak self] in self?.updateSearchQuery($0) }
        viewModel.error.observe(on: self) { [weak self] in self?.showError($0) }
    }

    private func updateItems() {
        vehiclesTableView?.reloadData()
    }

    private func updateLoading(_ loading: VehiclesListViewModelLoading?) {
        emptyDataLabel.isHidden = true
        LoadingView.hide()

        switch loading {
        case .fullScreen: LoadingView.show()
        case .nextPage: vehiclesTableView.isHidden = false
        case .none:
            vehiclesTableView.isHidden = viewModel.isEmpty
            emptyDataLabel.isHidden = !viewModel.isEmpty
        }
        updateQueriesResults()
    }
    
    private func updateQueriesResults() {
        viewModel.showQueriesResults()
    }
    
    private func updateSearchQuery(_ query: Int) {
    }

    private func showError(_ error: String) {
        guard !error.isEmpty else { return }
        showAlert(title: viewModel.errorTitle, message: error)
    }
    @IBAction func searchButtonClicked(_ sender: Any) {
        view.endEditing(true)
        let size = Int(sizeTextField.text ?? "") ?? 0
        viewModel.didSearch(size: size)
    }
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension VehiclesListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: VehiclesListItemCell.reuseIdentifier,
            for: indexPath
        ) as? VehiclesListItemCell else {
            assertionFailure("Cannot dequeue reusable cell \(VehiclesListItemCell.self) with reuseIdentifier: \(VehiclesListItemCell.reuseIdentifier)")
            return UITableViewCell()
        }

        cell.fill(with: viewModel.items.value[indexPath.row])

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectItem(at: indexPath.row)
    }
}

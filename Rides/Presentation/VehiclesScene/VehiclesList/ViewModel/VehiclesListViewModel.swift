//
//  VehiclesListViewModel.swift
//  Rides
//
//  Created by Sameh Farouk on 31/08/2023.
//

import Foundation

struct VehiclesListViewModelActions {
    let showVehicleDetails: (Vehicle) -> Void
    let showVehicleQueriesResults: (@escaping (_ didSelect: VehicleQuery) -> Void) -> Void
}

enum VehiclesListViewModelLoading {
    case fullScreen
    case nextPage
}

protocol VehiclesListViewModelInput {
    func viewDidLoad()
    func didSearch(size: Int)
    func showQueriesResults()
    func didSelectItem(at index: Int)
}

protocol VehiclesListViewModelOutput {
    var items: Observable<[VehiclesListItemViewModel]> { get }
    var loading: Observable<VehiclesListViewModelLoading?> { get }
    var query: Observable<Int> { get }
    var error: Observable<String> { get }
    var isEmpty: Bool { get }
    var screenTitle: String { get }
    var searchCtaTitle: String { get }
    var emptyDataTitle: String { get }
    var errorTitle: String { get }
    var searchBarPlaceholder: String { get }
}

typealias VehiclesListViewModel = VehiclesListViewModelInput & VehiclesListViewModelOutput

final class DefaultVehiclesListViewModel: VehiclesListViewModel {

    private let searchVehiclesUseCase: SearchVehiclesUseCase
    private let actions: VehiclesListViewModelActions?

    private var page: VehiclesPage?
    private var vehiclesLoadTask: Cancellable? { willSet { vehiclesLoadTask?.cancel() } }
    private let mainQueue: DispatchQueueType

    // MARK: - OUTPUT

    let items: Observable<[VehiclesListItemViewModel]> = Observable([])
    let loading: Observable<VehiclesListViewModelLoading?> = Observable(.none)
    let query: Observable<Int> = Observable(0)
    let error: Observable<String> = Observable("")
    var isEmpty: Bool { return items.value.isEmpty }
    let screenTitle = NSLocalizedString("Vehicles", comment: "")
    let searchCtaTitle = NSLocalizedString("Search", comment: "")
    let emptyDataTitle = NSLocalizedString("Search results", comment: "")
    let errorTitle = NSLocalizedString("Error", comment: "")
    let searchBarPlaceholder = NSLocalizedString("Number of vehicles", comment: "")

    // MARK: - Init
    
    init(
        searchVehiclesUseCase: SearchVehiclesUseCase,
        actions: VehiclesListViewModelActions? = nil,
        mainQueue: DispatchQueueType = DispatchQueue.main
    ) {
        self.searchVehiclesUseCase = searchVehiclesUseCase
        self.actions = actions
        self.mainQueue = mainQueue
    }

    // MARK: - Private

    private func load(vehicleQuery: VehicleQuery, loading: VehiclesListViewModelLoading) {
        self.loading.value = loading
        query.value = vehicleQuery.size

        vehiclesLoadTask = searchVehiclesUseCase.execute(
            requestValue: .init(query: vehicleQuery),
            cached: { [weak self] page in
                self?.mainQueue.async {
                    self?.page = page
                }
            },
            completion: { [weak self] result in
                self?.mainQueue.async {
                    switch result {
                    case .success(let page):
                        self?.page = page
                        self?.items.value = page.vehicles.map(VehiclesListItemViewModel.init)
                    case .failure(let error):
                        self?.handle(error: error)
                    }
                    self?.loading.value = .none
                }
        })
    }

    private func handle(error: Error) {
        self.error.value = error.isInternetConnectionError ?
            NSLocalizedString("No internet connection", comment: "") :
            NSLocalizedString("Failed loading vehicles", comment: "")
    }

    private func update(vehicleQuery: VehicleQuery) {
        load(vehicleQuery: vehicleQuery, loading: .fullScreen)
    }
}

// MARK: - INPUT. View event methods

extension DefaultVehiclesListViewModel {

    func viewDidLoad() { }

    func didSearch(size: Int) {
        update(vehicleQuery: VehicleQuery(size: size))
        showQueriesResults()
    }
    
    func showQueriesResults() {
        actions?.showVehicleQueriesResults(update(vehicleQuery:))
    }

    func didSelectItem(at index: Int) {
        guard let vehicle = page?.vehicles[index] else { return }
        actions?.showVehicleDetails(vehicle)
    }
}

// MARK: - Private

private extension Array where Element == VehiclesPage {
    var vehicles: [Vehicle] { flatMap { $0.vehicles } }
}

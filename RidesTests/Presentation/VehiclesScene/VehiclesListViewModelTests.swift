//
//  VehiclesListViewModelTests.swift
//  RidesTests
//
//  Created by Sameh Farouk on 01/09/2023.
//

import XCTest

class VehiclesListViewModelTests: XCTestCase {
    
    private enum SearchVehiclesUseCaseError: Error {
        case someError
    }
    
    let vehicles: [Vehicle] = {
        let vehicle1 = Vehicle.stub(id: 1,
                                    vin: "vin1",
                                    makeAndModel: "makeAndModel1",
                                    color: "color1",
                                    carType: "carType1")
        let vehicle2 = Vehicle.stub(id: 2,
                                    vin: "vin2",
                                    makeAndModel: "makeAndModel2",
                                    color: "color2",
                                    carType: "carType2")
        return [vehicle1, vehicle2]
    }()
    
    class SearchVehiclesUseCaseMock: SearchVehiclesUseCase {
        var executeCallCount: Int = 0

        typealias ExecuteBlock = (
            SearchVehiclesUseCaseRequestValue,
            (VehiclesPage) -> Void,
            (Result<VehiclesPage, Error>) -> Void
        ) -> Void

        lazy var _execute: ExecuteBlock = { _, _, _ in
            XCTFail("not implemented")
        }
        
        func execute(
            requestValue: SearchVehiclesUseCaseRequestValue,
            cached: @escaping (VehiclesPage) -> Void,
            completion: @escaping (Result<VehiclesPage, Error>) -> Void
        ) -> Cancellable? {
            executeCallCount += 1
            _execute(requestValue, cached, completion)
            return nil
        }
    }
    
    func test_whenSearchVehiclesUseCaseRetrievesOneVehicle_thenViewModelContainsOnlyOneVehicle() {
        // given
        let searchVehiclesUseCaseMock = SearchVehiclesUseCaseMock()

        searchVehiclesUseCaseMock._execute = { requestValue, _, completion in
            XCTAssertEqual(requestValue.query.size, 2)
            completion(.success(VehiclesPage(vehicles: self.vehicles)))
        }
        let viewModel = DefaultVehiclesListViewModel(searchVehiclesUseCase: searchVehiclesUseCaseMock)
        // when
        viewModel.didSearch(size: 2)
        
        // then
        let expectedItems = vehicles.map(VehiclesListItemViewModel.init)
        wait(for: 1)
        XCTAssertEqual(viewModel.items.value, expectedItems)
        XCTAssertEqual(searchVehiclesUseCaseMock.executeCallCount, 1)
        addTeardownBlock { [weak viewModel] in XCTAssertNil(viewModel) }
    }
    
    func test_whenSearchVehiclesUseCaseRetrievesZero_thenViewModelHasError() {
        // given
        let searchVehiclesUseCaseMock = SearchVehiclesUseCaseMock()

        searchVehiclesUseCaseMock._execute = { requestValue, _, completion in
            XCTAssertEqual(requestValue.query.size, 0)
            completion(.failure(SearchVehiclesUseCaseError.someError))
        }
        let viewModel = DefaultVehiclesListViewModel(searchVehiclesUseCase: searchVehiclesUseCaseMock)
        // when
        viewModel.didSearch(size: 0)

        // then
        let expectedItems:[VehiclesListItemViewModel] = []
        XCTAssertEqual(viewModel.items.value, expectedItems)
        XCTAssertEqual(searchVehiclesUseCaseMock.executeCallCount, 0)
        addTeardownBlock { [weak viewModel] in XCTAssertNil(viewModel) }
    }

    func test_whenSearchVehiclesUseCaseRetrievesMoreThanHundred_thenViewModelHasError() {
        // given
        let searchVehiclesUseCaseMock = SearchVehiclesUseCaseMock()

        searchVehiclesUseCaseMock._execute = { requestValue, _, completion in
            XCTAssertEqual(requestValue.query.size, 101)
            completion(.failure(SearchVehiclesUseCaseError.someError))
        }
        let viewModel = DefaultVehiclesListViewModel(searchVehiclesUseCase: searchVehiclesUseCaseMock)
        // when
        viewModel.didSearch(size: 101)

        // then
        let expectedItems:[VehiclesListItemViewModel] = []
        XCTAssertEqual(viewModel.items.value, expectedItems)
        XCTAssertEqual(searchVehiclesUseCaseMock.executeCallCount, 0)
        addTeardownBlock { [weak viewModel] in XCTAssertNil(viewModel) }
    }
}


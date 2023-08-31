//
//  SearchVehiclesUseCaseTests.swift
//  RidesTests
//
//  Created by Sameh Farouk on 01/09/2023.
//

import XCTest

class SearchVehiclesUseCaseTests: XCTestCase {
    
    static let vehicles: [Vehicle] = {
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
    
    enum VehiclesRepositorySuccessTestError: Error {
        case failedFetching
    }
    
    class VehiclesRepositoryMock: VehiclesRepository {
        
        var result: Result<VehiclesPage, Error>
        var fetchCompletionCallsCount = 0

        init(result: Result<VehiclesPage, Error>) {
            self.result = result
        }

        func fetchVehiclesList(
            query: VehicleQuery,
            cached: @escaping (VehiclesPage) -> Void,
            completion: @escaping (Result<VehiclesPage, Error>
            ) -> Void
        ) -> Cancellable? {
            completion(result)
            fetchCompletionCallsCount += 1
            return nil
        }
    }
    
    func testSearchVehiclesUseCase_whenFailedFetchingMoviesForQuery_thenQueryIsNotSavedInRecentQueries() {
        // given
        var useCaseCompletionCallsCountCount = 0
        let moviesQueriesRepository = MoviesQueriesRepositoryMock()
        let useCase = DefaultSearchMoviesUseCase(moviesRepository: MoviesRepositoryMock(result: .failure(MoviesRepositorySuccessTestError.failedFetching)),
                                                 moviesQueriesRepository: moviesQueriesRepository)
        
        // when
        let requestValue = SearchMoviesUseCaseRequestValue(query: MovieQuery(query: "title1"),
                                                           page: 0)
        _ = useCase.execute(requestValue: requestValue, cached: { _ in }) { _ in
            useCaseCompletionCallsCountCount += 1
        }
        // then
        var recents = [MovieQuery]()
        moviesQueriesRepository.fetchRecentsQueries(maxCount: 1) { result in
            recents = (try? result.get()) ?? []
        }
        XCTAssertTrue(recents.isEmpty)
        XCTAssertEqual(useCaseCompletionCallsCountCount, 1)
        XCTAssertEqual(moviesQueriesRepository.fetchCompletionCallsCount, 1)
    }
}

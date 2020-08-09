//  Created by Gagandeep Singh on 6/8/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.

import CarsalesAPI
@testable import CarsalesChallenge
import XCTest

final class MockAPI: CarsalesAPI {
    override func getList(completion: @escaping (Result<CarsalesAPI.ListResult, Error>) -> Void) {
        completion(.success(.init(objects: [.sample])))
    }
    
    override func getDetails(path: String, completion: @escaping (Result<CarsalesAPI.CarDetails, Error>) -> Void) {
        completion(.success(.sample))
    }
}

class CarsalesChallengeTests: XCTestCase {
    func testCarListViewModel() {
        let viewModel = CarListViewModel(api: MockAPI())
        let expectation = XCTestExpectation(description: "load list")
        viewModel.actionHandler = { action in
            switch action {
            case .reload:
                XCTAssertEqual(viewModel.numberOfItems(), 1)
                XCTAssertEqual(viewModel.viewState(forItemAt: .init(item: 0, section: 0)), .init(item: .sample))
            default:
                XCTFail()
            }
            
            expectation.fulfill()
        }
        
        viewModel.loadCars()
        wait(for: [expectation], timeout: 1)
    }
    
    func testCarListViewModelShowDetailsAction() {
        let viewModel = CarListViewModel(api: MockAPI())
        let expectation = XCTestExpectation(description: "show details")
        viewModel.actionHandler = { action in
            switch action {
            case .showDetails(let path):
                XCTAssertEqual(path, CarsalesAPI.ListItem.sample.detailsURL)
                expectation.fulfill()
            case .reload:
                break
            default:
                XCTFail()
            }
        }
        
        viewModel.loadCars()
        viewModel.showDetails(forItemAt: .init(item: 0, section: 0))
        wait(for: [expectation], timeout: 1)
    }

    
    func testCarDetailsViewModel() {
        let viewModel = CarDetailsViewModel(api: MockAPI(), path: "")
        let expectation = XCTestExpectation(description: "load view state")
        viewModel.actionHandler = { action in
            switch action {
            case .finishedLoding(let viewState):
                XCTAssertEqual(viewState.title, CarsalesAPI.CarDetails.sample.title)
                XCTAssertEqual(viewState.location.1, CarsalesAPI.CarDetails.sample.locationString)
                XCTAssertEqual(viewState.price.1, CarsalesAPI.CarDetails.sample.priceString)
                XCTAssertEqual(viewState.comments, CarsalesAPI.CarDetails.sample.comments)
                XCTAssertEqual(viewState.photos, CarsalesAPI.CarDetails.sample.photos)
            case .failedToLoad:
                XCTFail()
            }
            
            expectation.fulfill()
        }

        viewModel.loadCarDetails()
        wait(for: [expectation], timeout: 1)
    }
}

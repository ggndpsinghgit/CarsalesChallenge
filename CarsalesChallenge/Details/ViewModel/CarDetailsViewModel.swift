//  Copyright © 2020 Gagandeep Singh. All rights reserved.

import UIKit
import CarsalesAPI

final class CarDetailsViewModel {
    
    // MARK: API
    
    private let api: CarsalesAPI
    
    // MARK: Stored Properties
    
    private let path: String
    var actionHandler: ((Action) -> Void)?
    
    // MARK: Initializer
    
    init(api: CarsalesAPI = .init(), path: String) {
        self.api = api
        self.path = path
    }
    
    // MARK: Details Loading
    
    func loadCarDetails() {
        api.getDetails(path: path) { [weak self] result in
            switch result {
            case .success(let value):
                guard let viewState = self?.makeViewState(for: value) else { return }
                self?.actionHandler?(.finishedLoding(viewState))
            case .failure:
                self?.actionHandler?(.failedToLoad)
            }
        }
    }
    
    // MARK: View State Generation
    
    private func makeViewState(for car: CarsalesAPI.CarDetails) -> CarDetailsViewController.ViewState {
        return .init(
            title: car.title,
            location: ("mappin.circle", car.locationString),
            price: ("dollarsign.circle", car.priceString),
            status: (car.saleStatus.icon, car.saleStatus.rawValue),
            comments: car.comments,
            photos: car.photos)
    }
}

// MARK: - Actions

extension CarDetailsViewModel {
    enum Action {
        case finishedLoding(CarDetailsViewController.ViewState)
        case failedToLoad
    }
}

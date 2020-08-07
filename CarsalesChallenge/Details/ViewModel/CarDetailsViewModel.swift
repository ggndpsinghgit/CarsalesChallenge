//  Copyright © 2020 Gagandeep Singh. All rights reserved.

import UIKit
import CarsalesAPI

final class CarDetailsViewModel {
    private let api = CarsalesAPI()
    
    var actionHandler: ((Action) -> Void)?
    
    init(path: String) {
        loadCarDetails(at: path)
    }
    
    private func loadCarDetails(at path: String) {
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
    
    private func makeViewState(for car: CarsalesAPI.CarDetails) -> CarDetailsViewController.ViewState {
        return .init(
            title: car.title,
            location: ("mappin.circle", car.locationString),
            price: ("dollarsign.circle", car.priceString),
            status: (car.saleStatus.icon, car.saleStatus.rawValue),
            comments: car.comments,
            photos: car.photos)
    }
    
    enum Action {
        case finishedLoding(CarDetailsViewController.ViewState)
        case failedToLoad
    }
}

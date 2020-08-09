//  Created by Gagandeep Singh on 7/8/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.

import UIKit
import CarsalesAPI

final class CarListViewModel {
    
    // MARK: API
    
    private let api: CarsalesAPI
    
    // MARK: Stored Properties
    
    var actionHandler: ((Action) -> Void)?
    private var cars: [CarsalesAPI.ListItem] = []
    
    // MARK: Initializer
    
    init(api: CarsalesAPI = .init()) {
        self.api = api
    }
    
    // MARK: List Loading
    
    func loadCars() {
        api.getList { [weak self] result in
            switch result {
            case .success(let value):
                self?.cars = value.objects
                self?.actionHandler?(.reload)
            case .failure:
                self?.actionHandler?(.failedToLoad)
            }
        }
    }
    
    // MARK: Collection View Data Source
    
    func numberOfItems() -> Int {
        cars.count
    }
    
    func viewState(forItemAt indexPath: IndexPath) -> CarListItemCell.ViewState {
        let item = cars[indexPath.row]
        return .init(item: item)
    }
    
    // MARK: Getters
    
    func showDetails(forItemAt indexPath: IndexPath) {
        let car = cars[indexPath.row]
        actionHandler?(.showDetails(car.detailsURL))
    }
}

// MARK: - Actions

extension CarListViewModel {
    enum Action {
        case reload
        case failedToLoad
        case showDetails(String)
    }
}

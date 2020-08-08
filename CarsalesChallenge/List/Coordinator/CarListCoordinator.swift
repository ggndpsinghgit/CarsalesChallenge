//  Created by Gagandeep Singh on 7/8/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.

import UIKit

final class CarListCoordinator: Coordinator {
    
    // MARK: Coordinator
    
    var rootViewController: UIViewController { navigationController }
    var childCoordinators: [Coordinator] = []
    
    // MARK: Stored Properties
    
    private let viewController: CarsListViewController
    private let navigationController = UINavigationController()
    
    // MARK: Initializer
    
    init() {
        let viewModel = CarListViewModel()
        viewController = CarsListViewController(viewModel: viewModel)
        navigationController.viewControllers = [viewController]
        
        viewModel.actionHandler = { [weak self] action in
            switch action {
            case .failedToLoad:
                self?.presentAlert()
            case .reload:
                self?.viewController.collectionView.reloadData()
            case .showDetails(let path):
                self?.showDetails(forCarAt: path)
            }
        }
    }
    
    // MARK: Action Handlers
    
    private func showDetails(forCarAt path: String) {
        let coordinator = CarDetailsCoordinator(path: path)
        coordinator.delegate = self
        navigationController.present(coordinator.rootViewController, animated: true)
        childCoordinators.append(coordinator)
    }
    
    private func presentAlert() {
        let alertController = UIAlertController(
            title: "Error!",
            message: "Failed to load cars list.",
            preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
        viewController.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - CarDetailsCoordinatorDelegate

extension CarListCoordinator: CarDetailsCoordinatorDelegate {
    func carDetailsCoordinatorDidFinish(_ coordinator: CarDetailsCoordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}

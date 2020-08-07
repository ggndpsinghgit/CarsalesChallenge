//  Created by Gagandeep Singh on 7/8/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.

import UIKit

protocol Coordinator: AnyObject {
    var rootViewController: UIViewController { get }
    var childCoordinators: [Coordinator] { get set }
}

final class CarListCoordinator: Coordinator {
    private let viewController: CarsListViewController
    private let navigationController = UINavigationController()
    
    var rootViewController: UIViewController { navigationController }
    var childCoordinators: [Coordinator] = []
    
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
    
    private func showDetails(forCarAt path: String) {
        let coordinator = CarDetailsCoordinator(path: path)
        coordinator.delegate = self
        navigationController.present(coordinator.rootViewController, animated: true)
        childCoordinators.append(coordinator)
    }
    
    private func presentAlert() {
        let alertController = UIAlertController(title: "Error!", message: "Failed to load cars list. Try again later.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
        viewController.present(alertController, animated: true, completion: nil)
    }
}

extension CarListCoordinator: CarDetailsCoordinatorDelegate {
    func carDetailsCoordinatorDidFinish(_ coordinator: CarDetailsCoordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}

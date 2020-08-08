//  Created by Gagandeep Singh on 7/8/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.

import UIKit

protocol CarDetailsCoordinatorDelegate: AnyObject {
    func carDetailsCoordinatorDidFinish(_ coordinator: CarDetailsCoordinator)
}

final class CarDetailsCoordinator: NSObject, Coordinator {
    
    // MARK: Coordinator
    
    var rootViewController: UIViewController { navigationController }
    var childCoordinators: [Coordinator] = []
    
    // MARK: Stored Properties
    
    private let viewController: CarDetailsViewController
    private let navigationController = UINavigationController()
    weak var delegate: CarDetailsCoordinatorDelegate?
    
    // MARK: Initializer
    
    init(path: String) {
        let viewModel = CarDetailsViewModel(path: path)
        viewController = CarDetailsViewController(viewModel: viewModel)
        navigationController.viewControllers = [viewController]
        super.init()

        navigationController.presentationController?.delegate = self
        viewController.delegate = self

        viewModel.actionHandler = { [weak self] action in
            switch action {
            case .finishedLoding(let viewState):
                self?.viewController.viewState = viewState
            case .failedToLoad:
                self?.presentAlert()
            }
        }
    }
    
    // MARK: Action Handlers
    
    private func presentAlert() {
        let alertController = UIAlertController(
            title: "Error!",
            message: "Failed to load car details.",
            preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: { [weak self] _ in
            guard let self = self else { return }
            self.viewController.dismiss(animated: true) {
                self.delegate?.carDetailsCoordinatorDidFinish(self)
            }
        })

        alertController.addAction(ok)
        viewController.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - CarDetailsViewControllerDelegate

extension CarDetailsCoordinator: CarDetailsViewControllerDelegate {
    func carDetailsViewControllerShouldDismiss(_ viewController: CarDetailsViewController) {
        viewController.dismiss(animated: true) {
            self.delegate?.carDetailsCoordinatorDidFinish(self)
        }
    }
}

// MARK: - UIAdaptivePresentationControllerDelegate

extension CarDetailsCoordinator: UIAdaptivePresentationControllerDelegate {
    
    // Handle swipe to dimiss on iOS 13.0+
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        delegate?.carDetailsCoordinatorDidFinish(self)
    }
}

//  Created by Gagandeep Singh on 7/8/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.

import UIKit

protocol CarDetailsCoordinatorDelegate: AnyObject {
    func carDetailsCoordinatorDidFinish(_ coordinator: CarDetailsCoordinator)
}

final class CarDetailsCoordinator: NSObject, Coordinator {
    private let viewController: CarDetailsViewController
    private let navigationController = UINavigationController()
    var rootViewController: UIViewController { navigationController }
    var childCoordinators: [Coordinator] = []
    weak var delegate: CarDetailsCoordinatorDelegate?
    
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
    
    private func presentAlert() {
        let alertController = UIAlertController(title: "Error!", message: "Failed to load cars details. Try again later.", preferredStyle: .alert)
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

extension CarDetailsCoordinator: CarDetailsViewControllerDelegate {
    func carDetailsViewControllerShouldDismiss(_ viewController: CarDetailsViewController) {
        viewController.dismiss(animated: true) {
            self.delegate?.carDetailsCoordinatorDidFinish(self)
        }
    }
}

extension CarDetailsCoordinator: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        delegate?.carDetailsCoordinatorDidFinish(self)
    }
}

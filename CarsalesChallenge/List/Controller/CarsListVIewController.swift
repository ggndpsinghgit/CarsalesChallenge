//  Created by Gagandeep Singh on 7/8/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.

import UIKit
import CarsalesAPI

class CarsListViewController: UICollectionViewController {
    
    // MARK: Stored Properties
    
    private let viewModel: CarListViewModel
   
    // MARK: Initializer
    
    init(viewModel: CarListViewModel) {
        self.viewModel = viewModel
        super.init(collectionViewLayout: CarListFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Carsales.com.au"
        collectionView.backgroundColor = .systemBackground
        collectionView.register(CarListItemCell.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.collectionView.collectionViewLayout.invalidateLayout()
        }, completion: nil)
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItems()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.deque(CarListItemCell.self, for: indexPath)
        cell.viewState = viewModel.viewState(forItemAt: indexPath)
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.showDetails(forItemAt: indexPath)
    }
}

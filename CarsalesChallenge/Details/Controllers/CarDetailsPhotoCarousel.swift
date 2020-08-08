//  Created by Gagandeep Singh on 7/8/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.

import UIKit

final class CarDetailsPhotoCarousel: UIViewController {
    
    // MARK: UI Elements
    
    private(set) lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.register(CarDetailsPhotoCell.self)

        return collectionView
    }()
    
    // MARK: Stored Properties
    
    private var currentIndex: Int = 0
    var photos: [String] = [] {
       didSet {
            collectionView.reloadData()
       }
    }
    
    // MARK: Initializer
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.collectionView.collectionViewLayout.invalidateLayout()
        }, completion: nil)
    }
    
    // MARK: View Layout
    
    private func layout() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UICollectionViewDataSource

extension CarDetailsPhotoCarousel: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.deque(CarDetailsPhotoCell.self, for: indexPath)
        cell.path = photos[indexPath.item]
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CarDetailsPhotoCarousel: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }

    func collectionView(_ collectionView: UICollectionView, targetContentOffsetForProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        let index = currentIndex
        let indexPath = IndexPath(item: index, section: 0)
        let x = CGFloat(indexPath.item) * collectionView.frame.size.width
        return CGPoint(x: x, y: 0)
    }
}

// MARK: - UIScrollViewDelegate

extension CarDetailsPhotoCarousel {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = round(scrollView.contentOffset.x / collectionView.bounds.size.width)
        currentIndex = Int(index)
    }
}

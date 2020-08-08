//  Created by Gagandeep Singh on 7/8/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.

import UIKit
import CarsalesAPI

// MARK: - UIDevice

extension UIDevice {
    var isiPad: Bool { userInterfaceIdiom == .pad }
}

// MARK: - UIApplication

extension UIApplication {
    var orientation: UIInterfaceOrientation { (connectedScenes.first as? UIWindowScene)?.interfaceOrientation ?? .portrait }
}

// MARK: - Car Sale Status

extension CarsalesAPI.CarDetails.Status {
    var icon: String {
        switch self {
        case .available:
            return "checkmark.circle"
        case .comingSoon:
            return "clock"
        }
    }
}

// MARK: - UICollectionView

extension UICollectionView {
    func register(_ cell: UICollectionViewCell.Type) {
        register(cell.self, forCellWithReuseIdentifier: String(describing: cell.self))
    }
    
    func deque<T: UICollectionViewCell>(_ cell: T.Type, for indexPath: IndexPath) -> T {
        dequeueReusableCell(withReuseIdentifier: String(describing: cell.self), for: indexPath) as! T
    }
}

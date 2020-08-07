//  Created by Gagandeep Singh on 7/8/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.

import UIKit
import CarsalesAPI

extension UIDevice {
    var isiPad: Bool { userInterfaceIdiom == .pad }
}

extension UIApplication {
    var orientation: UIInterfaceOrientation { (connectedScenes.first as? UIWindowScene)?.interfaceOrientation ?? .portrait }
}

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


extension UICollectionView {
    func register(_ cell: UICollectionViewCell.Type) {
        register(cell.self, forCellWithReuseIdentifier: String(describing: cell.self))
    }
    
    func deque<T: UICollectionViewCell>(_ cell: T.Type, for indexPath: IndexPath) -> T {
        dequeueReusableCell(withReuseIdentifier: String(describing: cell.self), for: indexPath) as! T
    }
}

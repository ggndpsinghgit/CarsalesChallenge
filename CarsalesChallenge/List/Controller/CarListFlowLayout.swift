//  Created by Gagandeep Singh on 9/8/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.

import UIKit

final class CarListFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }
        
        // Calculate available width for items
        let availableWidth = collectionView.bounds.inset(by: collectionView.layoutMargins).width
        
        // Calculate number of items
        // 1 for iPhone
        // 2 for iPad portrait, 3 for landscape
        let maxNumColumns: Int = {
            if !UIDevice.current.isiPad { return 1 }
            return UIApplication.shared.orientation.isPortrait ? 2 : 3
        }()
        
        // Calculate size for each cell
        let cellWidth = (availableWidth / CGFloat(maxNumColumns)).rounded(.down) - 2
        let cellHeight = (cellWidth * 2/3) + 116
            
        self.itemSize = CGSize(width: cellWidth, height: cellHeight)
        self.sectionInset = UIEdgeInsets(top: self.minimumInteritemSpacing, left: 0.0, bottom: 0.0, right: 0.0)
        self.sectionInsetReference = .fromSafeArea
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = collectionView else { return false }
        return !newBounds.size.equalTo(collectionView.bounds.size)
    }
}

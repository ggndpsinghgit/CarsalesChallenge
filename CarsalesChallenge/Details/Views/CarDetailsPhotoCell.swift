//  Created by Gagandeep Singh on 7/8/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.

import UIKit

final class CarDetailsPhotoCell: UICollectionViewCell {
    
    // MARK: UI Elements
    
    private let imageView: AsyncImageView = {
        let view = AsyncImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemBackground
        view.image = UIImage(systemName: "car")
        return view
    }()
    
    // MARK: Stored Properties
    
    var path: String? {
        didSet {
            imageView.path = path
        }
    }
    
    // MARK: Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Cell Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.cancelLoad()
    }
}

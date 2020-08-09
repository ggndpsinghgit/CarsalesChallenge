//  Created by Gagandeep Singh on 7/8/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.

import UIKit
import CarsalesAPI

class CarListItemCell: UICollectionViewCell {
    
    // MARK: UI Elements
    
    let imageView: AsyncImageView = {
        let view = AsyncImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.setContentHuggingPriority(.required, for: .vertical)
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.setContentHuggingPriority(.required, for: .vertical)
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .right
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    // MARK: Stored Properties
    
    var viewState: ViewState = .init() {
        didSet {
            titleLabel.text = viewState.title
            priceLabel.text = viewState.price
            locationLabel.text = viewState.location
            imageView.path = viewState.photoPath
        }
    }
    
    // MARK: Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(locationLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 2/3),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.heightAnchor.constraint(equalToConstant: 28),
            
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            priceLabel.heightAnchor.constraint(equalToConstant: 24),
            
            locationLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8),
            locationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            locationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            locationLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16),
            locationLabel.heightAnchor.constraint(equalToConstant: 24)
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

// MARK: - ViewState

extension CarListItemCell {
    struct ViewState: Equatable {
        let title: String
        let price: String
        let location: String
        let photoPath: String
        
        init(item: CarsalesAPI.ListItem) {
            self.title = item.title
            self.price = item.priceString
            self.location = item.locationString
            self.photoPath = item.photoPath
        }
        
        init(
            title: String = "",
            price: String = "",
            location: String = "",
            photoPath: String = "")
        {
            self.title = title
            self.price = price
            self.location = location
            self.photoPath = photoPath
        }
    }
}

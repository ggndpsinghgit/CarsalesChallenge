//  Created by Gagandeep Singh on 7/8/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.

import UIKit

/// A simple view to show an icon and text,
/// aligned horizontally
class IconTextView: UIView {
    
    // MARK: UI Elements
    
    private let iconView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(.required, for: .horizontal)
        view.setContentHuggingPriority(.required, for: .vertical)
        view.tintColor = .secondaryLabel
        return view
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()
    
    private let separator: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .separator
        return view
    }()
    
    // MARK: Stored Properties
    
    var foregroundColor: UIColor? {
        get { textLabel.textColor }
        set {
            textLabel.textColor = newValue
            iconView.tintColor = newValue
        }
    }
    
    var text: String? {
        get { textLabel.text }
        set { textLabel.text = newValue }
    }
    
    // MARK: Initializer
    
    init() {
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Layout
    
    private func layout() {
        [iconView, textLabel, separator].forEach(addSubview)
        NSLayoutConstraint.activate([
            iconView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor),
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            iconView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            textLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 16),
            textLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            
            separator.leadingAnchor.constraint(equalTo: textLabel.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale),
            separator.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    // MARK: Setters
    
    func set(icon: String, text: String) {
        textLabel.text = text
        let configuration = UIImage.SymbolConfiguration(font: .preferredFont(forTextStyle: .callout))
        let image = UIImage(systemName: icon, withConfiguration: configuration)
        iconView.image = image
    }
}

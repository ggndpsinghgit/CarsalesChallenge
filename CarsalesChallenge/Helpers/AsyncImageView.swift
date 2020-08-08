//  Created by Gagandeep Singh on 7/8/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.

import UIKit
import Combine

class AsyncImageView: UIImageView {
    
    // MARK: UI Elements
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    // MARK: Stored Properties
    
    private var cancellable: AnyCancellable?
    var path: String? {
        didSet {
            loadImage()
        }
    }
    
    // MARK: Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .secondarySystemBackground
        addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Image Loading
    
    private func loadImage() {
        guard let path = self.path, let url = URL(string: path)  else { return }
        spinner.startAnimating()
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveCompletion: { _ in
                self.spinner.stopAnimating()
            })
            .assign(to: \.image, on: self)

    }
    
    func cancelLoad() {
        self.cancellable?.cancel()
        self.cancellable = nil
    }
}


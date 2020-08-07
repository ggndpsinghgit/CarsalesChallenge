//  Created by Gagandeep Singh on 7/8/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.

import UIKit
import Combine

class AsyncImageView: UIImageView {
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    private var cancellable: AnyCancellable?
    var path: String? {
        didSet {
            loadImage()
        }
    }
    
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
    
    private func loadImage() {
        guard let path = self.path, let url = URL(string: path)  else { return }
        spinner.startAnimating()
        
        let request = URLRequest(url: url)
        let publishder = URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { result -> (UIImage?, URL?) in
                return (UIImage(data: result.data), result.response.url)
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
        
        cancellable = publishder.sink(receiveCompletion: { _ in }) { [weak self] (img, url) in
            self?.spinner.stopAnimating()
            guard url?.absoluteString == path else { return }
            self?.image = img
            self?.cancelLoad()
        }
    }
    
    func cancelLoad() {
        self.cancellable?.cancel()
        self.cancellable = nil
    }
}


//  Created by Gagandeep Singh on 7/8/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.

import UIKit
import CarsalesAPI

protocol CarDetailsViewControllerDelegate: AnyObject {
    func carDetailsViewControllerShouldDismiss(_ viewController: CarDetailsViewController)
}

final class CarDetailsViewController: UIViewController {
    
    // MARK: UI Elemets
    
    private let locationLabel = makeIconLabel()
    private let priceLabel = makeIconLabel()
    private let statusLabel = makeIconLabel()
    private let commentsView = makeTextView()
    private var carousel: CarDetailsPhotoCarousel?

    private let scrollView: UIScrollView = {
        let view = UIScrollView(frame: .zero)
        view.alwaysBounceHorizontal = false
        view.isDirectionalLockEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let stackView: UIStackView = {
        let view = UIStackView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.spacing = 0
        view.axis = .vertical
        return view
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        return spinner
    }()
    
    // MARK: Stored Properties
    
    private let viewModel: CarDetailsViewModel
    weak var delegate: CarDetailsViewControllerDelegate?
    var viewState: ViewState = .init() {
        didSet {
            spinner.stopAnimating()
            title = viewState.title
            priceLabel.set(icon: viewState.price.icon, text: viewState.price.text)
            locationLabel.set(icon: viewState.location.icon, text: viewState.location.text)
            statusLabel.set(icon: viewState.status.icon, text: viewState.status.text)
            commentsView.text = viewState.comments
            carousel?.photos = viewState.photos
        }
    }
    
    // MARK: Initializer
    
    init(viewModel: CarDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadCarDetails()
        view.backgroundColor = .systemBackground
        layout()
        setupPhotosCarousel()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: spinner)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: View Layout
    
    private func layout() {
        let container = UIView(frame: .zero)
        container.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(container)
        container.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        [locationLabel, priceLabel, statusLabel, commentsView]
            .forEach(stackView.addArrangedSubview)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            container.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            container.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            container.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        
            scrollView.topAnchor.constraint(equalTo: container.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
    }
    
    func setupPhotosCarousel() {
        let carousel = CarDetailsPhotoCarousel()
        addChild(carousel)
        carousel.willMove(toParent: self)
        if let childView = carousel.view {
            stackView.insertArrangedSubview(childView, at: 0)
            childView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                childView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
                childView.heightAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 2/3)
            ])
        }
        carousel.didMove(toParent: self)
        self.carousel = carousel
    }
    
    // MARK: Action Handlers
    
    @objc
    private func doneTapped() {
        delegate?.carDetailsViewControllerShouldDismiss(self)
    }
}

// MARK: - Factories

extension CarDetailsViewController {
    private static func makeTextView() -> UITextView {
        let view = UITextView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 100)
        view.isScrollEnabled = false
        view.font = .preferredFont(forTextStyle: .body)
        view.isEditable = false
        view.isSelectable = true
        view.textContainerInset = .init(top: 24, left: 16, bottom: 4, right: 16)
        return view
    }
    
    private static func makeIconLabel() -> IconTextView {
        let view = IconTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}

// MARK: - View State

extension CarDetailsViewController {
    struct ViewState {
        let title: String
        let location: (icon: String, text: String)
        let price: (icon: String, text: String)
        let status: (icon: String, text: String)
        let comments: String
        let photos: [String]
        
        init(
            title: String = "",
            location: (icon: String, text: String) = ("", ""),
            price: (icon: String, text: String) = ("", ""),
            status: (icon: String, text: String) = ("", ""),
            comments: String = "",
            photos: [String] = [])
        {
            self.title = title
            self.location = location
            self.price = price
            self.status = status
            self.comments = comments
            self.photos = photos
        }
    }
}

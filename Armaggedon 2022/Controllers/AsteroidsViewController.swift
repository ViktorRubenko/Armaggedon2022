//
//  AsteroidsViewController.swift
//  Armaggedon 2022
//
//  Created by Victor Rubenko on 13.04.2022.
//

import UIKit
import Combine

final class AsteroidsViewController: UIViewController {
    private var viewModel: AsteroidListViewModelProtocol!
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: AsteroidListViewModelProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.asteroidsPublisher.sink { asteroids in
            print(asteroids)
        }.store(in: &cancellables)
        viewModel.errorPublisher.sink { error in
            print(error)
        }.store(in: &cancellables)
    }
}

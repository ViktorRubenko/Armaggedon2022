//
//  AsteroidDetailViewController.swift
//  Armaggedon 2022
//
//  Created by Victor Rubenko on 17.04.2022.
//

import UIKit
import Combine

class AsteroidDetailViewController: UIViewController {
    private var cancellables = Set<AnyCancellable>()
    private let viewModel: AsteroidDetailViewModelProtocol!
    private let topInfoView = HeaderApproachView()

    init(viewModel: AsteroidDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavigationBar()
        setupBinders()
        
//        viewModel.fetch()
    }
}
// MARK: - Methods
extension AsteroidDetailViewController {
    private func setupViews() {
        view.backgroundColor = .white
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(topInfoView)
        topInfoView.layer.cornerRadius = 15
        topInfoView.snp.makeConstraints { make in
            make.top.equalTo(safeArea)
            make.leading.equalTo(safeArea)
            make.trailing.equalTo(safeArea)
            make.height.equalTo(200)
        }
    }
    
    private func setupNavigationBar() {
        
    }
    
    private func setupBinders() {
        viewModel.asteroid
            .sink { [weak self] model in
                guard model != nil else { return }
                self?.updateInfoView(model!)
            }.store(in: &cancellables)
    }
    
    private func updateInfoView(_ model: AsteroidModel) {
        topInfoView.configure(name: model.name, asteroidDiamater: model.estimatedDiameter, potentiallyHazardous: model.potentiallyHazardouds)
    }
}

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
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: self.createLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(AsteroidCell.self, forCellWithReuseIdentifier: AsteroidCell.identifier)
        return collectionView
    }()
    private let loadIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        return indicator
    }()
    init(viewModel: AsteroidListViewModelProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupViews()
        setupBinders()
    }
}
// MARK: - Methods
extension AsteroidsViewController {
    private func setupViews() {
        let safeArea = view.safeAreaLayoutGuide
        view.backgroundColor = .white
        
        view.addSubview(collectionView)
        collectionView.backgroundColor = .clear
        collectionView.contentOffset.y = 200
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(safeArea)
        }
        
        view.addSubview(loadIndicator)
        loadIndicator.snp.makeConstraints { make in
            make.center.equalTo(collectionView)
        }
    }
    
    private func setupBinders() {
        viewModel.asteroids.sink { [weak self] asteroids in
            if !asteroids.isEmpty {
                self?.loadIndicator.stopAnimating()
                self?.collectionView.reloadData()
            }
        }.store(in: &cancellables)
        viewModel.errorPublisher.sink { error in
            print(error)
        }.store(in: &cancellables)
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(308)),
            subitem: item,
            count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 25
        section.contentInsets = NSDirectionalEdgeInsets(top: 19.5, leading: 16, bottom: 19.5, trailing: 16)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func setupNavigationBar() {
        title = "Армагеддон 2022"
        let rightButton = UIBarButtonItem(
            image: UIImage(systemName: "line.3.horizontal.decrease"),
            style: .done,
            target: self,
            action: #selector(didTapFilterButton))
        navigationItem.rightBarButtonItem = rightButton
    }
}
// MARK: - Actions
extension AsteroidsViewController {
    @objc func didTapFilterButton() {
        print("open filter")
    }
}
// MARK: - TableView Delegate/DS
extension AsteroidsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AsteroidCell.identifier, for: indexPath) as! AsteroidCell
        cell.configure(viewModel.asteroids.value[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.asteroids.value.count
    }
}

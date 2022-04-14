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
    init(viewModel: AsteroidListViewModelProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupBinders()
    }
}
// MARK: - Methods
extension AsteroidsViewController {
    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(collectionView)
        collectionView.backgroundColor = .clear
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupBinders() {
        viewModel.asteroids.sink { [weak self] a in
            self?.collectionView.reloadData()
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
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(308)),
            subitem: item,
            count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 25
        return UICollectionViewCompositionalLayout(section: section)
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

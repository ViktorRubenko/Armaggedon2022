//
//  DestroyAsteroidsListViewController.swift
//  Armaggedon 2022
//
//  Created by Victor Rubenko on 15.04.2022.
//

import UIKit
import Combine

class DestroyAsteroidsListViewController: UIViewController {
    private var cancellables = Set<AnyCancellable>()
    private let viewModel: DestroyAsteroidsListViewModelProtocol!
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: self.createLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            DestroyAsteroidCollectionViewCell.self,
            forCellWithReuseIdentifier: DestroyAsteroidCollectionViewCell.identifier)
        return collectionView
    }()
    
    init(viewModel: DestroyAsteroidsListViewModelProtocol) {
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetch()
    }
}
// MARK: - Methods
extension DestroyAsteroidsListViewController {
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44))
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(collectionView)
        collectionView.backgroundColor = .white
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupNavigationBar() {
        title = "На уничтожение"
    }
    
    private func setupBinders() {
        viewModel.asteroidsToDestroy.sink { [weak self] _ in
            self?.collectionView.reloadData()
        }.store(in: &cancellables)
    }
}
// MARK: - Actions
extension DestroyAsteroidsListViewController {
    
}
// MARK: - UICollectionView Delegate/DS
extension DestroyAsteroidsListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.asteroidsToDestroy.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: DestroyAsteroidCollectionViewCell.identifier,
            for: indexPath) as! DestroyAsteroidCollectionViewCell
        let model = viewModel.asteroidsToDestroy.value[indexPath.row]
        cell.configure(model)
        return cell
    }
}

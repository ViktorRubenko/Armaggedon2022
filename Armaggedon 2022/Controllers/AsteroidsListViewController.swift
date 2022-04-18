//
//  AsteroidsListViewController.swift
//  Armaggedon 2022
//
//  Created by Victor Rubenko on 13.04.2022.
//

import UIKit
import Combine

final class AsteroidsListViewController: UIViewController {
    private var viewModel: AsteroidListViewModelProtocol!
    private var cancellables = Set<AnyCancellable>()
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: self.createLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.delaysContentTouches = false
        collectionView.register(
            AsteroidCollectionViewCell.self,
            forCellWithReuseIdentifier: AsteroidCollectionViewCell.identifier)
        collectionView.register(
            UICollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: "Footer")
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
extension AsteroidsListViewController {
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
        viewModel.errorPublisher.sink { [weak self] error in
            guard !error.isEmpty else { return }
            let alert = UIAlertController(title: "Ошибка", message: error, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true)
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
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(44)),
                elementKind: UICollectionView.elementKindSectionFooter,
                alignment: .bottom)
        ]
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
extension AsteroidsListViewController {
    @objc private func didTapFilterButton() {
        let vc = FilterViewController(viewModel: FilterViewModel())
        navigationController?.pushViewController(vc, animated: true)
    }
}
// MARK: - TableView Delegate/DS
extension AsteroidsListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AsteroidCollectionViewCell.identifier, for: indexPath) as! AsteroidCollectionViewCell
        let model = viewModel.asteroids.value[indexPath.row]
        cell.configure(model)
        cell.destroyButtonHandler = { [weak self] in
            self?.viewModel.addToDestroyList(model.id)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.asteroids.value.count
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastRowIndex = collectionView.numberOfItems(inSection: 0) - 1
        if (lastRowIndex - indexPath.row) < 5 {
            viewModel.fetch()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = viewModel.asteroids.value[indexPath.row]
        let vc = AsteroidDetailViewController(viewModel: AsteroidDetailViewModel(asteroidModel: viewModel.getResponseModel(model.id)!))
        navigationController?.pushViewController(vc, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "Footer",
                for: indexPath)
            if collectionView.numberOfItems(inSection: 0) > 0 {
                let spinner = UIActivityIndicatorView()
                spinner.startAnimating()
                footer.addSubview(spinner)
                spinner.snp.makeConstraints { make in
                    make.center.equalToSuperview()
                }
            }
            return footer
        }
        return UICollectionReusableView()
    }
}

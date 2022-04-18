//
//  AsteroidDetailViewController.swift
//  Armaggedon 2022
//
//  Created by Victor Rubenko on 17.04.2022.
//

import UIKit
import Combine
import SnapKit

class AsteroidDetailViewController: UIViewController {
    private var cancellables = Set<AnyCancellable>()
    private let viewModel: AsteroidDetailViewModelProtocol!
    
    private let diameterLabel = UILabel.defaultLabel()
    private let hazardousLabel = UILabel.defaultLabel()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 25)
        return label
    }()
    private let destroyButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        let button = UIButton(configuration: config, primaryAction: nil)
        button.layer.cornerRadius = 14
        button.clipsToBounds = true
        button.backgroundColor = Constants.Colors.destroyButtonColor
        button.setTitleColor(Constants.Colors.secondaryLabelColor, for: .normal)
        button.setTitle("УНИЧТОЖИТЬ", for: .normal)
        return button
    }()
    private let topContainerView: UIView = {
        let view = UIView()
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOpacity = 1.0
        view.layer.shadowRadius = 14
        view.layer.cornerRadius = 14
        view.backgroundColor = .white
        return view
    }()
    private var topContainerViewTopConstraint: Constraint!
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: self.createLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.register(ApproachCollectionViewCell.self, forCellWithReuseIdentifier: ApproachCollectionViewCell.identifier)
        return collectionView
    }()

    init(viewModel: AsteroidDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Подробнее"
        setupViews()
        setupBinders()
    }
}
// MARK: - Methods
extension AsteroidDetailViewController {
    private func setupViews() {
        view.backgroundColor = .white
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(topContainerView)
        topContainerView.addSubview(nameLabel)
        topContainerView.addSubview(diameterLabel)
        topContainerView.addSubview(hazardousLabel)
        view.addSubview(destroyButton)
        view.addSubview(collectionView)
        
        topContainerView.snp.makeConstraints { make in
            topContainerViewTopConstraint = make.top.equalTo(safeArea).offset(10).constraint
            make.leading.equalTo(safeArea).offset(10)
            make.trailing.equalTo(safeArea).offset(-10)
            make.bottom.equalTo(destroyButton).offset(5)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        diameterLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        hazardousLabel.snp.makeConstraints { make in
            make.top.equalTo(diameterLabel.snp.bottom).offset(5)
            make.left.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        destroyButton.snp.makeConstraints { make in
            make.top.equalTo(hazardousLabel.snp.bottom).offset(5)
            make.top.greaterThanOrEqualTo(safeArea).offset(5)
            make.centerX.equalTo(safeArea)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(destroyButton.snp.bottom).offset(20)
            make.bottom.equalTo(safeArea)
            make.leading.equalTo(safeArea)
            make.trailing.equalTo(safeArea)
        }
    }
    
    private func setupBinders() {
        viewModel.asteroid
            .sink { [weak self] model in
                guard model != nil else { return }
                self?.updateUI(model!)
            }.store(in: &cancellables)
        viewModel.asteroidApproachData
            .sink { [weak self] a in
                print(a.count)
                self?.collectionView.reloadData()
            }.store(in: &cancellables)
    }
    
    private func updateUI(_ model: AsteroidModel) {
        title = model.name
        nameLabel.text = model.name
        hazardousLabel.text = String(model.potentiallyHazardouds)
        diameterLabel.text = String(model.estimatedDiameter)
    }
}
// MARK: - Methods
extension AsteroidDetailViewController {
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let size = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(80))
        let item = NSCollectionLayoutItem(layoutSize: size)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 16, bottom: 5, trailing: 16)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        return UICollectionViewCompositionalLayout(section: section)
    }
}
// MARK: - UICollectionView Delegate/DS
extension AsteroidDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ApproachCollectionViewCell.identifier, for: indexPath) as! ApproachCollectionViewCell
        cell.configure(viewModel.asteroidApproachData.value[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.asteroidApproachData.value.count
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        
        if yOffset >= 0 {
            if destroyButton.frame.origin.y > view.safeAreaInsets.top + 10 || yOffset < destroyButton.frame.origin.y + destroyButton.bounds.height {
                topContainerViewTopConstraint.update(offset: 10 - yOffset)
            }
        } else if topContainerViewTopConstraint.layoutConstraints.first!.constant != 10 {
            topContainerViewTopConstraint.update(offset: 10)
        }
    }
}

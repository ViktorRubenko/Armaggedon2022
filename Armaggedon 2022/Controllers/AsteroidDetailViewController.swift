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
    
    private let diameterLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    private let hazardousLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 25, weight: .semibold)
        return label
    }()
    private lazy var destroyButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        let button = UIButton(configuration: config, primaryAction: nil)
        button.layer.cornerRadius = 14
        button.clipsToBounds = true
        button.backgroundColor = Constants.Colors.destroyButtonColor
        button.setTitleColor(Constants.Colors.secondaryLabelColor, for: .normal)
        button.setTitle("УНИЧТОЖИТЬ", for: .normal)
        button.addTarget(self, action: #selector(didTapDestroyButton), for: .touchUpInside)
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
    let topBackgroudView = UIView()
    private let gradientLayer = CAGradientLayer()
    private var setGradient = true
    private var topContainerViewTopConstraint: Constraint!
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: self.createLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.register(ApproachCollectionViewCell.self, forCellWithReuseIdentifier: ApproachCollectionViewCell.identifier)
        collectionView.register(ApproachesHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ApproachesHeaderView.identifier)
        return collectionView
    }()
    private let approachesLabel: UILabel = {
        let label = UILabel()
        label.text = "Подлеты:"
        label.font = .systemFont(ofSize: 30)
        label.textAlignment = .center
        return label
    }()
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.startAnimating()
        indicator.hidesWhenStopped = true
        return indicator
    }()
    private var maxOffset: Double = 0.0

    init(viewModel: AsteroidDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Астероид"
        setupViews()
        setupBinders()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if setGradient {
            setGradient = false
            gradientLayer.frame = topContainerView.bounds
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.9)
            maxOffset = topContainerView.frame.origin.y - destroyButton.frame.origin.y + 5
            print(maxOffset)
        }
    }
}
// MARK: - Methods
extension AsteroidDetailViewController {
    private func setupViews() {
        view.backgroundColor = .white
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(topContainerView)
        topContainerView.addSubview(topBackgroudView)
        topBackgroudView.layer.cornerRadius = topContainerView.layer.cornerRadius
        topBackgroudView.clipsToBounds = true
        topBackgroudView.layer.insertSublayer(gradientLayer, at: 0)
        topContainerView.addSubview(nameLabel)
        topContainerView.addSubview(diameterLabel)
        topContainerView.addSubview(hazardousLabel)
        view.addSubview(destroyButton)
        view.addSubview(collectionView)
        view.addSubview(loadingIndicator)
        
        topContainerView.snp.makeConstraints { make in
            topContainerViewTopConstraint = make.top.equalTo(safeArea).offset(10).constraint
            make.leading.equalTo(safeArea).offset(10)
            make.trailing.equalTo(safeArea).offset(-10)
            make.bottom.equalTo(destroyButton).offset(5)
        }
        
        topBackgroudView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
        
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalTo(collectionView)
        }
    }
    
    private func setupBinders() {
        viewModel.asteroidInfo
            .sink { [weak self] model in
                guard model != nil else { return }
                self?.updateUI(model!)
            }.store(in: &cancellables)
        viewModel.asteroidApproachData
            .sink { [weak self] approaches in
                guard !approaches.isEmpty else { return }
                self?.loadingIndicator.stopAnimating()
                self?.collectionView.reloadData()
            }.store(in: &cancellables)
    }
    
    private func updateUI(_ model: AsteroidInfo) {
        nameLabel.text = model.name
        hazardousLabel.text = model.hazardousSring
        diameterLabel.text = model.diameterString
        gradientLayer.colors = model.hazardous ? Constants.GradientColors.red.reversed() : Constants.GradientColors.green.reversed()
    }
}
// MARK: - Methods
extension AsteroidDetailViewController {
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let size = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(80))
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(30)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 19.5, leading: 16, bottom: 19.5, trailing: 16)
        section.boundarySupplementaryItems = [sectionHeader]
        return UICollectionViewCompositionalLayout(section: section)
    }
}
// MARK: - Actions {
extension AsteroidDetailViewController {
    @objc private func didTapDestroyButton() {
        viewModel.addToDestroyList()
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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ApproachesHeaderView.identifier, for: indexPath)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        
        if yOffset >= 0 {
            if destroyButton.frame.origin.y > view.safeAreaInsets.top + 10 {
                topContainerViewTopConstraint.update(offset: 10 - yOffset)
            } else {
                topContainerViewTopConstraint.update(offset: maxOffset)
            }
        } else if topContainerViewTopConstraint.layoutConstraints.first!.constant != 10 {
            topContainerViewTopConstraint.update(offset: 10)
        }
    }
}

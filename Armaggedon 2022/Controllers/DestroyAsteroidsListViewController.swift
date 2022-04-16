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
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            DestroyAsteroidTableViewCell.self,
            forCellReuseIdentifier: DestroyAsteroidTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
        return tableView
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
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
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
        
        view.addSubview(tableView)
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 30, right: 0)
        tableView.backgroundColor = .white
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupNavigationBar() {
        title = "На уничтожение"
        let editButton = UIBarButtonItem(
            title: "Изменить",
            style: .plain,
            target: self,
            action: #selector(didTapEditButton(_:)))
        navigationItem.leftBarButtonItem = editButton
    }
    
    private func setupBinders() {
        viewModel.asteroidsToDestroy.sink { [weak self] _ in
            self?.tableView.reloadData()
        }.store(in: &cancellables)
    }
}
// MARK: - Actions
extension DestroyAsteroidsListViewController {
    @objc func didTapEditButton(_ sender: UIBarButtonItem) {
        sender.title = tableView.isEditing ? "Изменить" : "Готово"
        setEditing(!tableView.isEditing, animated: true)
    }
}
// MARK: - UICollectionView Delegate/DS
extension DestroyAsteroidsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.asteroidsToDestroy.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: DestroyAsteroidTableViewCell.identifier,
            for: indexPath) as! DestroyAsteroidTableViewCell
        let model = viewModel.asteroidsToDestroy.value[indexPath.row]
        cell.configure(model)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            cancellables.removeAll()
            viewModel.removeFromList(indexPath.row)
            tableView.performBatchUpdates {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            setupBinders()
        }
    }
}
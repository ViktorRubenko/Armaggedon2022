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
    private lazy var sendBrigadeButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        config.title = "Заказ бригады им. Брюса Уиллиса"
        let button = UIButton(configuration: config, primaryAction: nil)
        button.setTitleColor(Constants.Colors.secondaryLabelColor, for: .normal)
        button.titleLabel?.numberOfLines = 2
        button.backgroundColor = Constants.Colors.destroyButtonColor
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTapBridageButton), for: .touchUpInside)
        button.layer.shadowColor = UIColor.lightGray.cgColor
        button.layer.shadowOpacity = 1.0
        button.layer.shadowRadius = 10
        button.isHidden = true
        return button
    }()
    private let noAstroidsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.text = "Астероидов пока нет..."
        label.numberOfLines = 2
        label.textColor = .darkGray
        label.isHidden = true
        label.textAlignment = .center
        return label
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

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
        setupNavigationBar()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: sendBrigadeButton.bounds.height + 15, right: 0)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setEditing(false, animated: false)
    }
}
// MARK: - Methods
extension DestroyAsteroidsListViewController {
    private func setupViews() {
        let safeArea = view.safeAreaLayoutGuide
        view.backgroundColor = .white

        view.addSubview(tableView)
        tableView.backgroundColor = .white
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        view.addSubview(sendBrigadeButton)
        sendBrigadeButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeArea).offset(-10)
            make.leading.greaterThanOrEqualTo(safeArea).offset(10)
            make.trailing.lessThanOrEqualTo(safeArea).offset(-10)
            make.centerX.equalTo(safeArea)
        }

        view.addSubview(noAstroidsLabel)
        noAstroidsLabel.snp.makeConstraints { make in
            make.center.equalTo(tableView)
            make.width.equalTo(tableView).multipliedBy(0.8)
        }
    }

    private func setupNavigationBar() {
        title = "На уничтожение"
        if tableView.numberOfRows(inSection: 0) != 0 {
            let editButton = UIBarButtonItem(
                title: !tableView.isEditing ? "Изменить" : "Готово",
                style: .plain,
                target: self,
                action: #selector(didTapEditButton(_:)))
            navigationItem.leftBarButtonItem = editButton

            if tableView.isEditing {
                navigationItem.rightBarButtonItem = UIBarButtonItem(
                    title: "Удалить все",
                    style: .plain,
                    target: self,
                    action: #selector(didTapRemoveAllButton))
            } else {
                navigationItem.rightBarButtonItem = nil
            }
        } else {
            navigationItem.leftBarButtonItem = nil
            navigationItem.rightBarButtonItem = nil
        }
    }

    private func setupBinders() {
        viewModel.asteroidsToDestroy.sink { [weak self] asteroids in
            self?.tableView.reloadData()
            self?.sendBrigadeButton.isHidden = asteroids.isEmpty
            self?.noAstroidsLabel.isHidden = !asteroids.isEmpty
            self?.setupNavigationBar()
        }.store(in: &cancellables)
    }
}
// MARK: - Actions
extension DestroyAsteroidsListViewController {
    @objc func didTapEditButton(_ sender: UIBarButtonItem) {
        setEditing(!tableView.isEditing, animated: true)
    }
    @objc func didTapBridageButton() {
        let alert = UIAlertController(
            title: "Бригада заказана!",
            message: "Бригада будет доставлена на астероид в нужный момент для его уничтожения!",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
    @objc func didTapRemoveAllButton() {
        viewModel.removeAll()
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
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            setupBinders()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let asteroid = viewModel.getResponseModel(indexPath.row)
        let vc = AsteroidDetailViewController(viewModel: AsteroidDetailViewModel(asteroidModel: asteroid))
        navigationController?.pushViewController(vc, animated: true)
    }
}

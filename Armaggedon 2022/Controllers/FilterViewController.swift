//
//  FilterViewController.swift
//  Armaggedon 2022
//
//  Created by Victor Rubenko on 14.04.2022.
//

import UIKit
import Combine

class FilterViewController: UIViewController {
    private var cancellables = Set<AnyCancellable>()
    private let viewModel: FilterViewModelProtocol!
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 44
        tableView.allowsSelection = false
        return tableView
    }()

    init(viewModel: FilterViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupViews()
    }
}
// MARK: - Methods
extension FilterViewController {
    private func setupViews() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setupNavigationBar() {
        title = "Фильтр"
        let backButton = UIBarButtonItem()
        backButton.title = "Назад"
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Применить", style: .done, target: self, action: #selector(didTapApplyButton))
    }
}
// MARK: - Actions {
extension FilterViewController {
    @objc func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    @objc func didTapApplyButton() {
        viewModel.apply()
        navigationController?.popViewController(animated: true)
    }
}
// MARK: - TableView Delegate/DS
extension FilterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.cells.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = viewModel.cells[indexPath.row]
        switch cellType {
        case .units:
            let cell = UnitsFilterTableViewCell()
            cell.configure(selectedUnits: viewModel.units)
            cell.controlCallback = { [weak self] index in
                self?.viewModel.setUnits(units: Constants.Units.allCases[index])
            }
            return cell
        case .onlyHazardous:
            let cell = HazardousFilterTableViewCell()
            cell.configure(onlyHazardous: viewModel.onlyHazardous)
            cell.controlCallback = { [weak self] value in
                self?.viewModel.setHazardous(onlyHazardous: value)
            }
            return cell
        }
    }
}

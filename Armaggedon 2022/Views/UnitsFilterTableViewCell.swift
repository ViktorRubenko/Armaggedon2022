//
//  UnitsFilterTableViewCell.swift
//  Armaggedon 2022
//
//  Created by Victor Rubenko on 15.04.2022.
//

import UIKit

class UnitsFilterTableViewCell: UITableViewCell {

    private let label: UILabel = {
        let label = UILabel()
        label.textColor = Constants.Colors.primaryLabelColor
        label.text = "Ед. изм. расстояний"
        label.font = .systemFont(ofSize: 17)
        return label
    }()
    
    private let control: UISegmentedControl = {
        let control = UISegmentedControl(items: Constants.Units.allCases.compactMap{$0.rawValue})
        control.selectedSegmentIndex = 0
        return control
    }()
    
    var controlCallback: ((Int) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - Methods
extension UnitsFilterTableViewCell {
    private func setupViews() {
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.height.equalTo(22)
            make.centerY.equalToSuperview()
        }
        
        contentView.addSubview(control)
        control.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-4)
        }
        control.addTarget(self, action: #selector(didTapControl), for: .valueChanged)
    }
    
    @objc func didTapControl() {
        controlCallback?(control.selectedSegmentIndex)
    }
    
    func configure(selectedUnits: Constants.Units) {
        control.selectedSegmentIndex = Constants.Units.allCases.firstIndex(of: selectedUnits)!
    }
}

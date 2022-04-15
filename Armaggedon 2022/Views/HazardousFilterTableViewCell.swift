//
//  HazardousFIlterTableViewCell.swift
//  Armaggedon 2022
//
//  Created by Victor Rubenko on 15.04.2022.
//

import UIKit

class HazardousFilterTableViewCell: UITableViewCell {

    private let label: UILabel = {
        let label = UILabel()
        label.textColor = Constants.Colors.primaryLabelColor
        label.text = "Показывать только опасные"
        label.font = .systemFont(ofSize: 17)
        return label
    }()
    
    private let control = UISwitch()
    
    var controlCallback: ((Bool) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - Methods
extension HazardousFilterTableViewCell {
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
        controlCallback?(control.isOn)
    }
    
    func configure(onlyHazardous: Bool) {
        control.isOn = onlyHazardous
    }
}

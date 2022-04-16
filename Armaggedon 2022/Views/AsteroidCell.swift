//
//  AsteroidCell.swift
//  Armaggedon 2022
//
//  Created by Victor Rubenko on 14.04.2022.
//

import UIKit

class AsteroidCell: UICollectionViewCell {
    static let identifier = "AsteroidCell"
    private let headerView: HeaderApproachView = {
        let view = HeaderApproachView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    private let infoLabelStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 8
        return stack
    }()
    private let diameterLabel = UILabel.defaultLabel()
    private let dateLabel = UILabel.defaultLabel()
    private let distanceLabel = UILabel.defaultLabel()
    private let hazardousLabel = UILabel.defaultLabel()
    private let destroyButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = Constants.Colors.destroyButtonColor
        button.layer.cornerRadius = 14
        button.setTitleColor(Constants.Colors.secondaryLabelColor, for: .normal)
        button.setTitle("УНИЧТОЖИТЬ", for: .normal)
        return button
    }()
    var destroyButtonHandler: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - Methods
extension AsteroidCell {
    private func setupViews() {
        backgroundColor = .white
        
        layer.cornerRadius = 10
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.0986753).cgColor
        layer.shadowOpacity = 10
        layer.shadowOffset = CGSize(width: 0, height: 0)
        
        contentView.addSubview(headerView)
        contentView.addSubview(infoLabelStack)
        contentView.addSubview(hazardousLabel)
        contentView.addSubview(destroyButton)
        infoLabelStack.addArrangedSubview(diameterLabel)
        infoLabelStack.addArrangedSubview(dateLabel)
        infoLabelStack.addArrangedSubview(distanceLabel)
        
        headerView.snp.makeConstraints { make in
            make.height.equalTo(145)
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        infoLabelStack.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(headerView.snp.bottom).offset(16)
            make.bottom.equalTo(hazardousLabel.snp.top).offset(-16)
        }
        
        hazardousLabel.snp.makeConstraints { make in
            make.leading.equalTo(infoLabelStack)
            make.height.equalTo(24)
            make.bottom.equalToSuperview().offset(-19)
        }
        
        destroyButton.addTarget(self, action: #selector(didTapDestroyButton), for: .touchUpInside)
        destroyButton.snp.makeConstraints { make in
            make.height.equalTo(28)
            make.width.equalTo(121)
            make.trailing.equalTo(-16)
            make.bottom.equalTo(-16)
        }
    }
    
    func configure(_ model: AsteroidCellModel) {
        headerView.configure(
            name: model.name,
            asteroidDiamater: model.diameter,
            potentiallyHazardous: model.hazardous)
        diameterLabel.text = "Диаметр: \(model.diameter) м"
        dateLabel.text = "Подлетает \(model.dateString)"
        distanceLabel.text = "на расстояние \(model.distanceString)"
        let hazardousString = NSMutableAttributedString(string: "Оценка: ")
        if model.hazardous {
            hazardousString.append(NSAttributedString(string: "опасен", attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.red,
                NSAttributedString.Key.font: UIFont(name: "Helvetica-bold", size: 16) ?? .systemFont(ofSize: 16, weight: .bold)
            ]))
        } else {
            hazardousString.append(NSAttributedString(string: "не опасен"))
        }
        hazardousLabel.attributedText = hazardousString
    }
}
// MARK: - Actions
extension AsteroidCell {
    @objc func didTapDestroyButton() {
        UIView.animate(
            withDuration: 0.05,
            animations: {
                self.destroyButton.backgroundColor = .red
            }, completion: { _ in
                UIView.animate(
                    withDuration: 0.05,
                    animations: {
                        self.destroyButton.backgroundColor = Constants.Colors.destroyButtonColor
                    },
                    completion: { _ in
                        self.destroyButtonHandler?()
                    })
            })
    }
}


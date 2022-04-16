//
//  DestroyAsteroidCollectionViewCell.swift
//  Armaggedon 2022
//
//  Created by Victor Rubenko on 15.04.2022.
//

import UIKit

class DestroyAsteroidTableViewCell: UITableViewCell {
    
    static let identifier = "DestroyAsteroidTableViewCell"
    
    private let innerContentView = UIView()
    private let gradientView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        return view
    }()
    private let gradientLayer = CAGradientLayer()
    private let nameLabel = UILabel.defaultLabel()
    private let diameterLabel: UILabel = {
        let label = UILabel.defaultLabel()
        label.textAlignment = .right
        return label
    }()
    private let dateLabel = UILabel.defaultLabel()
    private let hazardousLabel: UILabel = {
        let label = UILabel.defaultLabel()
        label.textColor = .white
        label.textAlignment = .right
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientView.layoutIfNeeded()
        diameterLabel.layoutIfNeeded()
        gradientLayer.frame = gradientView.bounds
        gradientLayer.startPoint = CGPoint(x: 0.33, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
    }
}
// MAKR: - Methods
extension DestroyAsteroidTableViewCell {
    private func setupViews() {
        backgroundColor = .clear
        
        contentView.addSubview(innerContentView)
        innerContentView.addSubview(gradientView)
        gradientView.addSubview(nameLabel)
        gradientView.addSubview(hazardousLabel)
        innerContentView.addSubview(diameterLabel)
        innerContentView.addSubview(dateLabel)
        
        innerContentView.layer.cornerRadius = 10
        innerContentView.layer.shadowColor = UIColor.lightGray.cgColor
        innerContentView.layer.shadowOpacity = 10
        innerContentView.layer.shadowOffset = .zero
        innerContentView.backgroundColor = .white
        innerContentView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-8).priority(.low)
        }
        
        gradientView.layer.insertSublayer(gradientLayer, at: 0)
        gradientView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(30)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(5)
            make.centerY.equalToSuperview()
        }
        
        hazardousLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-5)
            make.centerY.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(5)
            make.top.equalTo(gradientView.snp.bottom).offset(5)
            make.bottom.equalToSuperview().offset(-5)
        }
        
        diameterLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-5)
            make.bottom.equalTo(dateLabel)
            make.top.equalTo(dateLabel)
        }
    }
    
    func configure(_ model: AsteroidCellModel) {
        nameLabel.text = model.name
        if model.hazardous {
            hazardousLabel.text = "ОПАСЕН"
            gradientLayer.colors = Constants.GradientColors.lightRed
        } else {
            hazardousLabel.text = "НЕ ОПАСЕН"
            gradientLayer.colors = Constants.GradientColors.lightGreen
        }
        dateLabel.text = model.dateString
        diameterLabel.text = "Диаметр: \(model.diameter) м"
    }
}

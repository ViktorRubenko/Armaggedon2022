//
//  DestroyAsteroidCollectionViewCell.swift
//  Armaggedon 2022
//
//  Created by Victor Rubenko on 15.04.2022.
//

import UIKit

class DestroyAsteroidCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "DestroyAsteroidCollectionViewCell"
    
    private let bgView = UIView()
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
    private var needsSetGradient = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if needsSetGradient {
            needsSetGradient.toggle()
            gradientView.layoutIfNeeded()
            diameterLabel.layoutIfNeeded()
            gradientLayer.frame = gradientView.bounds
            gradientLayer.startPoint = CGPoint(x: 0.33, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            
            bgView.layoutIfNeeded()
            
//            bgView.layer.cornerRadius = 10
//            bgView.layer.shadowColor = UIColor.gray.cgColor
//            bgView.layer.shadowOpacity = 10
//            bgView.layer.shadowOffset = .zero
//            backgroundView.layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        }
    }
}
// MAKR: - Methods
extension DestroyAsteroidCollectionViewCell {
    private func setupViews() {
        backgroundColor = .white
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 10
        layer.shadowOffset = .zero
        
        contentView.addSubview(gradientView)
        gradientView.addSubview(nameLabel)
        gradientView.addSubview(hazardousLabel)
        contentView.addSubview(diameterLabel)
        contentView.addSubview(dateLabel)
        
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

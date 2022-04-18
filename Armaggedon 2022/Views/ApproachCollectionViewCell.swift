//
//  ApproachCollectionViewCell.swift
//  Armaggedon 2022
//
//  Created by Victor Rubenko on 18.04.2022.
//

import UIKit

class ApproachCollectionViewCell: UICollectionViewCell {
    static let identifier = "ApproachCollectionViewCell"
    private let distanceLabel: UILabel = {
        let label = UILabel.defaultLabel()
        label.text = "Расстояние:"
        return label
    }()
    private let dateLabel: UILabel = {
        let label = UILabel.defaultLabel()
        label.textAlignment = .center
        return label
    }()
    private let velocityLabel: UILabel = {
        let label = UILabel.defaultLabel()
        label.text = "Скорость:"
        return label
    }()
    private let orbitLabel: UILabel = {
        let label = UILabel.defaultLabel()
        label.text = "Орбита:"
        return label
    }()
    private let distanceValueLabel: UILabel = {
        let label = UILabel.defaultLabel()
        label.textColor = .darkGray
        label.textAlignment = .right
        return label
    }()
    private let velocityValueLabel: UILabel = {
        let label = UILabel.defaultLabel()
        label.textColor = .darkGray
        label.textAlignment = .right
        return label
    }()
    private let orbitValueLabel: UILabel = {
        let label = UILabel.defaultLabel()
        label.textColor = .darkGray
        label.textAlignment = .right
        return label
    }()
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.5)
        return view
    }()
    private let hStackViews: [UIStackView] = {
        var stackViews = [UIStackView]()
        for _ in 0...2 {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            stackViews.append(stackView)
        }
        return stackViews
    }()
    private let vStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.spacing = 5
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - Methods
extension ApproachCollectionViewCell {
    private func setupViews() {
        
        layer.cornerRadius = 10
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.3
        layer.shadowColor = UIColor.lightGray.cgColor
        backgroundColor = .white
        
        contentView.addSubview(dateLabel)
        contentView.addSubview(separatorView)
        contentView.addSubview(vStackView)
        hStackViews.forEach { vStackView.addArrangedSubview($0) }
        hStackViews[0].addArrangedSubview(distanceLabel)
        hStackViews[0].addArrangedSubview(distanceValueLabel)
        hStackViews[1].addArrangedSubview(velocityLabel)
        hStackViews[1].addArrangedSubview(velocityValueLabel)
        hStackViews[2].addArrangedSubview(orbitLabel)
        hStackViews[2].addArrangedSubview(orbitValueLabel)
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().offset(-5)
        }
        
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        vStackView.snp.makeConstraints { make in
            make.top.equalTo(separatorView.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().offset(-5)
            make.bottom.equalToSuperview().offset(-5)
        }
    }
    
    func configure(_ model: ApproachData) {
        distanceValueLabel.text = model.distanceString
        velocityValueLabel.text = model.velocity
        dateLabel.text = model.dateString
        orbitValueLabel.text = model.orbitingBody
    }
}

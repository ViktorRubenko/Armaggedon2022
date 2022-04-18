//
//  ApproachCollectionViewCell.swift
//  Armaggedon 2022
//
//  Created by Victor Rubenko on 18.04.2022.
//

import UIKit

class ApproachCollectionViewCell: UICollectionViewCell {
    static let identifier = "ApproachCollectionViewCell"
    
    private let distanceLabel = UILabel.defaultLabel()
    private let datelabel = UILabel.defaultLabel()
    private let velocityLabel = UILabel.defaultLabel()
    private let orbitLabel = UILabel.defaultLabel()
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
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
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(distanceLabel)
        stackView.addArrangedSubview(datelabel)
        stackView.addArrangedSubview(velocityLabel)
        stackView.addArrangedSubview(orbitLabel)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(_ model: ApproachData) {
        distanceLabel.text = model.distanceString
        velocityLabel.text = model.velocity
        datelabel.text = model.dateString
        orbitLabel.text = model.orbitingBody
    }
}


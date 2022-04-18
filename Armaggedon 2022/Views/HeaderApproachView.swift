//
//  HeaderApproachView.swift
//  Armaggedon 2022
//
//  Created by Victor Rubenko on 14.04.2022.
//

import UIKit
import SnapKit

class HeaderApproachView: UIView {

    private let asteroidImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "asteroid")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let dinoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "dino")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica-Bold", size: 20)
        label.textColor = .black
        return label
    }()
    private var gradientLayer = CAGradientLayer()
    private var needSetGradientLayer = true
    private var asteroidSizeConstraint: Constraint!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if needSetGradientLayer {
            needSetGradientLayer.toggle()
            gradientLayer.frame = bounds
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        }
    }

    private func setup() {
        clipsToBounds = true
        layer.insertSublayer(gradientLayer, at: 0)

        addSubview(nameLabel)
        addSubview(dinoImageView)
        addSubview(asteroidImageView)

        nameLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-8)
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(32)
        }

        dinoImageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview().offset(-12)
            make.height.equalTo(30)
            make.width.equalTo(35)
        }

        asteroidImageView.snp.makeConstraints { make in
            make.bottom.equalTo(nameLabel.snp.top).offset(-21)
            make.leading.lessThanOrEqualToSuperview().offset(27)
            make.trailing.lessThanOrEqualToSuperview().offset(-40)
            asteroidSizeConstraint = make.size.equalTo(61).constraint
        }
    }

    func configure(name: String, asteroidDiamater: Int, potentiallyHazardous: Bool) {
        nameLabel.text = name
        var size = 61.0 / 85.0 * Double(asteroidDiamater)
        size = size > 800 ? 340 : size
        size = size < 25 ? 25 : size
        asteroidSizeConstraint.deactivate()
        asteroidImageView.snp.makeConstraints { make in
            asteroidSizeConstraint = make.size.equalTo(size).constraint
        }
        gradientLayer.colors = potentiallyHazardous ? Constants.GradientColors.red : Constants.GradientColors.green
    }
}

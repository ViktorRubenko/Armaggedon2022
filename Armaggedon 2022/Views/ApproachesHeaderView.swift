//
//  ApproachesHeaderView.swift
//  Armaggedon 2022
//
//  Created by Victor Rubenko on 18.04.2022.
//

import UIKit

class ApproachesHeaderView: UICollectionReusableView {
    
    static let identifier = "ApproachesHeaderView"
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30)
        label.text = "Подлеты:"
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

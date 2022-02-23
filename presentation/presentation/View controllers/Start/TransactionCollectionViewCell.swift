//
//  TransactionCollectionViewCell.swift
//  presentation
//
//  Created by Karim Karimov on 23.02.22.
//

import UIKit
import domain

class TransactionCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI components
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        self.contentView.addSubview(label)
        
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .darkGray
        label.numberOfLines = 2
        
        return label
    }()
    
    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        
        self.contentView.addSubview(label)
        
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .black
        label.textAlignment = .right
        
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        
        self.contentView.addSubview(label)
        
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .gray
        
        return label
    }()
    
    // MARK: - Parent delegates
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        
        self.amountLabel.snp.makeConstraints { make in
            make.top.equalTo(self.contentView.snp.top).offset(8)
            make.right.equalTo(self.contentView.snp.right).offset(-16)
            make.width.equalTo(100)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.contentView.snp.top).offset(8)
            make.left.equalTo(self.contentView.snp.left).offset(16)
            make.right.equalTo(self.amountLabel.snp.left).offset(-8)
        }
        
        self.dateLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(4)
            make.left.equalTo(self.contentView.snp.left).offset(16)
            make.right.equalTo(self.contentView.snp.right).offset(-8)
        }
        
    }
    
    func setData(transaction: Transaction) {
        self.titleLabel.text = transaction.title
        self.amountLabel.text = "\(transaction.amount * -1.0) \(transaction.currency)"
        self.dateLabel.text = transaction.datetime.formatted(format: "HH:mm dd-MM-yyyy")
    }
}

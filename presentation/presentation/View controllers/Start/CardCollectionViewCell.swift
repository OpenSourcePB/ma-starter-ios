//
//  CardCollectionViewCell.swift
//  presentation
//
//  Created by Karim Karimov on 23.02.22.
//

import UIKit
import domain

class CardCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI components
    
    private lazy var panLabel: UILabel = {
        let label = UILabel()
        
        self.contentView.addSubview(label)
        
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .darkGray
        
        return label
    }()
    
    private lazy var balanceLabel: UILabel = {
        let label = UILabel()
        
        self.contentView.addSubview(label)
        
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        
        return label
    }()
    
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        
        self.contentView.addSubview(label)
        
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .gray
        
        return label
    }()
    
    private lazy var issuerLogo: UIImageView = {
        let view = UIImageView()
        
        self.contentView.addSubview(view)
        
        view.contentMode = .scaleAspectFit
        
        return view
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
        self.contentView.addTapGestureRecognizer(action: {
            self.onSelect?()
        })
        
        self.panLabel.snp.makeConstraints { make in
            make.top.equalTo(self.contentView.snp.top).offset(16)
            make.left.equalTo(self.contentView.snp.left).offset(12)
            make.right.equalTo(self.issuerLogo.snp.left).offset(-4)
        }
        
        self.balanceLabel.snp.makeConstraints { make in
            make.top.equalTo(self.panLabel.snp.bottom).offset(8)
            make.left.equalTo(self.contentView.snp.left).offset(12)
            make.right.equalTo(self.contentView.snp.right).offset(-12)
        }
        
        self.statusLabel.snp.makeConstraints { make in
            make.top.equalTo(self.balanceLabel.snp.bottom).offset(8)
            make.left.equalTo(self.contentView.snp.left).offset(12)
            make.right.equalTo(self.contentView.snp.right).offset(-12)
        }
        
        self.issuerLogo.snp.makeConstraints { make in
            make.top.equalTo(self.contentView.snp.top).offset(8)
            make.right.equalTo(self.contentView.snp.right).offset(-12)
            make.width.equalTo(36)
            make.height.equalTo(36)
        }
    }
    
    func setData(card: Card, isSelected: Bool) {
        
        self.panLabel.text = "* \(card.pan.suffix(4))"
        self.balanceLabel.text = "\(card.balance) \(card.currency)"
        self.statusLabel.text = self.getStatusTitle(cardStatus: card.status)
        
        self.issuerLogo.image = self.getImage(cardType: card.type)
        
        if isSelected {
            self.setBorder(view: self.contentView, radius: 8, width: 2, color: .systemGreen)
        } else {
            self.setBorder(view: self.contentView, radius: 8, width: 1, color: .lightGray)
        }
    }
    
    private func setBorder(view: UIView, radius: Int, width: Int, color: UIColor) {
        view.layer.cornerRadius = CGFloat(radius)
        view.layer.borderWidth = CGFloat(width)
        view.layer.borderColor = color.cgColor
    }
    
    private func getImage(cardType: ECardType) -> UIImage? {
        switch cardType {
        case .visa:
            return Asset.icVisa.image
        case .master:
            return Asset.icMaster.image
        case .union_pay:
            return Asset.icUnionPay.image
        case .unknown:
            return nil
        }
    }
    
    private func getStatusTitle(cardStatus: ECardStatus) -> String {
        switch cardStatus {
        case .active:
            return L10n.active
        case .blocked:
            return L10n.blocked
        case .expired:
            return L10n.expired
        }
    }

    // MARK: - Callback
    
    var onSelect: (() -> Void)?
}


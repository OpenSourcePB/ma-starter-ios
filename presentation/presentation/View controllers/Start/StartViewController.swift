//
//  StartViewController.swift
//  presentation
//
//  Created by Karim Karimov on 18.03.21.
//

import UIKit
import domain
import RxSwift

public class StartViewController: UIBaseViewController<Void, Void, StartViewModel> {
    
    // MARK: - Variables
    
    private let cardCellID = "cardCell"
    private let transactionCellID = "transactionCell"
    
    // MARK: - UI Components
    
    private lazy var customerName: UILabel = {
        let label = UILabel()
        
        self.view.addSubview(label)
        
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textColor = .black
        
        return label
    }()
    
    private lazy var customerPhone: UILabel = {
        let label = UILabel()
        
        self.view.addSubview(label)
        
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .gray
        
        return label
    }()
    
    private lazy var cardCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout.init()
                
        flowLayout.scrollDirection = .horizontal
        
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        view.backgroundColor = .clear
        
        view.register(CardCollectionViewCell.self, forCellWithReuseIdentifier: self.cardCellID)
        
        view.delegate = self
        view.dataSource = self
        
        self.view.addSubview(view)
        
        view.showsHorizontalScrollIndicator = false
        
        view.contentInset.left = 16
        view.contentInset.right = 16
        
        return view
    }()
    
    private lazy var transactionCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout.init()
                
        flowLayout.scrollDirection = .vertical
        
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        view.backgroundColor = .clear
        
        view.register(TransactionCollectionViewCell.self, forCellWithReuseIdentifier: self.transactionCellID)
        
        view.delegate = self
        view.dataSource = self
        
        self.view.addSubview(view)
        
        return view
    }()
    
    // MARK: - Parent delegates

    override func initViews() {
        super.initViews()
        
        self.view.backgroundColor = .white
        
        self.customerName.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(16)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-16)
        }
        
        self.customerPhone.snp.makeConstraints { make in
            make.top.equalTo(self.customerName.snp.bottom).offset(4)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(16)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-16)
        }
        
        self.cardCollectionView.snp.makeConstraints { make in
            make.top.equalTo(self.customerPhone.snp.bottom).offset(16)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right)
            make.height.equalTo(120)
        }
        
        self.transactionCollectionView.snp.makeConstraints { make in
            make.top.equalTo(self.cardCollectionView.snp.bottom).offset(8)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let customerSubscription = self.viewModel.observeCustomer()
            .sink { customer in
                self.setData(customer: customer)
            }
        
        self.addCancellable(customerSubscription)
        
        let cardsSubscription = self.viewModel.observeCards()
            .sink { cards in
                self.setData(cards: cards)
            }
        
        self.addCancellable(cardsSubscription)
        
        let activeCardSubscription = self.viewModel.observeActiveCard()
            .sink { card in
                self.setData(activeCard: card)
            }
        
        self.addCancellable(activeCardSubscription)
        
        let transactionsSubscription = self.viewModel.observeTransactions()
            .sink { transactions in
                self.setData(transactions: transactions)
            }
        
        self.addCancellable(transactionsSubscription)
    }
    
    // MARK: - UI
    
    private func setData(customer: Customer) {
        self.customerName.text = customer.name
        self.customerPhone.text = customer.phone
    }
    
    private func setData(cards: [Card]) {
        self.cardCollectionView.reloadData()
    }
    
    private func setData(activeCard: Card?) {
        self.cardCollectionView.reloadData()
    }
    
    private func setData(transactions: [Transaction]) {
        self.transactionCollectionView.reloadData()
    }
}


// MARK: - Collection view

extension StartViewController: UICollectionViewDataSource,
                               UICollectionViewDelegate,
                               UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.cardCollectionView {
            return self.viewModel.getCards().count
        } else {
            return self.viewModel.getTransactions().count
        }
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.cardCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cardCellID, for: indexPath) as! CardCollectionViewCell
            
            let card = self.viewModel.getCards()[indexPath.row]
            let isSelected = self.viewModel.isCardSelected(card: card)
            cell.setData(card: card, isSelected: isSelected)
            
            cell.onSelect = {
                self.viewModel.select(card: card)
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.transactionCellID, for: indexPath) as! TransactionCollectionViewCell
            
            let transaction = self.viewModel.getTransactions()[indexPath.row]
            cell.setData(transaction: transaction)
            
            return cell
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == cardCollectionView {
            let size = CGSize(width: 200, height: 110)
            return size
        } else {
            let size = CGSize(width: self.view.frame.width, height: 70)
            return size
        }
    }
}

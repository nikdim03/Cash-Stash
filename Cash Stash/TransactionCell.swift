////
////  TransactionCell.swift
////  Cash Stash
////
////  Created by Dmitriy on 10/31/22.
////
//
//import UIKit
//
//class TransactionCell: UITableViewCell {
//    @UsesAutoLayout
//    var amountLabel = UILabel()
//    @UsesAutoLayout
//    var titleLabel = UILabel()
//    @UsesAutoLayout
//    var categoryLabel = UILabel()
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//        
//    func configureTransactionCell(with model: TransactionCellModel) {
//        if model.isIncome {
//            amountLabel.text = "+ \(model.amount) \(model.currency)"
//            amountLabel.textColor = .green
//        } else {
//            amountLabel.text = "- \(model.amount) \(model.currency)"
//            amountLabel.textColor = .red
//        }
//        titleLabel.text = model.payee.isEmpty ? "No content" : model.payee
//        categoryLabel.text = model.category
//        configureTitleLabel()
//        configureAmountLabel()
//        configureCategoryLabel()
//    }
//    func configureTitleLabel() {
//        contentView.addSubview(titleLabel)
//        titleLabel.topAnchor.constraint(equalTo: topAnchor).activate()
//        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).activate()
//    }
//
//    func configureAmountLabel() {
//        contentView.addSubview(amountLabel)
//        amountLabel.centerYAnchor.constraint(equalTo: centerYAnchor).activate()
//        amountLabel.widthAnchor.constraint(equalToConstant: 100).activate()
//        amountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).activate()
//    }
//    
//    func configureCategoryLabel() {
//        if (categoryLabel.text != "") {
//            contentView.addSubview(categoryLabel)
//            categoryLabel.bottomAnchor.constraint(equalTo: bottomAnchor).activate()
//            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).activate()
//        }
//    }
//}

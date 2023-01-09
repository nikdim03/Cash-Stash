//
//  TranDetInteractor.swift
//  Cash Stash
//
//  Created by Dmitriy on 1/7/23.
//

import UIKit

//object
//protocol
//ref to presenter

protocol TranDetInteractorProtocol {
    var presenter: TranDetPresenterProtocol? { get set }
    func createBubble(with name: String, value: String) -> UIView
}

class TranDetInteractor: TranDetInteractorProtocol {
    var presenter: TranDetPresenterProtocol?
    func createBubble(with name: String, value: String) -> UIView {
        if name == "COMMENT" && value == "" {
            // return the view
            return UIView()
        }
        // create a view that will act as the bubble
        @UsesAutoLayout
        var bubble = UIView()
        bubble.backgroundColor = .white
        bubble.layer.cornerRadius = 20
        if name != "COMMENT" {
            bubble.heightAnchor.constraint(equalToConstant: 50).activate()
        } else {
            bubble.heightAnchor.constraint(equalToConstant: 200).activate()
        }

        // create a label for the name
        @UsesAutoLayout
        var nameLabel = UILabel()
        nameLabel.text = name
        nameLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        
        // create a label for the value
        @UsesAutoLayout
        var valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = UIFont.systemFont(ofSize: 14)
        if name == "COMMENT" {
            valueLabel.lineBreakMode = .byWordWrapping
            print(bubble.bounds.width)
            valueLabel.widthAnchor.constraint(equalToConstant: (presenter!.view! as! UIViewController).view.bounds.width - 50).activate()
            valueLabel.numberOfLines = 10
            valueLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
            valueLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        } else if value == "" {
            valueLabel.text = "Not specified"
        }
        
        // add the labels to the view hierarchy
        bubble.addSubview(nameLabel)
        bubble.addSubview(valueLabel)
        
        // set up constraints for the labels
        nameLabel.leadingAnchor.constraint(equalTo: bubble.leadingAnchor, constant: 15).activate()
        nameLabel.topAnchor.constraint(equalTo: bubble.topAnchor, constant: 10).activate()
        
        valueLabel.leadingAnchor.constraint(equalTo: bubble.leadingAnchor, constant: 15).activate()
        valueLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).activate()

        // return the view
        return bubble
    }
}

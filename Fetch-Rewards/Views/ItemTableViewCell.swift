//
//  ItemTableViewCell.swift
//  Fetch-Rewards
//
//  Created by Ranjith Gampa on 11/17/20.
//

import Foundation
import UIKit

class ItemTableViewCell: UITableViewCell {
    static var reuseIdentifier = "ItemTableViewCell"
    
    var model: Model? {
        didSet {
            applyModel()
        }
    }
    
    struct Model {
        var name: String
    }
    
    private func applyModel() {
        guard let model = model else { return }
        
        textLabel?.text = model.name
    }
}

extension ItemTableViewCell {
    override var reuseIdentifier: String? {
        return "com.rg.\(String(describing: self))"
    }
}

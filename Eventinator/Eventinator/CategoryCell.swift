//
//  CategoryCell.swift
//  Lineup
//
//  Created by Jon O'Keefe on 11/13/16.
//  Copyright © 2016 Eventinator. All rights reserved.
//

import UIKit

protocol CategoryCellDelegate {

    func categoryCell(didSelect categoryCell: CategoryCell, category: Category)
}

class CategoryCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var addImageView: UIImageView!
    
    var category: Category! {
        didSet {
            categoryNameLabel.text = category.name
        }
    }
    
    var isUserCategory: Bool {
        didSet {
            if isUserCategory {
                addImageView.isHidden = true
                backgroundColor = UIColor(red: CGFloat(240/255.0), green: CGFloat(89/255.0), blue: CGFloat(42/255.0), alpha: CGFloat(0.75))
                categoryNameLabel.textColor = UIColor.white
            } else {
                addImageView.isHidden = false
                backgroundColor = UIColor(red: CGFloat(238/255.0), green: CGFloat(238/255.0), blue: CGFloat(238/255.0), alpha: CGFloat(0.75))
                categoryNameLabel.textColor = UIColor.black
                addImageView.image = addImageView.image!.withRenderingMode(.alwaysTemplate)
                addImageView.tintColor = UIColor.black
            }
        }
    }
    
    var delegate: CategoryCellDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        isUserCategory = false
        super.init(coder: aDecoder)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        addGestureRecognizer(tapGesture)
    }
    
    func onTap(sender: UITapGestureRecognizer) {
        isUserCategory = !isUserCategory
        delegate?.categoryCell(didSelect: self, category: category)
    }
    
    
    
}

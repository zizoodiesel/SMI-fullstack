//
//  ArticleCollectioniewCell.swift
//  SMI
//
//  Created by Zizoo diesel on 30/11/2022.
//

import Foundation

import UIKit

class ArticleCollectioniewCell: UICollectionViewCell {

//    @IBOutlet private weak var titleLabel: UILabel!
//    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet weak var cellImageView: UIImageView?
//    @IBOutlet weak var cellImageViewHeightConstraint: NSLayoutConstraint?
    var animationGroup: CAAnimationGroup?
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//
//        self.layoutIfNeeded()
//    }
    
//    var title: String? {
//        
//        set {
//
//            titleLabel.text = newValue
//        }
//        get {
//            return titleLabel.text ?? ""
//        }
//    }
//    
//    var subTitle: String? {
//
//        set {
//
//            descriptionLabel.text = newValue ?? "(No description)"
//        }
//        get {
//            return descriptionLabel.text ?? ""
//        }
//    }

    var cellImage: UIImage? {

        set {
            
            cellImageView?.image = newValue
            cellImageView?.contentMode = UIView.ContentMode.scaleAspectFit
            
            if newValue != nil {
                cellImageView?.layer.removeAnimation(forKey: "fadeAnimation")
                cellImageView?.backgroundColor = UIColor.clear
            }
            else {
                
                let fromAnim : CABasicAnimation = CABasicAnimation.init(keyPath: "opacity")
                fromAnim.fromValue = 0.2
                fromAnim.toValue = 1.2


                
                animationGroup = CAAnimationGroup()
                animationGroup!.duration = 0.6
                animationGroup!.repeatCount = .infinity
                animationGroup!.autoreverses = true
                animationGroup!.isRemovedOnCompletion = false

                animationGroup!.animations = [fromAnim]
                

                cellImageView?.layer.add(animationGroup!, forKey: "fadeAnimation")
                
                cellImageView?.backgroundColor = UIColor.systemGray4
            }
            
            
        }
        get {
            return cellImageView?.image
        }
    }

}

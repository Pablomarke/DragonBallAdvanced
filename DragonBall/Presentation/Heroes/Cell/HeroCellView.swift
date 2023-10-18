//
//  HeroCellView.swift
//  DragonBall
//
//  Created by Pablo Márquez Marín on 16/10/23.
//

import UIKit

class HeroCellView: UITableViewCell {
    static let identifier: String = "HeroCellView"
    static let estimatedHeight: CGFloat = 256
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var heroDescription: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        name.text = nil
        photo.image = nil
        heroDescription.text = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.cornerRadius = 8
        containerView.layer.shadowColor = UIColor.gray.cgColor
        containerView.layer.shadowOffset = .zero
        containerView.layer.shadowRadius = 8
        containerView.layer.shadowOpacity = 0.6
        
        selectionStyle = .none
    }
    
    func updateView(
        name: String? = nil,
        photo: String? = nil,
        description: String? = nil
    ) {
        self.name.text = name
        self.heroDescription.text = description
        
        //TODO: imagen
    }
}

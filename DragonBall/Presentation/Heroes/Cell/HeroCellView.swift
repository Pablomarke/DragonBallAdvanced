//
//  HeroCellView.swift
//  DragonBall
//
//  Created by Pablo Márquez Marín on 16/10/23.
//

import UIKit

class HeroCellView: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var heroDescription: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        name.text = nil
        photo.image = nil
        heroDescription.text = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func updateView() {
        
    }
}

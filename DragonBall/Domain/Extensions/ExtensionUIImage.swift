//
//  ExtensionUIImage.swift
//  DragonBall
//
//  Created by Pablo Márquez Marín on 28/10/23.
//

import UIKit

extension UIImageView {
    //Función para hacer redonda la imagen
    func makeRounded(image: UIImageView) {
        image.layer.borderWidth = 1
        image.layer.borderColor = UIColor.white.cgColor.copy(alpha: 0.6)
        image.layer.cornerRadius = image.frame.height / 2
        image.layer.masksToBounds = false
        image.clipsToBounds = true
    }
}

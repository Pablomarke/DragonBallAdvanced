//
//  MapHeroesController.swift
//  DragonBall
//
//  Created by Pablo Márquez Marín on 22/10/23.
//

import UIKit
import MapKit

protocol MapHeroesControllerDelegate {
    func onViewappear()
}


class MapHeroesController: UIViewController {
    
    @IBOutlet weak var heroesMap: MKMapView!
    
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false,
                                                     animated: animated)
        navigationController?.navigationBar.tintColor = .orange
        navigationItem.title = "Mapa Heroes"
        

    }
}

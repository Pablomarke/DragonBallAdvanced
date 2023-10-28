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
    var viewState: ((MapViewState) -> Void)? { get set }
}

enum MapViewState {
    case updateMap(locations: [HeroAnnotation])
    case loading(_ isLoading: Bool)
}

class MapHeroesController: UIViewController {
    
    var viewModel: MapHeroesControllerDelegate?
    
    @IBOutlet weak var heroesMap: MKMapView!
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        setObservers()
        viewModel?.onViewappear()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false,
                                                     animated: animated)
        navigationController?.navigationBar.tintColor = .orange
        navigationItem.title = "Mapa Heroes"
    }
    
    private func initViews() {
        heroesMap.delegate = self
    }
    
    private func setObservers() {
        viewModel?.viewState = { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                    case .updateMap(let mapHeroLocations):
                        self?.updateMap(mapHeroLocations: mapHeroLocations )
                        
                    case .loading(_):
                        //TODO
                        break
                }
            }
        }
    }
    
    private func updateMap(mapHeroLocations: [HeroAnnotation]) {
        mapHeroLocations.forEach { heroesMap.addAnnotation($0)
        }
    }
}

extension MapHeroesController: MKMapViewDelegate {
    
}

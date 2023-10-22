//
//  HeroDetailViewController.swift
//  DragonBall
//
//  Created by Pablo Márquez Marín on 19/10/23.
//

import UIKit
import Kingfisher
import MapKit

protocol HeroesDetailViewControllerDelegate {
    var viewState: ((HeroDetailViewState) -> Void)? {get set}
    //func heroDetailViewModel(index: Int) -> HeroesDetailViewControllerDelegate?
    func onViewAppear()
}

enum HeroDetailViewState {
    case loading(_ isLoading: Bool)
    case update(hero: Hero?, locations: HeroLocations)
}

class HeroDetailViewController: UIViewController {
    
    var viewModel: HeroesDetailViewControllerDelegate?
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var heroDescription: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        setObservers()
        viewModel?.onViewAppear()
    }
    
    private func initViews() {
        mapView.delegate = self
    }
    
    private func setObservers(){
        viewModel?.viewState = { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                    case .loading(let isLoading):
                        break
                        
                    case .update(let hero, let heroLocations):
                        self?.updateViews(hero: hero,
                                          heroLocations: heroLocations)
                }
            }
        }
    }
    private func updateViews(hero: Hero?, heroLocations: HeroLocations) {
        photoView.kf.setImage(with: URL(string: hero?.photo ?? ""))
        makeRounded(image: photoView)
        nameLabel.text = hero?.name
        heroDescription.text = hero?.description
        
        heroLocations.forEach {
            mapView.addAnnotation(
                HeroAnnotation(
                title: hero?.name,
                info: hero?.id,
                coordinate: .init(
                    latitude: Double($0.latitude ?? "") ?? 0.0,
                    longitude: Double($0.longitude ?? "") ?? 0.0)
                )
            )
        }
    }
    
    private func makeRounded(image: UIImageView) {
        image.layer.borderWidth = 1
        image.layer.borderColor = UIColor.white.cgColor.copy(alpha: 0.6)
        image.layer.cornerRadius = image.frame.height / 2
        image.layer.masksToBounds = false
        image.clipsToBounds = true
    }
}
extension HeroDetailViewController: MKMapViewDelegate{
    // aqui en vez de una chincheta podemos poner otra cosa
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return nil
    }
}

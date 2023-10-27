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
    func onViewAppear()
}

enum HeroDetailViewState {
    case loading(_ isLoading: Bool)
    case update(hero: HeroDAO?, locations: [LocationDAO])
}

class HeroDetailViewController: UIViewController {
    
    var viewModel: HeroesDetailViewControllerDelegate?
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var heroDescription: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
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
                        
                    case .update(let heroDAO, let heroLocations):
                        self?.updateViews(hero: heroDAO,
                                          heroLocations: heroLocations)
                }
            }
        }
    }
    
    private func updateViews(hero: HeroDAO?, heroLocations: [LocationDAO]) {
        photoView.kf.setImage(with: URL(string: hero?.photo ?? ""))
        makeRounded(image: photoView)

        nameLabel.text = hero?.name
        heroDescription.text = hero?.heroDescription
        
        for onelocation in heroLocations {
            if onelocation.hero?.id == hero?.id {
                let annotation = HeroAnnotation(
                    title: hero?.name,
                    info: hero?.id, 
                    coordinate: .init(
                        latitude: Double(onelocation.latitude ?? "") ?? 0.0,
                        longitude: Double(onelocation.longitude ?? "") ?? 0.0))
                mapView.addAnnotation(annotation)
            }
        }
    }
    
    // TODO: sacarlo a una extension
    private func makeRounded(image: UIImageView) {
        image.layer.borderWidth = 1
        image.layer.borderColor = UIColor.white.cgColor.copy(alpha: 0.6)
        image.layer.cornerRadius = image.frame.height / 2
        image.layer.masksToBounds = false
        image.clipsToBounds = true
    }
}
//MARK: — MKMapView Delegate Methods
extension HeroDetailViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return nil
    }
}

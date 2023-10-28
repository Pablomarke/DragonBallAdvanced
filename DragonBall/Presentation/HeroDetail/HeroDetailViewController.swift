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

// Mark: - View State -
enum HeroDetailViewState {
    case loading(_ isLoading: Bool)
    case update(hero: HeroDAO?, locations: [HeroAnnotation])
}

class HeroDetailViewController: UIViewController {
    
    // MARK: - IBOutlet -
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var heroDescription: UITextView!
    @IBOutlet weak var detailLoadView: UIView!
    @IBOutlet weak var labelLoadView: UILabel!
    
    // MARK - Public properties -
    var viewModel: HeroesDetailViewControllerDelegate?
    
    // MARK: - lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        viewModel?.onViewAppear()
        initViews()
        setObservers()
        
    }
    
    // MARK: - Private Functions -
    private func initViews() {
        mapView.delegate = self
        
    }
    
    private func setObservers(){
        viewModel?.viewState = { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                    case .loading(let isLoading):
                        self?.labelLoadView.text = "Buscando a..."
                        self?.detailLoadView.isHidden = !isLoading
                        
                    case .update(let heroDAO, let heroLocations):
                        self?.updateViews(hero: heroDAO,
                                          heroLocations: heroLocations)
                }
            }
        }
    }
    
    private func updateViews(hero: HeroDAO?, heroLocations: [HeroAnnotation]) {
        photoView.kf.setImage(with: URL(string: hero?.photo ?? ""))
        photoView.makeRounded(image: self.photoView)

        nameLabel.text = hero?.name
        heroDescription.text = hero?.heroDescription
        heroLocations.forEach { mapView.addAnnotation($0)
            
        }
    }
}
//MARK: — MKMapView Delegate Methods
extension HeroDetailViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return nil
    }
}

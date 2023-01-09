//
//  TranDetView.swift
//  Cash Stash
//
//  Created by Dmitriy on 1/7/23.
//

import UIKit
import MapKit

//view controller
//protocol
//ref to presenter

//MARK: - TranDetView
protocol TranDetViewProtocol {
    var presenter: TranDetPresenterProtocol? { get set }
    var tranDetEntity: TranDetEntity { get set }
    var completion: (() -> Void)? { get set }
    var deletion: (() -> Void)? { get set }
}

class TranDetView: UIViewController, TranDetViewProtocol, MKMapViewDelegate {
    var presenter: TranDetPresenterProtocol?
    
    @UsesAutoLayout
    var stackView = UIStackView()
    @UsesAutoLayout
    var editButton = UIButton()
    @UsesAutoLayout
    var closeButton = UIButton()
    @UsesAutoLayout
    var mapView = MKMapView()

    var tranDetEntity: TranDetEntity
    var completion: (() -> Void)?
    var deletion: (() -> Void)?
    
    init(tranDetEntity: TranDetEntity) {
        self.tranDetEntity = tranDetEntity
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createGradientBackground()
        configureEditButton()
        configureCloseButton()
        stackView = UIStackView(arrangedSubviews: presenter!.getBubbles())
        configureStackView()
        if let coordinates = tranDetEntity.coordinates {
            configureMapView(with: coordinates)
        }
//        configureMapView(with: CLLocationCoordinate2D(latitude: 37.334722, longitude: -122.008889))

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        completion!()
    }
    
    func createGradientBackground() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor(red: 103/255, green: 97/255, blue: 244/255, alpha: 1).cgColor, UIColor(red: 58/255, green: 237/255, blue: 237/255, alpha: 1).cgColor, UIColor(red: 237/255, green: 93/255, blue: 240/255, alpha: 1).cgColor]
        gradient.locations = [0, 0.4, 1]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        gradient.frame = view.bounds
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    @objc func editButtonTapped() {
        presenter?.goToEditView()
    }
    
    @objc func closeButtonTapped() {
        DispatchQueue.main.async {
            self.dismiss(animated: true)
        }
    }
    
    func configureEditButton() {
        if tranDetEntity.fromZen {
            editButton.isHidden = true
        }
        editButton.setTitle(" Edit", for: .normal)
        editButton.setImage(UIImage(named: "square.and.pencil"), for: .normal)
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        view.addSubview(editButton)
        editButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5).activate()
        editButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).activate()
    }
    
    func configureCloseButton() {
        closeButton.setTitle("Close", for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        view.addSubview(closeButton)
        closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5).activate()
        closeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).activate()
    }
    
    func configureStackView() {
        stackView.axis = .vertical
        stackView.spacing = 8
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            stackView.topAnchor.constraint(equalTo: editButton.bottomAnchor, constant: 15),
        ])
    }
    
    func configureMapView(with coordinates: CLLocationCoordinate2D) {
        mapView.delegate = self
        mapView.layer.cornerRadius = 15
        view.addSubview(mapView)
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).activate()
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).activate()
        mapView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 30).activate()
        mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).activate()
        let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
        // Add an annotation to the map
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        annotation.title = tranDetEntity.title
        mapView.addAnnotation(annotation)
    }
}

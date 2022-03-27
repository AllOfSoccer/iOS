//
//  GameMatchingDetailViewController.swift
//  AllOfSoccer
//
//  Created by 최원석 on 2021/08/15.
//

import UIKit
import NMapsMap

class GameMatchingDetailViewController: UIViewController {

    @IBOutlet private weak var naverMapView: NMFNaverMapView!

    private var infoWindow = NMFInfoWindow()
    private var defaultInfoWindowImage = NMFInfoWindowDefaultTextSource.data()

    private var viewModel: [String] = []
    private let testModel: GameMatchingDetailModel = GameMatchingDetailModel(latitude: 37.56113305647401, hardness: 126.99471726933801, positionName: "춤무로")

    lazy var likeBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(named: "HeartDeSeleded"), style: .plain, target: self, action: #selector(likeBarbuttonTouchUp(_:)))
        button.tintColor = .clear
        return button
    }()

    lazy var shareBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(named: "ShareNetwork"), style: .plain, target: self, action: #selector(shareBarButtonTouchup(_:)))
        button.tintColor = .black
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationItem()
        setNaverMapView()
    }

    private func setupNavigationItem() {
        self.navigationItem.title = "팀 모집"
        self.navigationController?.navigationBar.titleTextAttributes =
        [NSAttributedString.Key.foregroundColor: UIColor.black,
         NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .semibold)]
        self.navigationController?.navigationBar.topItem?.title = ""

        self.navigationItem.rightBarButtonItems = [self.likeBarButton, self.shareBarButton]
    }

    private func setNaverMapView() {

        self.naverMapView.mapView.touchDelegate = self

        self.setCamera()
        self.setInfoWindow()
        self.setMarker()
    }

    private func setCamera() {

        let camPoition = NMGLatLng(lat: self.testModel.latitude, lng: self.testModel.hardness)
        let cameraUpdate = NMFCameraUpdate(scrollTo: camPoition)
        self.naverMapView.mapView.moveCamera(cameraUpdate)
    }

    private func setInfoWindow() {

        self.infoWindow.dataSource = defaultInfoWindowImage
        self.infoWindow.mapView = self.naverMapView.mapView
    }

    private func setMarker() {

        let marker = NMFMarker()
        marker.position = NMGLatLng(lat: self.testModel.latitude, lng: self.testModel.hardness)
        marker.iconImage = NMF_MARKER_IMAGE_BLACK
        marker.iconTintColor = UIColor.red
        marker.width = 50
        marker.height = 60

        marker.touchHandler = { [weak self] (overlay: NMFOverlay) -> Bool in
            self?.infoWindow.close()
            self?.defaultInfoWindowImage.title = marker.userInfo["tag"] as! String
            self?.infoWindow.open(with: marker)
            return true
        }

        marker.userInfo = ["tag" : self.testModel.positionName]
        marker.mapView = self.naverMapView.mapView
    }

    @objc private func likeBarbuttonTouchUp(_ sender: UIControl) {
        print("likeBarButton이 찍혔습니다.")

        sender.isSelected.toggle()
        if sender.isSelected {
            self.likeBarButton.image = UIImage(named: "HeartSelected")
        } else {
            self.likeBarButton.image = UIImage(named: "HeartDeSeleded")
        }
    }

    @objc private func shareBarButtonTouchup(_ sender: UIBarButtonItem) {
        print("shareBarButton이 찍혔습니다.")

        for testString in 0...3 {
            self.viewModel.append(String(testString))
        }

        let activityViewController = UIActivityViewController(activityItems: self.viewModel, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
}


extension GameMatchingDetailViewController: NMFMapViewTouchDelegate {

    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        infoWindow.close()
    }
}

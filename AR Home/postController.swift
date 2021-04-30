//
//  postController.swift
//  Post Houses
//
//  Created by Farah on 2/25/21.
//

import UIKit
import MapKit
import CoreLocation



class postController: UIViewController, UINavigationControllerDelegate, MKMapViewDelegate, CLLocationManagerDelegate, UIImagePickerControllerDelegate {
    
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
       
        //
        self.hideKeyboardWhenTappedAround()
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
//
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(mapViewTapped))
        houseLocation?.addGestureRecognizer(tapGesture)
        
    }
    @objc func mapViewTapped(gestureRecognizer: UIGestureRecognizer) {
        let touchPoint = gestureRecognizer.location(in: houseLocation)
        let coordinate = houseLocation.convert(touchPoint, toCoordinateFrom: houseLocation)
        
        addPin(at: coordinate)
    }
    
    func addPin(at coordinate: CLLocationCoordinate2D) {
        let newAnnotation = MKPointAnnotation()
        let allAnnotations = houseLocation.annotations
        houseLocation.removeAnnotations(allAnnotations)
        newAnnotation.coordinate = coordinate
        print("locations = \(coordinate.latitude) \(coordinate.longitude)")
        houseLocation.addAnnotation(newAnnotation)
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
//        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = locValue
//            houseLocation.addAnnotation(annotation)
        
        
        
//        annotation.title = "Your Location"
//        let coordinateRegion = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
//        houseLocation.setRegion(coordinateRegion, animated: false)
        
        
    }
    
    
    
    @IBOutlet weak var imageView: UIImageView!
    
        @IBAction func didTapButton(){
            
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            
            let actionSheet = UIAlertController(title: "Photo Source",  message: "Choose a source", preferredStyle: .actionSheet)
            
            actionSheet.addAction( UIAlertAction(title: "Camera", style: .default, handler:  { (action:UIAlertAction) in
                
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    imagePickerController.sourceType = .camera
                    self.present(imagePickerController, animated: true, completion: nil)
                }
                else {
                    print("Camera not available")
                }
            }))
            actionSheet.addAction( UIAlertAction(title: "Photo Library", style: .default, handler:  {(action:UIAlertAction) in imagePickerController.sourceType = .photoLibrary
                self.present(imagePickerController, animated: true, completion: nil)
            }))
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(actionSheet, animated: true, completion: nil)

        }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        imageView.image = image
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    
    @IBOutlet weak var contactName: UITextField!
    @IBOutlet weak var contactNumber: UITextField!
    @IBOutlet weak var contactEmail: UITextField!
    @IBOutlet weak var houseName: UITextField!
    @IBOutlet weak var houseDesc: UITextView!
    @IBOutlet weak var houseLocation: MKMapView!
    
    @IBAction func postHouse(_ sender: Any) {
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
//                present(ViewController(), animated: true, completion: nil)

        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The postController is not inside a navigation controller.")
        }
    }
    
}

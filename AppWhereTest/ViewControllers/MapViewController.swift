//
//  MapViewController.swift
//  AppWhereTest
//
//  Created by Yoshi Revelo on 4/14/19.
//  Copyright © 2019 Yoshi Revelo. All rights reserved.
//

import UIKit
import Alamofire
import GoogleMaps

class MapViewController: UIViewController {
    
    
    private var places : [Merchant] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GMSServices.provideAPIKey(Constants.API.apiKey)

        loadPlaces()
        // Do any additional setup after loading the view.
    }

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    //MARK: -Private Methods
    func loadPlaces(){
        Alamofire.request(Constants.API.placesStr)
            .validate()
            .responseData { (response) in
                switch response.result{
                case .success(let value):
                    print("Data: \(value)")
                    
                    do {
                        
                        let merchantsResponse = try JSONDecoder().decode(MerchantsResponseModel.self, from: value)
                        
                        let camera = GMSCameraPosition.camera(withLatitude: 19.377778, longitude: -99.177611, zoom: 16)
                        self.places = merchantsResponse.merchants
                        
                        print(self.places)
                        
                        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
                        self.view = mapView
                        
                        for place in self.places{
                            let marker = GMSMarker()
                            marker.position = CLLocationCoordinate2DMake(place.latitude, place.longitude)
                            marker.title = place.merchantName
                            marker.snippet = place.merchantAddress
                            marker.icon = UIImage(imageLiteralResourceName: "pointer.png")
                            marker.map = mapView
                        }                        
                    }catch let error{
                        print("Codable Places Error \(error.localizedDescription)")
                    }
                    
                case .failure(let error):
                    print("Request Error: \(error.localizedDescription)")
                }
                
        }
    }
    
    //MARK: - User interaction
    
    @IBAction func logOutButtonPressed(_ sender: Any) {
        let logOutAlertController = UIAlertController(title: "Cerrar Sesión", message: "Está seguro de cerrar sesión", preferredStyle: .actionSheet)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { (_) in
            UserDefaults.standard.removeObject(forKey: "user")
            UserDefaults.standard.synchronize()
            
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            
            let delegate = UIApplication.shared.delegate as! AppDelegate
            delegate.window?.rootViewController = loginViewController
            
            delegate.rememberLogin()
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .destructive, handler: nil)
        
        logOutAlertController.addAction(okAction)
        logOutAlertController.addAction(cancelAction)
        
        present(logOutAlertController, animated: true, completion: nil)
    }
}

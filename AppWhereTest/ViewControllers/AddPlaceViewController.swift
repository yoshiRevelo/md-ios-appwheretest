//
//  AddPlaceViewController.swift
//  AppWhereTest
//
//  Created by Yoshi Revelo on 4/14/19.
//  Copyright © 2019 Yoshi Revelo. All rights reserved.
//

import UIKit
import Alamofire

class AddPlaceViewController: UIViewController {

    //MARK: - Outlets
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var addressTextField: UITextField!
    
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var latitudeTextField: UITextField!
    
    @IBOutlet weak var longitudeTextField: UITextField!
    
    
    private var currentTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentTextField?.resignFirstResponder()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - User interaction
    @IBAction func continueButtonPressed(_ sender: Any) {
        
        if nameTextField.text == "" || addressTextField.text == "" || phoneTextField.text == "" || latitudeTextField.text == "" || longitudeTextField.text == "" {
            let ErrorAlertController = UIAlertController(title: "Campos Vacíos", message: "Uno o más campos están vacios, ingresa los campos faltantes.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            ErrorAlertController.addAction(okAction)
            
            present(ErrorAlertController, animated: true, completion: nil)
        }else{
            guard let _ = Double(latitudeTextField.text!) else{
                print("Error")
                return
            }
            guard let _ = Double(longitudeTextField.text!) else{
                print("Error")
                return
            }
            
            addPlace()
        }
    }
    
    
    //MARK: - Private Methods
    @objc private func keyBoardWillShow(notification: Notification){
        //print("keyBoardWillShow")
    }
    
    @objc private func keyBoardWillHide(notification: Notification){
        //print("keyBoardWillHide")
    }
    
    private func addPlace(){
        let params: [String:Any] = [
            "latitude" : Double(latitudeTextField.text!)!,
            "longitude" : Double(longitudeTextField.text!)!,
            "merchantAddress": addressTextField.text!,
            "merchantName": nameTextField.text!,
            "merchantTelephone": phoneTextField.text!
        ]
        
        
        Alamofire.request(Constants.API.registerStr, method: .post, parameters: params, encoding: JSONEncoding.default)
        .validate()
            .responseData { (response) in
                switch response.result{
                case .success:
                    self.tabBarController?.selectedIndex = 1
                    self.nameTextField.text = ""
                    self.addressTextField.text = ""
                    self.phoneTextField.text = ""
                    self.latitudeTextField.text = ""
                    self.longitudeTextField.text = ""
                    
                case .failure(let error):
                    
                    let ErrorAlertController = UIAlertController(title: "Error", message: "No se ha podido añadir, por favor intenta más tarde.", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    
                    ErrorAlertController.addAction(okAction)
                    
                    self.present(ErrorAlertController, animated: true, completion: nil)
                    
                    
                    print("response Post failure \(error.localizedDescription)")
                }
        }
    }
}

extension AddPlaceViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameTextField:
            addressTextField.becomeFirstResponder()
        case addressTextField:
            phoneTextField.becomeFirstResponder()
        case phoneTextField:
            latitudeTextField.becomeFirstResponder()
        case latitudeTextField:
            longitudeTextField.becomeFirstResponder()
        case longitudeTextField:
            currentTextField?.resignFirstResponder()
        default:
            break
        }
        
        return true
    }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            currentTextField = textField
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            currentTextField = nil
        }
}

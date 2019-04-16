//
//  LoginViewController.swift
//  AppWhereTest
//
//  Created by Yoshi Revelo on 4/14/19.
//  Copyright © 2019 Yoshi Revelo. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBOutlet weak var continueTopConstraint: NSLayoutConstraint!
    
    private var currentTextField: UITextField?
    
    private var user: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
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
        logIn()
    }
    
    //MARK: - Private Methods
    private func logIn(){
        
        if emailTextField.text == "" || passwordTextField.text == "" {
            let ErrorAlertController = UIAlertController(title: "Campos Vacíos", message: "Uno o más campos están vacios, ingresa el usuario o contraseña", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            ErrorAlertController.addAction(okAction)
            
            present(ErrorAlertController, animated: true, completion: nil)
        }else{
            let params = [
                "email" : emailTextField.text!,
                "password" : passwordTextField.text!
            ]
            
            Alamofire.request(Constants.API.logInStr, parameters: params)
                .validate()
                .responseData { (response) in
                    //print(response.data)
                    switch response.result{
                    case .success(let value):
                        //print("Data: \(value)")
                        do{
                            let logInResponse = try JSONDecoder().decode(LoginResponseModel.self, from: value)
                            
                            
                            if logInResponse.successful{
                                self.toMapsTabBarController()
                            }else{
                                let ErrorAlertController = UIAlertController(title: "Error de Sesión", message: "El usuario no existe o algún dato fue mal escrito", preferredStyle: .alert)
                                
                                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                
                                ErrorAlertController.addAction(okAction)
                                
                                self.present(ErrorAlertController, animated: true, completion: nil)
                            }
                            
                        }catch let error{
                            print("Codable logInError \(error.localizedDescription)")
                        }
                        
                    case .failure(let error):
                        print ("Request error: \(error.localizedDescription)")
                    }
            }
        }
    }
    
    private func toMapsTabBarController(){
        UserDefaults.standard.set(emailTextField.text!, forKey: "user")
        UserDefaults.standard.synchronize()
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.rememberLogin()
    }
    
    @objc private func keyBoardWillShow(notification: Notification){
        print("keyboard will show")
        let userInfo = notification.userInfo!
        print(userInfo)
        
        let keyBoardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        
        let keyBoardFrame = keyBoardSize.cgRectValue
        continueTopConstraint.constant = 10 + keyBoardFrame.height
        
        let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        UIView.animate(withDuration: animationDuration){
            self.view.layoutIfNeeded()
        }
        
    }
    
    @objc private func keyboardWillHide(notification: Notification){
        print("keyboardwillhide")
        let userInfo = notification.userInfo!
        continueTopConstraint.constant = 10
        
        let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        UIView.animate(withDuration: animationDuration){
            self.view.layoutIfNeeded()
        }
    }
}

extension LoginViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            currentTextField?.resignFirstResponder()
            logIn()
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

//
//  LSViewController.swift
//  MimoiOSCodingChallenge
//
//  Created by Erik Nascimento on 4/8/17.
//  Copyright © 2017 Mimohello GmbH. All rights reserved.
//

import UIKit

@objc class LSViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passField: UITextField!

    fileprivate let client = ApiClient(contentType: "application/json", customUrl: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnLogin(_ sender: Any) {
        if checkFields() {
            client.login(emailField.text!, password: passField.text!, completion: { (success, response) in
                if success == true{
                     userDefault = User(data: response!)
                     self.showSettings()
                }else{
                    var errorMessage:String?
                    if let error = response?["error_description"] {
                        errorMessage = error as? String
                    }else{
                        errorMessage = response?["error"] as? String
                    }
                    let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
    }

    @IBAction func btnSignUp(_ sender: Any) {
        if checkFields() {
            client.signUp(emailField.text!, password: passField.text!, completion: { (success, response) in
                if success == true{
                    userDefault = User(data: response!)
                    self.showSettings()
                }else{
                    var errorMessage:String?
                    if let error = response?["error_description"] {
                        errorMessage = error as? String
                    }else if let error = response?["error"] {
                        errorMessage = error as? String
                    }else if let error = response?["description"] {
                        errorMessage = error as? String
                    }
                    let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func checkFields()->Bool{
        if emailField.text == "" && passField.text == "" {
            let alert = UIAlertController(title: "Error", message: "Please, fill all fields.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }else{
            return true
        }
    }
    
    func showSettings(){
        let settingsVC = SettingsViewController()
        self.show(settingsVC, sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

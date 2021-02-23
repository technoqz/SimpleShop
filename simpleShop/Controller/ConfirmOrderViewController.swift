//
//  ConfirmOrderViewController.swift
//  simpleShop
//
//  Created by Sergey Ipatov on 20.02.2021.
//

import UIKit

class ConfirmOrderViewController: UIViewController  {

    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var adressLabel: UILabel!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var addressTextView: UITextView!
    @IBOutlet weak var commentTextField: UITextField!
    
    @IBOutlet weak var confirmButton: UIButton!
    
    var activeTextField : UITextField? = nil
    var activeTextView: UITextView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        self.hideKeyboardWhenTappedAround()
                
        // keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setupUI(){
        addressTextView.delegate = self
        phoneTextField.delegate = self
        commentTextField.delegate = self
        
        addressTextView.layer.borderWidth = 1
        addressTextView.layer.borderColor = UIColor.systemGray5.cgColor
        addressTextView.layer.cornerRadius = 5
        confirmButton.layer.cornerRadius = 25
        confirmButton.isEnabled = false

        phoneLabel.addRedAsterisk()
        adressLabel.addRedAsterisk()
        
        let backButton = UIBarButtonItem()
        backButton.title = "Назад"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.transparentNavigationBar()
    }
    
    // on confirm -> go to Main
    @IBAction func confirmPressed(_ sender: UIButton) {
        Cart.clearCart()

        performSegue(withIdentifier: "unwindToMain", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMap"{
            let vc = segue.destination as? MapViewController
            vc?.delegate = self
        }
    }
}

// MARK: Hide and show keyboard methods
extension ConfirmOrderViewController{
    @objc func keyboardWillHide(notification: NSNotification) {
        // move back the root view origin to zero
        self.view.frame.origin.y = 0
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            // if keyboard size is not available for some reason, dont do anything
            return
        }
        
        var shouldMoveViewUp = false
        
        
        // if active text field is not nil
        if activeTextField?.text != nil || activeTextView?.text != nil  {
            
            var bottomOfTextField: CGFloat = 0.0
            
            if let activeTextField = activeTextField{
                bottomOfTextField = activeTextField.convert(activeTextField.bounds, to: self.view).maxY;
            }else if let activeTextView = activeTextField{
                bottomOfTextField = activeTextView.convert(activeTextView.bounds, to: self.view).maxY;
            }
            
            let topOfKeyboard = self.view.frame.height - keyboardSize.height
            
            // if the bottom of Textfield is below the top of keyboard, move up
            if bottomOfTextField > topOfKeyboard {
                shouldMoveViewUp = true
            }
        }
        
        if(shouldMoveViewUp) {
            self.view.frame.origin.y = 0 - keyboardSize.height
        }
    }
}

// MARK: Text delegates && Validation
extension ConfirmOrderViewController: UITextViewDelegate, UITextFieldDelegate {
    
    // events for Keyboard action (hide or show)
    func textViewDidBeginEditing(_ textView: UITextView) {

        self.activeTextView = textView
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.activeTextView  = nil
    }
    
    // when user select a textfield, this method will be called
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    
    // when user click 'done' or dismiss the keyboard
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeTextField = nil
    }
    
    // Validating
    func validateFields(){
        if phoneTextField.text?.isEmpty ?? true || addressTextView.text?.isEmpty ?? true {
            confirmButton.isEnabled = false
        } else {
        
            let phoneStr = phoneTextField.text ?? ""
            let addressStr = addressTextView.text ?? ""

            if phoneStr.count > 10 && addressStr.count > 10 {

                confirmButton.isEnabled = true
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        validateFields()
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
         validateFields()
    }

}

// MARK: MapViewController Delegate
extension ConfirmOrderViewController: MapViewControllerDelegate{
    func fillAdress(address: String) {
        addressTextView.text = address
        validateFields()
    }
}

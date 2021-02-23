//
//  Alerts.swift
//  simpleShop
//
//  Created by Sergey Ipatov on 15.02.2021.
//

import UIKit

class Alert{
    static func show(vc:UIViewController, title: String, text: String){
        let alert = UIAlertController(title: title, message: text, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        DispatchQueue.main.async {
            vc.present(alert, animated: true, completion: nil)
        }
    }
    
    static func goToSettings(vc:UIViewController?){
        guard let safeVC = vc else { return }
        
        let alertController = UIAlertController (title: "Нет доступа к геолокации", message: "Для определения местоположения необходимо включить геолокацию для приложения. Перейти в настройки?", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Да", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return   }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: nil)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Нет", style: .default, handler: nil)
        
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        
        safeVC.present(alertController, animated: true, completion: nil)
        
    }
}

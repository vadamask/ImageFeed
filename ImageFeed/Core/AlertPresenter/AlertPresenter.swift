//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Вадим Шишков on 20.08.2023.
//

import UIKit

protocol AlertPresenterDelegate: AnyObject {
    func agreeAction()
    
}

extension AlertPresenterDelegate {
    func disagreeAction() {}
}

final class AlertPresenter {
    
    weak var delegate: AlertPresenterDelegate?
    
    func showAlert(with model: AlertModel, on vc: UIViewController) {
        let alertController = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert
        )
        
        let agreeAction = UIAlertAction(title: model.agreeButtonTitle, style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.agreeAction()
        }
        agreeAction.accessibilityIdentifier = "Ok"
        alertController.addAction(agreeAction)
        
        if let disagreeButtonTitle = model.disagreeButtonTitle {
            let disagreeAction = UIAlertAction(title: disagreeButtonTitle, style: .default) { [weak self] _ in
                guard let self = self else { return }
                self.delegate?.disagreeAction()
            }
            disagreeAction.accessibilityIdentifier = "No"
            alertController.addAction(disagreeAction)
        }
        alertController.view.accessibilityIdentifier = "Alert"
        vc.present(alertController, animated: true)
    }
}

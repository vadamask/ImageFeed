//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Вадим Шишков on 22.06.2023.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}

final class AuthViewController: UIViewController {
    
    @IBOutlet private var logoImageView: UIImageView!
    @IBOutlet private var button: UIButton!
    private let showWebViewSegueIdentifier = "ShowWebView"
    
    weak var delegate: AuthViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        navigationController?.navigationBar.barStyle = .black
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifier {
            guard let webViewVC = segue.destination as? WebViewViewController else {
                assertionFailure("Failed to prepare for \(showWebViewSegueIdentifier)")
                return
            }
            webViewVC.delegate = self
        }
    }
    
    private func setupViews() {
        view.backgroundColor = .ypBlack
        logoImageView.image = UIImage(named: "logo_of_unsplash")
        
        button.backgroundColor = .ypWhite
        button.layer.cornerRadius = 16
        button.setTitle("Войти", for: .normal)
        button.setTitleColor(.ypBlack, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
    }
    
    @IBAction private func buttonTapped() {
        
    }
}

//MARK: - WebViewViewControllerDelegate

extension AuthViewController: WebViewViewControllerDelegate {
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(self, didAuthenticateWithCode: code)
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}

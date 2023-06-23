//
//  File.swift
//  ImageFeed
//
//  Created by Вадим Шишков on 23.06.2023.
//

import Foundation

protocol WebViewViewControllerDelegate {
  func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
  func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

//
//  PaymentContainerView.swift
//  test_ottu
//
//  Created by Oleksandr Pylypenko on 02.01.2025.
//

import SwiftUI
import ottu_checkout_sdk

struct PaymentContainerView: UIViewControllerRepresentable {
    var formsOfPayment: [FormOfPayment]
    var showPaymentDetails: Bool
    var sessionId: String
    var merchantId: String
    var apiKey: String
    var transactionDetailsPreload: TransactionDetails?

    var onSuccess: ([String: Any]?) -> Void
    var onError: ([String: Any]?) -> Void
    var onCancel: ([String: Any]?) -> Void
    
    var onHeightChange: (CGFloat) -> Void

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        
        let paymentContainerView = ResizableContainerView()
        paymentContainerView.translatesAutoresizingMaskIntoConstraints = false
        paymentContainerView.backgroundColor = .clear
        paymentContainerView.sizeChangedCallback = { newSize in
                  DispatchQueue.main.async {
                      self.onHeightChange(newSize.height)
                  }
              }
        
        viewController.view.addSubview(paymentContainerView)
        viewController.view.backgroundColor = .clear
        
        
        NSLayoutConstraint.activate([
            paymentContainerView.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor),
            paymentContainerView.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor),
            paymentContainerView.topAnchor.constraint(equalTo: viewController.view.topAnchor)
        ])
        
        let checkout = Checkout(
            formsOfPayments: formsOfPayment,
            theme: CheckoutTheme(),
            sessionId: sessionId,
            merchantId: merchantId,
            apiKey: apiKey,
            setupPreload: transactionDetailsPreload,
            delegate: context.coordinator
        )
        
        if let paymentViewController = checkout.paymentViewController() {
            viewController.addChild(paymentViewController)
            paymentContainerView.addSubview(paymentViewController.view)
            paymentViewController.didMove(toParent: viewController)
            
            paymentViewController.view.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                paymentViewController.view.leadingAnchor.constraint(equalTo: paymentContainerView.leadingAnchor),
                paymentContainerView.trailingAnchor.constraint(equalTo: paymentViewController.view.trailingAnchor),
                paymentViewController.view.topAnchor.constraint(equalTo: paymentContainerView.topAnchor),
                paymentContainerView.bottomAnchor.constraint(equalTo: paymentViewController.view.bottomAnchor)
            ])
        }
        
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator(onSuccess: onSuccess, onError: onError, onCancel: onCancel)
    }
    
    class Coordinator: NSObject, OttuDelegate {
        var onSuccess: ([String: Any]?) -> Void
        var onError: ([String: Any]?) -> Void
        var onCancel: ([String: Any]?) -> Void

        init(onSuccess: @escaping ([String: Any]?) -> Void,
             onError: @escaping ([String: Any]?) -> Void,
             onCancel: @escaping ([String: Any]?) -> Void) {
            self.onSuccess = onSuccess
            self.onError = onError
            self.onCancel = onCancel
        }

        func successCallback(_ data: [String: Any]?) {
            DispatchQueue.main.async {
                self.onSuccess(data)
            }
        }

        func errorCallback(_ data: [String: Any]?) {
            DispatchQueue.main.async {
                self.onError(data)
            }
        }

        func cancelCallback(_ data: [String: Any]?) {
            DispatchQueue.main.async {
                self.onCancel(data)
            }
        }
    }
}

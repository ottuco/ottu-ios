//
//  OttuPaymentsViewController.swift
//  OttuApp
//
//  Created by Ottu on 12.04.2024.
//

import UIKit
import ottu_checkout_sdk

class OttuPaymentsViewController: UIViewController {
   
    var paymentContainerView = UIView()
    
    private var checkout: Checkout?
    
    var formsOfPayment = [ottu_checkout_sdk.FormOfPayment]()
    var showPaymentDetails: Bool = true
    var sessionId: String?
    var merchantId: String?
    var apiKey: String?
    var transactionDetailsPreload: TransactionDetails?
    
    var theme = CheckoutTheme()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange

        paymentContainerView.translatesAutoresizingMaskIntoConstraints = false
        paymentContainerView.clipsToBounds = true
        view.addSubview(paymentContainerView)
        
        NSLayoutConstraint.activate([
            paymentContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: paymentContainerView.trailingAnchor),
            paymentContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100)
        ])
      
        guard let sessionId, let merchantId, let apiKey else { return }
        
        theme.showPaymentDetails = showPaymentDetails
      
        self.checkout = Checkout(
            formsOfPayments: formsOfPayment,
            theme: theme,
            sessionId: sessionId,
            merchantId: merchantId,
            apiKey: apiKey,
            setupPreload: transactionDetailsPreload,
            delegate: self
        )
        
        if let paymentViewController = self.checkout?.paymentViewController(), let paymentView = paymentViewController.view {
            
            paymentView.translatesAutoresizingMaskIntoConstraints = false
            
            self.addChild(paymentViewController)
            self.paymentContainerView.addSubview(paymentView)
            paymentViewController.didMove(toParent: self)
            
            NSLayoutConstraint.activate([
                paymentContainerView.leadingAnchor.constraint(equalTo: paymentView.leadingAnchor),
                paymentView.trailingAnchor.constraint(equalTo: paymentContainerView.trailingAnchor),
                paymentContainerView.topAnchor.constraint(equalTo: paymentView.topAnchor),
                paymentView.bottomAnchor.constraint(equalTo: paymentContainerView.bottomAnchor),
            ])
        }
    }
}


extension OttuPaymentsViewController: OttuDelegate {
    func errorCallback(_ data: [String : Any]?) {
        DispatchQueue.main.async {
            self.paymentContainerView.isHidden = true
            
            let alert = UIAlertController(title: "Error", message: data?.debugDescription ?? "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alert, animated: true)
        }
    }
    
    func cancelCallback(_ data: [String : Any]?) {
        DispatchQueue.main.async {
            var message = ""
            
            if let paymentGatewayInfo = data?["payment_gateway_info"] as? [String : Any],
               let pgName = paymentGatewayInfo["pg_name"] as? String,
               pgName == "kpay" {
                message = paymentGatewayInfo["pg_response"].debugDescription
            } else {
                message = data?.debugDescription ?? ""
            }
            
            self.paymentContainerView.isHidden = true
            
            let alert = UIAlertController(title: "Canсel", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alert, animated: true)
        }
    }
    
    func successCallback(_ data: [String : Any]?) {
        DispatchQueue.main.async {
            self.replaceSDKContentToSuccessMessage()
            
            let alert = UIAlertController(title: "Success", message: data?.debugDescription ?? "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alert, animated: true)
        }
    }

    private func replaceSDKContentToSuccessMessage() {
        paymentContainerView.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
        
        let label = successLabel()
        paymentContainerView.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            paymentContainerView.leadingAnchor.constraint(equalTo: label.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: paymentContainerView.trailingAnchor),
            paymentContainerView.topAnchor.constraint(equalTo: label.topAnchor),
            label.bottomAnchor.constraint(equalTo: paymentContainerView.bottomAnchor),
            label.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func successLabel() -> UILabel {
        let message = NSLocalizedString("successfully", tableName: "Ottu", bundle: Bundle(for: Self.self), comment: "")
        
        let label = UILabel()
        label.text = message
        label.backgroundColor = .white
        label.textAlignment = .center
        
        return label
    }
}

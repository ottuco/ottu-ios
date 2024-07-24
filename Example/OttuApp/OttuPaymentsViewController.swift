//
//  OttuPaymentsViewController.swift
//  OttuApp
//
//  Created by Ottu on 12.04.2024.
//

import UIKit
import ottu_checkout_sdk

class OttuPaymentsViewController: UIViewController {
   
    @IBOutlet weak var paymentContainerView: UIView!
    
    @IBOutlet weak var paymentSuccessfullLabel: UILabel!
    private var checkout: Checkout?
    
    var formsOfPayment = [FormOfPayment]()
    var showPaymentDetails: Bool = true
    var sessionId: String?
    var merchantId: String?
    var apiKey: String?
    var transactionDetailsPreload: TransactionDetails?
    
    var theme = CheckoutTheme()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        
        paymentSuccessfullLabel.isHidden = true
        
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
            
            self.addChild(paymentViewController)
            self.paymentContainerView.addSubview(paymentView)
            paymentViewController.didMove(toParent: self)
            
            paymentView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                paymentView.leadingAnchor.constraint(equalTo: self.paymentContainerView.leadingAnchor),
                self.paymentContainerView.trailingAnchor.constraint(equalTo: paymentView.trailingAnchor),
                paymentView.topAnchor.constraint(equalTo: self.paymentContainerView.topAnchor),
                self.paymentContainerView.bottomAnchor.constraint(equalTo: paymentView.bottomAnchor)
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
            self.paymentContainerView.isHidden = true
            self.paymentSuccessfullLabel.isHidden = false
            
            let alert = UIAlertController(title: "Success", message: data?.debugDescription ?? "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alert, animated: true)
        }
    }

}

//
//  OttuPaymentsViewController.swift
//  OttuApp
//
//  Created by Ottu on 12.04.2024.
//

import UIKit
import ottu_checkout_sdk

class OttuPaymentsViewController: UIViewController {
    
    private var checkout: Checkout?
    
    var formsOfPayment = [ottu_checkout_sdk.FormOfPayment]()
    var showPaymentDetails: Bool = true
    var sessionId: String?
    var merchantId: String?
    var apiKey: String?
    var transactionDetailsPreload: TransactionDetails?
    
    var theme = CheckoutTheme()
    var paymentOptionsDisplayMode = PaymentOptionsDisplaySettings
        .PaymentOptionsDisplayMode
        .bottomSheet
    var visibleItemsCount: UInt = 5
    var defaultSelectedPgCode: String?
    
    var scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let contentView = UIView()

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        let topLabel = UILabel()
        topLabel.text = "Some user UI elements"
        topLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(topLabel)
        
        NSLayoutConstraint.activate([
            topLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            topLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        
        
        guard let sessionId, let merchantId, let apiKey else { return }

        theme.showPaymentDetails = showPaymentDetails

        do {
            self.checkout = try Checkout(
                formsOfPayments: formsOfPayment,
                theme: theme,
                displaySettings: PaymentOptionsDisplaySettings(
                    mode: paymentOptionsDisplayMode,
                    visibleItemsCount: visibleItemsCount,
                    defaultSelectedPgCode: defaultSelectedPgCode
                ),
                sessionId: sessionId,
                merchantId: merchantId,
                apiKey: apiKey,
                setupPreload: transactionDetailsPreload,
                delegate: self
            )
        } catch let error as LocalizedError {
            showFailAlert(error)
            return
        } catch {
            print("Unexpected error: \(error)")
            return
        }

        if let paymentVC = self.checkout?.paymentViewController(),
           let paymentView = paymentVC.view {

            self.addChild(paymentVC)

            let resizableContainer = ResizableContainerView()
            resizableContainer.translatesAutoresizingMaskIntoConstraints = false
            resizableContainer.addSubview(paymentView)
            paymentVC.didMove(toParent: self)

            paymentView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                paymentView.topAnchor.constraint(equalTo: resizableContainer.topAnchor),
                paymentView.bottomAnchor.constraint(equalTo: resizableContainer.bottomAnchor),
                paymentView.leadingAnchor.constraint(equalTo: resizableContainer.leadingAnchor, constant: 16),
                paymentView.trailingAnchor.constraint(equalTo: resizableContainer.trailingAnchor, constant: -16)
            ])

            contentView.addSubview(resizableContainer)

            NSLayoutConstraint.activate([
                resizableContainer.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 16),
                resizableContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                resizableContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            ])

            resizableContainer.sizeChangedCallback = { [weak self] _ in
                guard let self else { return }
                updateScrollEnabled(for: scrollView)
            }
            
            
            let bottomLabel = UILabel()
            bottomLabel.text = "Some user UI elements"
            bottomLabel.translatesAutoresizingMaskIntoConstraints = false
            
            contentView.addSubview(bottomLabel)
            
            NSLayoutConstraint.activate([
                bottomLabel.topAnchor.constraint(equalTo: resizableContainer.bottomAnchor, constant: 16),
                bottomLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                bottomLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
            ])
        }
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateScrollEnabled(for: scrollView)
    }
    
    private func updateScrollEnabled(for scrollView: UIScrollView) {
        scrollView.layoutIfNeeded()
        
        let contentHeight = scrollView.contentSize.height
        let visibleHeight = scrollView.bounds.height

        let navigationBarHeight = navigationController?.navigationBar.frame.height ?? 0
        let statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0

        let adjustedVisibleHeight = visibleHeight - navigationBarHeight - statusBarHeight

        let shouldScroll = contentHeight > adjustedVisibleHeight
        scrollView.isScrollEnabled = shouldScroll
    }

    private func showFailAlert(_ error: any LocalizedError) {
        let title = NSLocalizedString(
            "Failed",
            tableName: "Localizable",
            bundle: Bundle(for: Self.self),
            comment: ""
        )
        let message = error.errorDescription ?? "Unknown error occurred."
        let ok = NSLocalizedString(
            "OK",
            tableName: "Localizable",
            bundle: Bundle(for: Self.self),
            comment: ""
        )
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: ok, style: .default))
        self.present(alert, animated: true)
    }
}


extension OttuPaymentsViewController: OttuDelegate {
    func errorCallback(_ data: [String : Any]?) {
        DispatchQueue.main.async {
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
            
            let alert = UIAlertController(title: "Canсel", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alert, animated: true)
        }
    }
      
    func successCallback(_ data: [String : Any]?) {
        DispatchQueue.main.async {
            
            let alert = UIAlertController(title: "Success", message: data?.debugDescription ?? "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alert, animated: true)
        }
    }

}

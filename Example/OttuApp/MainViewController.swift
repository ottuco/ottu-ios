//
//  ViewController.swift
//  OttuApp
//
//  Created by Ottu on 08.03.2024.
//

import UIKit
import ottu_checkout_sdk

class MainViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var ativityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var currencyCodeTextField: UITextField!
    @IBOutlet weak var customerIdTextField: UITextField!
    @IBOutlet weak var merchantIdTextField: UITextField!
    @IBOutlet weak var apiKeyTextField: UITextField!
    @IBOutlet weak var applePaySwitch: UISwitch!
    @IBOutlet weak var ottuPGSwitch: UISwitch!
    @IBOutlet weak var stcPaySwitch: UISwitch!
    @IBOutlet weak var redirectSwitch: UISwitch!
    @IBOutlet weak var tokenPaySwitch: UISwitch!
    @IBOutlet weak var noFormsOfPaymentSwitch: UISwitch!
    @IBOutlet weak var preloadSwitch: UISwitch!
    @IBOutlet weak var showPaymentDetailsSwitch: UISwitch!
    @IBOutlet weak var getSessionIdButton: UIButton!
    @IBOutlet weak var payButton: UIButton!
    
    private var sessionId: String?
    private var transactionDetailsPreload: TransactionDetails?
    
    var theme = CheckoutTheme()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    
    @IBAction private func didToggleSwith(_ sender: UISwitch) {
        if sender.tag == 0 {
                applePaySwitch.isOn = !sender.isOn
                ottuPGSwitch.isOn = !sender.isOn
                stcPaySwitch.isOn = !sender.isOn
                redirectSwitch.isOn = !sender.isOn
                tokenPaySwitch.isOn = !sender.isOn
        } else {
            if (applePaySwitch.isOn == true &&
                ottuPGSwitch.isOn == true &&
                stcPaySwitch.isOn == true &&
                redirectSwitch.isOn == true &&
                tokenPaySwitch.isOn == true) ||
                (applePaySwitch.isOn == false &&
                 ottuPGSwitch.isOn == false &&
                 stcPaySwitch.isOn == false &&
                 redirectSwitch.isOn == false &&
                 tokenPaySwitch.isOn == false) {
                noFormsOfPaymentSwitch.isOn = true
            } else {
                noFormsOfPaymentSwitch.isOn = false
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toThemeEditorSegue", let vc = segue.destination as? ThemeEditorViewController {
            vc.theme = theme
        }
        
        if let destinationViewController = segue.destination as? OttuPaymentsViewController {
            
            destinationViewController.theme = theme
            
            if let sessionId {
                var formOfPayments = [FormOfPayment]()
                if applePaySwitch.isOn {
                    formOfPayments.append(.applePay)
                }
                if ottuPGSwitch.isOn {
                    formOfPayments.append(.ottuPG)
                }
                if stcPaySwitch.isOn {
                    formOfPayments.append(.stcPay)
                }
                if redirectSwitch.isOn {
                    formOfPayments.append(.redirect)
                }
                if tokenPaySwitch.isOn {
                    formOfPayments.append(.tokenPay)
                }
                
                destinationViewController.sessionId = sessionId
                destinationViewController.formsOfPayment = formOfPayments
                destinationViewController.showPaymentDetails = showPaymentDetailsSwitch.isOn
                destinationViewController.merchantId = merchantIdTextField.text
                destinationViewController.apiKey = apiKeyTextField.text
                destinationViewController.transactionDetailsPreload = transactionDetailsPreload
            }
        }
    }
    
    
    @IBAction func didTapGetSessionId(_ sender: UIButton) {
        getSessionIdButton.isEnabled = false
        
        ativityIndicator.startAnimating()
        ativityIndicator.isHidden = false
        
        getSessionId { [weak self] sessionId in
            guard let self else { return }
            
            DispatchQueue.main.async {
                self.ativityIndicator.stopAnimating()
                self.ativityIndicator.isHidden = true
                
                self.getSessionIdButton.isEnabled = true
                
                if let sessionId {
                    self.sessionId = sessionId
                    self.payButton.isEnabled = true
                } else {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Error",
                                                      message: "Can't get SessionId. Try again.",
                                                      preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default))
                        self.present(alert, animated: true)
                    }
                }
            }
        }
    }
    
    
    @IBAction func didTapPayButton(_ sender: UIButton) {
        performSegue(withIdentifier: "toPaymentViewController", sender: self)
    }
    
    private func getSessionId(completion: @escaping (String?) -> Void) {
        guard let amount = amountTextField.text, amount != "",
              let currencyCode = currencyCodeTextField.text, currencyCode != "",
              let apyKey = apiKeyTextField.text, apyKey != ""
        else {
            getSessionIdButton.isEnabled = true
            
            ativityIndicator.stopAnimating()
            ativityIndicator.isHidden = true
            return
        }
        
        let merchantId = merchantIdTextField.text!
        let isNeededPreload = preloadSwitch.isOn
        
        let url = URL(string: "https://\(merchantId)/b/checkout/v1/pymt-txn/")!
        
        var json: [String: Any] = [
            "amount": amount,
            "currency_code": currencyCode,
            "pg_codes": ["mpgs-testing",
                         "ottu_pg_kwd_tkn",
                         "knet-staging",
                         "benefit",
                         "benefitpay",
                         "stc_pay",
                         "nbk-mpgs",
                         "apple-pay-test"],
            "type": "e_commerce",
            "include_sdk_setup_preload": "true"
          ]
        
        if let customerId = customerIdTextField.text, customerId != "" {
            json["customer_id"] = customerId
        }
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Api-Key \(apyKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let session = URLSession(configuration: .ephemeral)
        let task = session.dataTask(with: request) { [weak self] data, response, error in
            guard let self else { return }
            
            if let data, let json = try? JSONSerialization.jsonObject(with: data) as? Dictionary<String, Any> {
                if let sessionId = json["session_id"] as? String {
                    
                    if isNeededPreload {
                        if let preloadPayloadDict = json["sdk_setup_preload_payload"],
                           let jsonData = try? JSONSerialization.data(withJSONObject: preloadPayloadDict, options: []),
                           let decodedValues = try? JSONDecoder().decode(RemoteTransactionDetails.self, from: jsonData) {
                            
                            self.transactionDetailsPreload = try? decodedValues.transactionDetails
                        }
                    } else {
                        self.transactionDetailsPreload = nil
                    }
                        
                    completion(sessionId)
                    return
                }
            }
            
            completion(nil)
        }
        
        task.resume()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        payButton.isEnabled = false
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

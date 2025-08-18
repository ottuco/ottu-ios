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
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var apiKeyTextField: UITextField!
    @IBOutlet weak var cardExpiryTimeTextField: UITextField!
    
    @IBOutlet var formOfPaymentSwitches: [UISwitch]!
    @IBOutlet var pgCodeSwitches: [UISwitch]!
    
    @IBOutlet weak var noFormsOfPaymentSwitch: UISwitch!
    @IBOutlet weak var preloadSwitch: UISwitch!
    @IBOutlet weak var showPaymentDetailsSwitch: UISwitch!
    @IBOutlet weak var crashSwitch: UISwitch!
    @IBOutlet weak var getSessionIdButton: UIButton!
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var visibleItemsCountStack: UIStackView!
    @IBOutlet weak var visibleItemsCountValueLabel: UILabel!
    @IBOutlet weak var visibleItemsCountStepper: UIStepper!
    @IBOutlet weak var defaultSelectedPgCodeTextField: UITextField!
    
    private var sessionId: String?
    private var transactionDetailsPreload: TransactionDetails?
    
    var theme = CheckoutTheme()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        amountTextField.text = "10"
        currencyCodeTextField.text = "KWD"
        customerIdTextField.text = "john1"
        merchantIdTextField.text = "alpha.ottu.net"
        apiKeyTextField.text = "cHSLW0bE.56PLGcUYEhRvzhHVVO9CbF68hmDiXcPI"
        phoneNumberTextField.text="99459272"
        cardExpiryTimeTextField.text = ""
        
        pgCodeSwitches.forEach {
            let isOn = !($0.tag == PgCode.ottuSdk.rawValue || $0.tag == PgCode.applePay.rawValue)
            
            $0.setOn(isOn, animated: false)
        }
    }
    
    @IBAction private func didToggleSwith(_ sender: UISwitch) {
        if sender.tag == 1000 { //"No form of payments" Switch
            formOfPaymentSwitches.forEach { $0.setOn(!sender.isOn, animated: true) }
        } else if (1001...1999).contains(sender.tag) { //Form Of Payment Switches
            var allSwitchesOff = true
            formOfPaymentSwitches.forEach {
                if $0.isOn {
                    allSwitchesOff = false
                }
            }
            noFormsOfPaymentSwitch.isOn = allSwitchesOff
        }
    }
    
    @IBAction func didChangeSegmentSelection(_ sender: UISegmentedControl) {
        visibleItemsCountStack.isHidden = sender.selectedSegmentIndex == 0
    }
    
    
    @IBAction func didChangeStepperValue(_ sender: UIStepper) {
        visibleItemsCountValueLabel.text = "\(Int(sender.value))"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toThemeEditorSegue", let vc = segue.destination as? ThemeEditorViewController {
            vc.theme = theme
        }
        
        if let destinationViewController = segue.destination as? OttuPaymentsViewController {
            
            destinationViewController.theme = theme
            destinationViewController.paymentOptionsDisplayMode = (segmentedControl.selectedSegmentIndex == 0) ? .bottomSheet : .list
            destinationViewController.visibleItemsCount = UInt(visibleItemsCountStepper.value)
            
            let defaultSelectedPgCode = defaultSelectedPgCodeTextField.text
            if let defaultSelectedPgCode, defaultSelectedPgCode != "" {
                destinationViewController.defaultSelectedPgCode = defaultSelectedPgCodeTextField.text
            }
            
            if let sessionId {
                let formOfPayments = enabledFormsOfPayment()
                
                destinationViewController.sessionId = sessionId
                destinationViewController.formsOfPayment = formOfPayments
                destinationViewController.showPaymentDetails = showPaymentDetailsSwitch.isOn
                destinationViewController.merchantId = merchantIdTextField.text
                destinationViewController.apiKey = apiKeyTextField.text
                destinationViewController.transactionDetailsPreload = transactionDetailsPreload
                
                if crashSwitch.isOn {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 20) {
                        fatalError("SDK was crashed by user request")
                    }
                }
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
    
    private func enabledFormsOfPayment() -> [ottu_checkout_sdk.FormOfPayment] {
        var formOfPayments = [ottu_checkout_sdk.FormOfPayment]()
        formOfPaymentSwitches.forEach {
            if $0.isOn, let formOfPayment = FormOfPayment(rawValue: $0.tag)?.sdkValue() {
                formOfPayments.append(formOfPayment)
            }
        }
        return formOfPayments
    }
    
    private func preparePgCodes() -> [String] {
        var pgCodes = [String]()
        pgCodeSwitches.forEach {
            if $0.isOn, !$0.isHidden, let pgCode = PgCode(rawValue: $0.tag)?.stringValue() {
                pgCodes.append(pgCode)
            }
        }
        return pgCodes
    }
    
    private func prepareMinExpiryTime() -> [String: Int]? {
        var minExpiryTime: [String: Int]? = nil
        if let cardExpiryTime = cardExpiryTimeTextField.text, let expiryTime = Int(cardExpiryTime) {
            minExpiryTime = ["min_expiry_time": expiryTime]
        }
        return minExpiryTime
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
        
        let pgCodes = preparePgCodes()
        let minExpiryTime = prepareMinExpiryTime()
        
        let lang = Locale.current.languageCode == "ar" ? "ar" : "en"
        
        var json: [String: Any] = [
            "amount": amount,
            "currency_code": currencyCode,
            "pg_codes": pgCodes,
            "type": "e_commerce",
            "language": lang,
            "customer_first_name": "John",
            "customer_last_name": "Smith",
            "customer_email": "john1@some.mail",
            "billing_address": [
              "country": "KW",
              "city": "Kuwait City",
              "line1": "something"
            ],
            "include_sdk_setup_preload": "true",
            "card_acceptance_criteria": minExpiryTime
        ].compactMapValues { $0 }
        
        if let phoneNumber = phoneNumberTextField.text, phoneNumber != "" {
            json["customer_phone"] = phoneNumber
        }
        
        if let customerId = customerIdTextField.text, customerId != "" {
            json["customer_id"] = customerId
        }
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        let merchantId = merchantIdTextField.text!
        let isNeededPreload = preloadSwitch.isOn
        
        let url = URL(string: "https://\(merchantId)/b/checkout/v1/pymt-txn/")!
        
        requestSessionId(url, apyKey, jsonData, isNeededPreload, completion)
    }
    
    private func requestSessionId(_ url: URL, _ apyKey: String, _ jsonData: Data?, _ isNeededPreload: Bool, _ completion: @escaping (String?) -> Void) {
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
                           let decodedValues = try? JSONDecoder().decode(TransactionDetailsResponse.self, from: jsonData) {
                            
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

        if textField == cardExpiryTimeTextField {
            let currentText = textField.text ?? ""
            let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
            
            if prospectiveText == "" {
                getSessionIdButton.isEnabled = true
            } else if let number = Int(prospectiveText), (1...365).contains(number) {
                getSessionIdButton.isEnabled = true
            } else {
                getSessionIdButton.isEnabled = false
            }
        }
        
        payButton.isEnabled = false
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == cardExpiryTimeTextField {
            textField.text = ""
        }
        textField.resignFirstResponder()
        return true
    }
}

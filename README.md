# Ottu Checkout

The Ottu Checkout iOS SDK makes it quick and easy to build an excellent payment experience in your iOS app. We provide powerful and customizable UI screens and elements that can be used out-of-the-box to collect your user's payment details. We also expose the low-level APIs that power those UIs so that you can build fully custom experiences.

## Features

**Simplified security**: We make it simple for you to collect sensitive data such as credit card numbers and remain PCI compliant. This means the sensitive data is sent directly to Ottu instead of passing through your server.

**Apple Pay**: We provide a seamless integration with Apple Pay.

**Localized**: We support the following localizations: English, Arabic.

#### Recommended usage

If you're selling digital products or services that will be consumed within your app, (e.g. subscriptions, in-game currencies, game levels, access to premium content, or unlocking a full version), you must use Apple's in-app purchase APIs. See the [App Store review guidelines](https://developer.apple.com/app-store/review/guidelines/#payments) for more information.

#### Privacy

The Ottu SDK collects data to help us improve our products and prevent fraud. This data is never used for advertising and is not rented, sold, or given to advertisers.

## Requirements

The Ottu requires Xcode 15.0 or later and is compatible with apps targeting iOS 14 or above.

## Getting started

To initialize the SDK you need to create session token. 
You can create session token with our public API [Click here](https://docs-ottu.gitbook.io/o/developer/rest-api/authentication#public-key) to see more detail about our public API.
    
## Installation

***Ottu:*** Ottu is available through CocoaPods and via Swift Package Manager (SwiftPM).

### Installation with CocoaPods
To install the SDK via [CocoaPods](http://cocoapods.org), simply add the following line to your Podfile:

```
pod 'ottu_checkout_sdk'
```

Or, the full version:
```
pod 'ottu_checkout_sdk', :git => 'https://github.com/ottuco/ottu-ios.git', :tag => '2.1.4'
```

#### Please note:
* When ottu_checkout_sdk is added to the Podfile, the GitHub repository must also be specified as the following:
```
pod 'ottu_checkout_sdk', :git => 'https://github.com/ottuco/ottu-ios'
```
* If CocoaPods returns an error like "could not find compatible versions for pod", try running the pod repo update command to resolve it.


### Installation via Swift Package Manager 
The [Swift Package Manager (SPM)](https://swift.org/package-manager/) is a tool designed for automating the distribution of Swift code and is integrated into the Swift compiler.

Once the Swift package has been set up, adding Alamofire as a dependency requires simply including it in the dependencies value of the Package.swift file.
```
dependencies: [
    .package(url: "https://github.com/ottuco/ottu-ios.git", from: "2.1.4")
]
```

## Usage

*Swift 5.0 and higher*

In ViewController.swift, just import Ottu framework and initalize Ottu SDK.

```swift
import ottu_checkout_sdk

class ViewController: UIViewController,OttuDelegate {

    var theme = CheckoutTheme()

    override func viewDidLoad() {
        super.viewDidLoad()
        paymentContainerView.layer.cornerRadius = 8
        paymentContainerView.clipsToBounds = true

        guard let sessionId, let merchantId, let apiKey else { return }

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


        
        if let paymentView = self.checkout?.paymentView() {
            paymentView.translatesAutoresizingMaskIntoConstraints = false
            self.paymentContainerView.addSubview(paymentView)
            
            NSLayoutConstraint.activate([
                paymentView.leadingAnchor.constraint(equalTo: self.paymentContainerView.leadingAnchor),
                self.paymentContainerView.trailingAnchor.constraint(equalTo: paymentView.trailingAnchor),
                paymentView.topAnchor.constraint(equalTo: self.paymentContainerView.topAnchor),
                self.paymentContainerView.bottomAnchor.constraint(equalTo: paymentView.bottomAnchor)
            ])
        }
    }
}
```

```
extension OttuPaymentsViewController: OttuDelegate {
    func errorCallback(_ data: [String : Any]?) {
        navigationController?.popViewController(animated: true)
        let alert = UIAlertController(title: "Error", message: data?.debugDescription ?? "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        self.present(alert, animated: true)
    }
    
    func cancelCallback(_ data: [String : Any]?) {
        var message = ""
        
        if let paymentGatewayInfo = data?["payment_gateway_info"] as? [String : Any],
           let pgName = paymentGatewayInfo["pg_name"] as? String,
           pgName == "kpay" {
            message = paymentGatewayInfo["pg_response"].debugDescription
        } else {
            message = data?.debugDescription ?? ""
        }
        
        navigationController?.popViewController(animated: true)
        let alert = UIAlertController(title: "Canсel", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        self.present(alert, animated: true)
    }
    
    func successCallback(_ data: [String : Any]?) {
        navigationController?.popViewController(animated: true)
        let alert = UIAlertController(title: "Success", message: data?.debugDescription ?? "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alert, animated: true)
    }

}

```


## Licenses

- [Ottu License](LICENSE)

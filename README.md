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

The Ottu requires Xcode 14.0 or later and is compatible with apps targeting iOS 13 or above.

## Getting started

To initialize the SDK you need to create session token. 
You can create session token with our public API [Click here](https://docs-ottu.gitbook.io/o/developer/rest-api/authentication#public-key) to see more detail about our public API.
    
Installation
==========================

#### Installation with CocoaPods

***Ottu:*** Ottu is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ottu_checkout_sdk'
```

#### Installation with Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. 

Once you have your Swift package set up, adding Alamofire as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/ottuco/ottu-ios.git")
]
```

## Usage

*Swift 5.1, 5.0, 4.2, 4.0*

In ViewController.swift, just import Ottu framework and initalize Ottu SDK.

```swift
import ottu_sdk
import ottu_ios_sdk

class ViewController: UIViewController,OttuDelegate {

    var theme = CheckoutTheme()

    override func viewDidLoad() {
        super.viewDidLoad()
        paymentContainerView.layer.cornerRadius = 8
        paymentContainerView.clipsToBounds = true

        guard let sessionId, let merchantId, let apiKey else { return }

        self.checkout = Checkout(
            formsOfPayments: formsOfPayment,
            theme: theme,
            sessionId: sessionId,
            merchantId: merchantId,
            apiKey: apiKey,
            preload: transactionDetailsPreload,
            delegate: self
        )

        
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

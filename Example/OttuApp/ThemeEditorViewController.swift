//
//  ThemeEditorViewController.swift
//  OttuApp
//
//  Created by Ottu on 13.06.2024.
//

import UIKit
import ottu_checkout_sdk

class ThemeEditorViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var theme: CheckoutTheme?
    
    let fonts = UIFont.familyNames.sorted()
    let pickerView = UIPickerView()
    
    var activeTextField: UITextField?
    
    @IBOutlet weak var backgroundColorWell: UIColorWell!
    @IBOutlet weak var backgroundColorModalWell: UIColorWell!
    @IBOutlet weak var leadMargin: UITextField!
    @IBOutlet weak var trailingMargin: UITextField!
    @IBOutlet weak var topMargin: UITextField!
    @IBOutlet weak var bottomMargin: UITextField!
    
    @IBOutlet weak var mainTitleColorWell: UIColorWell!
    @IBOutlet weak var mainTitleFontName: UITextField!
    @IBOutlet weak var titleColorWell: UIColorWell!
    @IBOutlet weak var titleFontName: UITextField!
    @IBOutlet weak var subtitleColorWell: UIColorWell!
    @IBOutlet weak var subtitleFontName: UITextField!
    
    @IBOutlet weak var buttonEnabledTextColorWell: UIColorWell!
    @IBOutlet weak var buttonDisabledTextColorWell: UIColorWell!
    @IBOutlet weak var buttonEnabledBackgroundColorWell: UIColorWell!
    @IBOutlet weak var buttonDisabledBackgroundColorWell: UIColorWell!
    @IBOutlet weak var buttonFontName: UITextField!
    
    @IBOutlet weak var selectorButtonTextColorWell: UIColorWell!
    @IBOutlet weak var selectorButtonBackgroundColorWell: UIColorWell!
    @IBOutlet weak var selectorButtonFontName: UITextField!
    
    @IBOutlet weak var iconColorWell: UIColorWell!
    
    @IBOutlet weak var inputLabelColorWell: UIColorWell!
    @IBOutlet weak var inputLabelFontName: UITextField!
    @IBOutlet weak var inputTextColorWell: UIColorWell!
    @IBOutlet weak var inputTextFontName: UITextField!
    @IBOutlet weak var inputBackgroundColorWell: UIColorWell!
    
    @IBOutlet weak var switchOnColorWell: UIColorWell!
    
    @IBOutlet weak var errorMessageColorWell: UIColorWell!
    @IBOutlet weak var errorMessageFontName: UITextField!
    
    @IBOutlet weak var feesTitleColorWell: UIColorWell!
    @IBOutlet weak var feesTitleFontName: UITextField!
    @IBOutlet weak var feesSubtitleColorWell: UIColorWell!
    @IBOutlet weak var feesSubtitleFontName: UITextField!
    
    @IBOutlet weak var dataLabelColorWell: UIColorWell!
    @IBOutlet weak var dataLabelFontName: UITextField!
    @IBOutlet weak var dataValueColorWell: UIColorWell!
    @IBOutlet weak var dataValueFontName: UITextField!
    @IBOutlet weak var paymentItemBorderColor: UIColorWell!
    
    @objc func dismissPicker() {
         view.endEditing(true)
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPicker))
        view.addGestureRecognizer(tapGesture)
        
        backgroundColorWell.addTarget(self, action: #selector(colorWellChanged), for: .valueChanged)
        backgroundColorModalWell.addTarget(self, action: #selector(colorWellChanged), for: .valueChanged)
        mainTitleColorWell.addTarget(self, action: #selector(colorWellChanged), for: .valueChanged)
        titleColorWell.addTarget(self, action: #selector(colorWellChanged), for: .valueChanged)
        subtitleColorWell.addTarget(self, action: #selector(colorWellChanged), for: .valueChanged)
        buttonEnabledTextColorWell.addTarget(self, action: #selector(colorWellChanged), for: .valueChanged)
        buttonDisabledTextColorWell.addTarget(self, action: #selector(colorWellChanged), for: .valueChanged)
        buttonEnabledBackgroundColorWell.addTarget(self, action: #selector(colorWellChanged), for: .valueChanged)
        buttonDisabledBackgroundColorWell.addTarget(self, action: #selector(colorWellChanged), for: .valueChanged)
        selectorButtonTextColorWell.addTarget(self, action: #selector(colorWellChanged), for: .valueChanged)
        selectorButtonBackgroundColorWell.addTarget(self, action: #selector(colorWellChanged), for: .valueChanged)
        iconColorWell.addTarget(self, action: #selector(colorWellChanged), for: .valueChanged)
        inputLabelColorWell.addTarget(self, action: #selector(colorWellChanged), for: .valueChanged)
        inputTextColorWell.addTarget(self, action: #selector(colorWellChanged), for: .valueChanged)
        inputBackgroundColorWell.addTarget(self, action: #selector(colorWellChanged), for: .valueChanged)
        switchOnColorWell.addTarget(self, action: #selector(colorWellChanged), for: .valueChanged)
        errorMessageColorWell.addTarget(self, action: #selector(colorWellChanged), for: .valueChanged)
        feesTitleColorWell.addTarget(self, action: #selector(colorWellChanged), for: .valueChanged)
        feesSubtitleColorWell.addTarget(self, action: #selector(colorWellChanged), for: .valueChanged)
        dataLabelColorWell.addTarget(self, action: #selector(colorWellChanged), for: .valueChanged)
        dataValueColorWell.addTarget(self, action: #selector(colorWellChanged), for: .valueChanged)
        paymentItemBorderColor.addTarget(self, action: #selector(colorWellChanged), for: .valueChanged)
        guard let theme else { return }
        
        backgroundColorWell.selectedColor = theme.backgroundColor
        backgroundColorModalWell.selectedColor = theme.backgroundColorModal
        leadMargin.text = "\(theme.margins.left)"
        trailingMargin.text = "\(theme.margins.right)"
        topMargin.text = "\(theme.margins.top)"
        bottomMargin.text = "\(theme.margins.bottom)"
        mainTitleColorWell.selectedColor = theme.mainTitle.color
        mainTitleFontName.text = theme.mainTitle.fontFamily
        titleColorWell.selectedColor = theme.title.color
        titleFontName.text = theme.title.fontFamily
        subtitleColorWell.selectedColor = theme.subtitle.color
        subtitleFontName.text = theme.subtitle.fontFamily
        buttonEnabledTextColorWell.selectedColor = theme.button.enabledTitleColor
        buttonDisabledTextColorWell.selectedColor = theme.button.disabledTitleColor
        buttonEnabledBackgroundColorWell.selectedColor = theme.button.enabledBackgroundColor
        buttonDisabledBackgroundColorWell.selectedColor = theme.button.disabledBackgroundColor
        buttonFontName.text = theme.button.fontFamily
        selectorButtonTextColorWell.selectedColor = theme.selectorButton.enabledTitleColor
        selectorButtonBackgroundColorWell.selectedColor = theme.selectorButton.enabledBackgroundColor
        selectorButtonFontName.text = theme.selectorButton.fontFamily
        iconColorWell.selectedColor = theme.iconColor
        inputLabelColorWell.selectedColor = theme.inputTextField.label.color
        inputLabelFontName.text = theme.inputTextField.label.fontFamily
        inputTextColorWell.selectedColor = theme.inputTextField.text.color
        inputTextFontName.text = theme.inputTextField.text.fontFamily
        inputBackgroundColorWell.selectedColor = theme.backgroundColor
        switchOnColorWell.selectedColor = theme.switchOnTintColor
        errorMessageColorWell.selectedColor = theme.errorMessage.color
        errorMessageFontName.text = theme.errorMessage.fontFamily
        feesTitleColorWell.selectedColor = theme.feesTitle.color
        feesTitleFontName.text = theme.feesTitle.fontFamily
        feesSubtitleColorWell.selectedColor = theme.feesSubtitle.color
        feesSubtitleFontName.text = theme.feesSubtitle.fontFamily
        dataLabelColorWell.selectedColor = theme.dataLabel.color
        dataLabelFontName.text = theme.dataLabel.fontFamily
        dataValueColorWell.selectedColor = theme.dataValue.color
        dataValueFontName.text = theme.dataValue.fontFamily
        paymentItemBorderColor.selectedColor = theme.paymentItemBorderColor
    }
    
    @objc private func colorWellChanged(_ sender: UIColorWell) {
        if let color = sender.selectedColor {
            if sender.tag == 1 {
                theme?.backgroundColor = color
            }
            if sender.tag == 2 {
                theme?.backgroundColorModal = color
            }
            if sender.tag == 3 {
                theme?.mainTitle.color = color
            }
            if sender.tag == 4 {
                theme?.title.color = color
            }
            if sender.tag == 5 {
                theme?.subtitle.color = color
            }
            if sender.tag == 6 {
                theme?.button.enabledTitleColor = color
            }
            if sender.tag == 7 {
                theme?.button.disabledTitleColor = color
            }
            if sender.tag == 8 {
                theme?.button.enabledBackgroundColor = color
            }
            if sender.tag == 9 {
                theme?.button.disabledBackgroundColor = color
            }
            if sender.tag == 10 {
                theme?.selectorButton.enabledTitleColor = color
            }
            if sender.tag == 11 {
                theme?.selectorButton.enabledBackgroundColor = color
            }
            if sender.tag == 12 {
                theme?.iconColor = color
            }
            if sender.tag == 13 {
                theme?.inputTextField.label.color = color
            }
            if sender.tag == 14 {
                theme?.inputTextField.text.color = color
            }
            if sender.tag == 15 {
                theme?.inputTextField.backgroundColor = color
            }
            if sender.tag == 16 {
                theme?.switchOnTintColor = color
            }
            if sender.tag == 17 {
                theme?.errorMessage.color = color
            }
            if sender.tag == 18 {
                theme?.feesTitle.color = color
            }
            if sender.tag == 19 {
                theme?.feesSubtitle.color = color
            }
            if sender.tag == 20 {
                theme?.dataLabel.color = color
            }
            if sender.tag == 21 {
                theme?.dataValue.color = color
            }
            if sender.tag == 22 {
                theme?.paymentItemBorderColor = color
            }
        }
    }

    @IBAction func textFieldValueChanged(_ sender: UITextField) {
        if sender.tag == 1 ||
            sender.tag == 2 ||
            sender.tag == 3 ||
            sender.tag == 4 {
            theme?.margins = UIEdgeInsets(
                top: CGFloat(Float(topMargin.text ?? "0") ?? 0),
                left: CGFloat(Float(leadMargin.text ?? "0") ?? 0),
                bottom: CGFloat(Float(bottomMargin.text ?? "0") ?? 0),
                right: CGFloat(Float(trailingMargin.text ?? "0") ?? 0)
            )
        }
    }
    
    func setThemeFontFamily(_ fontFamily: String) {
        if activeTextField?.tag == 5 {
            theme?.mainTitle.fontFamily = fontFamily 
        }
        if activeTextField?.tag == 6 {
            theme?.title.fontFamily = fontFamily
        }
        if activeTextField?.tag == 7 {
            theme?.subtitle.fontFamily = fontFamily
        }
        if activeTextField?.tag == 8 {
            theme?.button.fontFamily = fontFamily
        }
        if activeTextField?.tag == 9 {
            theme?.selectorButton.fontFamily = fontFamily
        }
        if activeTextField?.tag == 10 {
            theme?.inputTextField.label.fontFamily = fontFamily
        }
        if activeTextField?.tag == 11 {
            theme?.inputTextField.text.fontFamily = fontFamily
        }
        if activeTextField?.tag == 12 {
            theme?.errorMessage.fontFamily = fontFamily
        }
        if activeTextField?.tag == 13 {
            theme?.feesTitle.fontFamily = fontFamily
        }
        if activeTextField?.tag == 14 {
            theme?.feesSubtitle.fontFamily = fontFamily
        }
        if activeTextField?.tag == 15 {
            theme?.dataLabel.fontFamily = fontFamily
        }
        if activeTextField?.tag == 16 {
            theme?.dataValue.fontFamily = fontFamily
        }
    }

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
         1
     }

     func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
         fonts.count
     }

     func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
         fonts[row]
     }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedFontFamily = fonts[row]
        
        activeTextField?.text = selectedFontFamily
        setThemeFontFamily(selectedFontFamily)
    }


}

extension ThemeEditorViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        textField.inputView = pickerView
        pickerView.selectRow(0, inComponent: 0, animated: true)
    }
}



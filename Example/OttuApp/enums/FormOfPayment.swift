//
//  FormOfPayment.swift
//  OttuApp
//
//  Created by Ottu on 06.02.2025.
//

import ottu_checkout_sdk

enum FormOfPayment: Int {
    case applePay = 1001
    case stcPay = 1004
//    case urPay = 1008
    case tokenPay = 1002
    case redirect = 1005
//    case flex = 1006
    case cardOnsite = 1007
      
    func sdkValue() -> ottu_checkout_sdk.FormOfPayment {
          switch self {
          case .applePay: return .applePay
          case .stcPay: return .stcPay
//          case .urPay: return .urPay
          case .tokenPay: return .tokenPay
          case .redirect: return .redirect
//          case .flex: return .flex
          case .cardOnsite: return .cardOnsite
          }
      }
  }

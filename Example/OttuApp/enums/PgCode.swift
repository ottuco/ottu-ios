//
//  PgCode.swift
//  OttuApp
//
//  Created by Ottu on 06.02.2025.
//

enum PgCode: Int {
    case applePay = 2001
    case mpgsTesting = 2002
    case knetStaging = 2003
    case benefit = 2004
    case benefitpay = 2005
    case stcPay = 2006
    case nbkMpgs = 2007
    case urpay = 2008
    case tamara = 2009
    case tabby = 2010
    case tapPg = 2011
    case ottuSdk = 2012
    case muscatbank = 2013
    
    func stringValue() -> String {
        switch self {
        case .applePay: return "apple-pay"
        case .mpgsTesting: return "mpgs-testing"
        case .knetStaging: return "knet-staging"
        case .benefit: return "benefit"
        case .benefitpay: return "benefitpay"
        case .stcPay: return "stc_pay"
        case .nbkMpgs: return "nbk-mpgs"
        case .urpay: return "urpay"
        case .tamara: return "tamara"
        case .tabby: return "tabby"
        case .tapPg: return "tap_pg"
        case .ottuSdk: return "ottu_sdk"
        case .muscatbank: return "muscatbank_demo"
        }
    }
}

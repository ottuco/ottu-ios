//
//  ContentView.swift
//  test_ottu
//
//  Created by Oleksandr Pylypenko on 31.12.2024.
//

import SwiftUI
import ottu_checkout_sdk

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink(destination: OttuPaymentsView(
                    formsOfPayment: [],
                    showPaymentDetails: true,
                    sessionId: "baf9beb0034694c43fcb7abd54bd51a67da63e93",
                    merchantId: "alpha.ottu.net",
                    apiKey: "cHSLW0bE.56PLGcUYEhRvzhHVVO9CbF68hmDiXcPI",
                    transactionDetailsPreload: nil
                )) {
                    Text("Open Payment")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}

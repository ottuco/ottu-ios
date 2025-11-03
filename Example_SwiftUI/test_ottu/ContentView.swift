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
                    sessionId: "", // insert your txn ID
                    merchantId: "", // insert your merchant ID
                    apiKey: "", // insert your API key
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

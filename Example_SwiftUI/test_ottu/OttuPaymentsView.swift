//
//  ContentView.swift
//  test_ottu
//
//  Created by Oleksandr Pylypenko on 31.12.2024.
//

import SwiftUI
import ottu_checkout_sdk

struct OttuPaymentsView: View {
    @State private var paymentViewHeight: CGFloat = 0
    @State private var showPaymentSuccess = false
    @State private var errorMessage: String? = nil
    @State private var cancelMessage: String? = nil

    var formsOfPayment: [FormOfPayment]
    var showPaymentDetails: Bool = true
    var sessionId: String
    var merchantId: String
    var apiKey: String
    var transactionDetailsPreload: TransactionDetails?

    var body: some View {
        VStack(spacing: 20) {
            Text("Some user UI elements Some user UI elements Some user UI elements Some user UI elements")
                .frame(maxWidth: .infinity)

            VStack {
                PaymentContainerView(
                    formsOfPayment: formsOfPayment,
                    showPaymentDetails: showPaymentDetails,
                    sessionId: sessionId,
                    merchantId: merchantId,
                    apiKey: apiKey,
                    transactionDetailsPreload: transactionDetailsPreload,
                    onSuccess: { data in
                        showPaymentSuccess = true
                        errorMessage = nil
                        cancelMessage = nil
                    },
                    onError: { data in
                        errorMessage = data?.debugDescription ?? "Unknown error"
                    },
                    onCancel: { data in
                        cancelMessage = data?.debugDescription ?? "Payment was canceled"
                    },
                    onHeightChange: { newHeight in
                        self.paymentViewHeight = newHeight
                    }
                )
                
            }
            .animation(.easeInOut, value: paymentViewHeight)
            .frame(height: paymentViewHeight)
               
            
            Text("Some more UI elements below Some more UI elements below Some more UI elements below Some more UI elements below")


            Spacer()
        }
        .padding()
        .background(Color.orange)
        .alert("Error", isPresented: Binding(
            get: { errorMessage != nil },
            set: { if !$0 { errorMessage = nil } }
        )) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage ?? "")
        }
        .alert("Cancel", isPresented: Binding(
            get: { cancelMessage != nil },
            set: { if !$0 { cancelMessage = nil } }
        )) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(cancelMessage ?? "")
        }
    }
}

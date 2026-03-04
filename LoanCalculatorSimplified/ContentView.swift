import SwiftUI

private let bgColor = Color(red: 200/255, green: 230/255, blue: 245/255)

struct ContentView: View {
    @StateObject private var model = LoanModel()
    @State private var showInfo = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 12) {
                    Text("Loan Calculator Simplified")
                        .font(.system(size: 24))
                        .multilineTextAlignment(.center)
                        .padding(.top, -10)
                        .padding(.bottom, 20)

                    FieldRow(buttonTitle: "Loan\nAmount",
                             placeholder: "Loan Amount",
                             text: $model.loanAmount,
                             action: { model.calculateLoanAmount() })

                    FieldRow(buttonTitle: "Interest\nRate",
                             placeholder: "Interest Rate",
                             text: $model.interestRate,
                             action: { model.calculateInterestRate() })

                    FieldRow(buttonTitle: "Number Of\nPayments",
                             placeholder: "No. of Payments",
                             text: $model.numberOfPayments,
                             action: { model.calculateNumberOfPayments() })

                    FieldRow(buttonTitle: "Payment\nAmount",
                             placeholder: "Payment Amount",
                             text: $model.paymentAmount,
                             action: { model.calculatePaymentAmount() })

                    FieldRow(buttonTitle: "Total Interest:",
                             placeholder: "Total Interest",
                             text: $model.totalInterest,
                             isCalculable: false,
                             action: {})

                    // Info and Clear buttons
                    GeometryReader { geo in
                        HStack(spacing: 10) {
                            Spacer()
                            Button(action: { showInfo = true }) {
                                Text("Information")
                                    .font(.system(size: 17))
                                    .foregroundColor(.black)
                                    .frame(width: (geo.size.width - 10) * 0.35, height: 28)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.white)
                            Button(action: { model.clear() }) {
                                Text("Clear")
                                    .font(.system(size: 17))
                                    .foregroundColor(.black)
                                    .frame(width: (geo.size.width - 10) * 0.35, height: 28)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.white)
                        }
                        .frame(width: geo.size.width, height: geo.size.height, alignment: .leading)
                    }
                    .frame(height: 45)
                    .padding(.top, 2)
                }
                .padding(25)
            }
            .background(bgColor)
            .ignoresSafeArea(edges: .bottom)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Loan Calculator")
                        .font(.system(size: 17))
                }
            }
        }
        .alert(model.alertMessage, isPresented: $model.showAlert) {
            Button("OK", role: .cancel) {}
        }
        .sheet(isPresented: $showInfo) {
            InfoView()
                .presentationDetents([.height(130)])
                .presentationDragIndicator(.visible)
        }
    }
}

struct InfoView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 16) {
            Text("Enter any 3 fields on the right, then press the 4th button on the left")
                .font(.system(size: 16))
                .multilineTextAlignment(.center)
            Button("OK") { dismiss() }
                .font(.system(size: 17))
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct FieldRow: View {
    let buttonTitle: String
    let placeholder: String
    @Binding var text: String
    var isCalculable: Bool = true
    let action: () -> Void

    var body: some View {
        GeometryReader { geo in
            HStack(spacing: 10) {
                if isCalculable {
                    Button(action: action) {
                        Text(buttonTitle)
                            .multilineTextAlignment(.center)
                            .font(.system(size: 15))
                            .foregroundColor(.black)
                            .frame(width: (geo.size.width - 10) * 0.25, height: 38)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.white)

                    Spacer()
                } else {
                    Text(buttonTitle)
                        .multilineTextAlignment(.trailing)
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }

                TextField(placeholder, text: $text)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.decimalPad)
                    .font(.system(size: 18))
                    .multilineTextAlignment(.leading)
                    .frame(width: (geo.size.width - 10) * 0.50, height: geo.size.height)
                    .disabled(!isCalculable)
            }
            .frame(width: geo.size.width, height: geo.size.height, alignment: .leading)
        }
        .frame(height: 50)
    }
}

#Preview {
    ContentView()
}

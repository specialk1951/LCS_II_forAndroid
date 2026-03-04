import Foundation

class LoanModel: ObservableObject {
    @Published var loanAmount: String = ""
    @Published var interestRate: String = ""
    @Published var numberOfPayments: String = ""
    @Published var paymentAmount: String = ""
    @Published var totalInterest: String = ""
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false

    private func parseAmount(_ text: String) -> Double? {
        let cleaned = text
            .replacingOccurrences(of: "$", with: "")
            .replacingOccurrences(of: ",", with: "")
            .trimmingCharacters(in: .whitespaces)
        return Double(cleaned)
    }

    private func parseRate(_ text: String) -> Double? {
        let cleaned = text.replacingOccurrences(of: "%", with: "").trimmingCharacters(in: .whitespaces)
        return Double(cleaned)
    }

    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        let formatted = formatter.string(from: NSNumber(value: value)) ?? String(format: "%.2f", value)
        return "$ \(formatted)"
    }

    private func showError(_ message: String) {
        alertMessage = message
        showAlert = true
    }

    private func missingEntries() {
        showError("Ensure that 3 of the 4 entries are filled-in before selecting a button")
    }

    private func lessThanOne(_ fieldName: String) {
        showError("Allowable entry for \(fieldName) is greater than or equal to 1")
    }

    private func oneTo100() {
        showError("Allowable entry for Interest Rate is 0.1 to 100")
    }

    func calculateLoanAmount() {
        guard !interestRate.isEmpty, !numberOfPayments.isEmpty, !paymentAmount.isEmpty else {
            missingEntries(); return
        }
        guard let rate = parseRate(interestRate),
              let n = Double(numberOfPayments),
              let pmt = parseAmount(paymentAmount) else {
            showError("Please enter valid numbers"); return
        }
        if rate < 0.1 || rate > 100 { oneTo100(); interestRate = ""; totalInterest = ""; return }
        if n < 1 { lessThanOne("Number of Payments"); numberOfPayments = ""; return }
        if pmt < 1 { lessThanOne("Payment Amount"); paymentAmount = ""; return }

        let monthlyRate = rate / 100.0 / 12.0
        let loan = pmt / (monthlyRate / (1 - pow(1 + monthlyRate, -n)))
        loanAmount = formatCurrency(loan)
        calculateTotalInterest()
    }

    func calculateInterestRate() {
        guard !loanAmount.isEmpty, !numberOfPayments.isEmpty, !paymentAmount.isEmpty else {
            missingEntries(); return
        }
        guard let loan = parseAmount(loanAmount),
              let n = Double(numberOfPayments),
              let pmt = parseAmount(paymentAmount) else {
            showError("Please enter valid numbers"); return
        }
        if loan < 1 { lessThanOne("Loan Amount"); loanAmount = ""; return }
        if n < 1 { lessThanOne("Number of Payments"); numberOfPayments = ""; return }
        if pmt < 1 { lessThanOne("Payment Amount"); paymentAmount = ""; return }

        var i = 0.001
        while i <= 100 {
            let monthlyRate = i / 100.0 / 12.0
            let aOverP = pmt / loan
            let formula = monthlyRate / (1 - pow(1 + monthlyRate, -n))
            if aOverP > formula {
                i += 0.0001
            } else {
                i -= 0.0001
                i += 0.00005
                i = (i * 10000).rounded() / 10000
                interestRate = String(format: "%.3f%%", i)
                if i < 0.1 || i > 100 {
                    showError("Allowable range for Interest Rate is 0.1 to 100 percent")
                    interestRate = ""
                    totalInterest = ""
                }
                break
            }
            if i > 100 {
                showError("Allowable range for Interest Rate is 0.1 to 100 percent")
                interestRate = ""
                totalInterest = ""
                break
            }
        }
        if !interestRate.isEmpty { calculateTotalInterest() }
    }

    func calculateNumberOfPayments() {
        guard !loanAmount.isEmpty, !interestRate.isEmpty, !paymentAmount.isEmpty else {
            missingEntries(); return
        }
        guard let loan = parseAmount(loanAmount),
              let rate = parseRate(interestRate),
              let pmt = parseAmount(paymentAmount) else {
            showError("Please enter valid numbers"); return
        }
        if loan < 1 { lessThanOne("Loan Amount"); loanAmount = ""; return }
        if rate < 0.1 || rate > 100 { oneTo100(); interestRate = ""; totalInterest = ""; return }
        if pmt < 1 { lessThanOne("Payment Amount"); paymentAmount = ""; return }

        let monthlyRate = rate / 100.0 / 12.0
        let numerator = log10(1 - (loan * monthlyRate / pmt))
        let denominator = log10(1 + monthlyRate)
        let n = -numerator / denominator
        numberOfPayments = String(format: "%.3f", n)
        calculateTotalInterest()
    }

    func calculatePaymentAmount() {
        guard !loanAmount.isEmpty, !interestRate.isEmpty, !numberOfPayments.isEmpty else {
            missingEntries(); return
        }
        guard let loan = parseAmount(loanAmount),
              let rate = parseRate(interestRate),
              let n = Double(numberOfPayments) else {
            showError("Please enter valid numbers"); return
        }
        if loan < 1 { lessThanOne("Loan Amount"); loanAmount = ""; return }
        if rate < 0.1 || rate > 100 { oneTo100(); interestRate = ""; totalInterest = ""; return }
        if n < 1 { lessThanOne("Number of Payments"); numberOfPayments = ""; return }

        let monthlyRate = rate / 100.0 / 12.0
        let pmt = loan * monthlyRate / (1 - pow(1 + monthlyRate, -n))
        paymentAmount = formatCurrency(pmt)
        calculateTotalInterest()
    }

    private func calculateTotalInterest() {
        guard let loan = parseAmount(loanAmount),
              let n = Double(numberOfPayments),
              let pmt = parseAmount(paymentAmount) else { return }
        let interest = (pmt * n) - loan
        totalInterest = formatCurrency(interest)
    }

    func clear() {
        loanAmount = ""
        interestRate = ""
        numberOfPayments = ""
        paymentAmount = ""
        totalInterest = ""
    }
}

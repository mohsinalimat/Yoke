//
//  Currency.swift
//  FooD
//
//  Created by LAURA JELENICH on 5/6/20.
//  Copyright © 2020 LAURA JELENICH. All rights reserved.
//

import UIKit

class CurrencyField: UITextField {
    var decimal: Decimal { string.decimal / pow(10, Formatter.currency.maximumFractionDigits) }
    var maximum: Decimal = 999_999_999.99
    private var lastValue: String?
    var locale: Locale = .current {
        didSet {
            Formatter.currency.locale = locale
            sendActions(for: .editingChanged)
        }
    }
    override func willMove(toSuperview newSuperview: UIView?) {
        // you can make it a fixed locale currency if needed
        // self.locale = Locale(identifier: "pt_BR") // or "en_US", "fr_FR", etc
        Formatter.currency.locale = locale
        addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        keyboardType = .numberPad
        textAlignment = .right
        sendActions(for: .editingChanged)
    }
    override func deleteBackward() {
        text = string.digits.dropLast().string
        // manually send the editingChanged event
        sendActions(for: .editingChanged)
    }
    @objc func editingChanged() {
        guard decimal <= maximum else {
            text = lastValue
            return
        }
        text = decimal.currency
        lastValue = text
    }
}

extension CurrencyField {
    var doubleValue: Double { (decimal as NSDecimalNumber).doubleValue }
}

extension UITextField {
     var string: String { text ?? "" }
}

extension NumberFormatter {
    convenience init(numberStyle: Style) {
        self.init()
        self.numberStyle = numberStyle
    }
}

private extension Formatter {
    static let currency: NumberFormatter = .init(numberStyle: .currency)
}

extension StringProtocol where Self: RangeReplaceableCollection {
    var digits: Self { filter { $0.isWholeNumber } }
}

extension String {
    var decimal: Decimal { Decimal(string: digits) ?? 0 }
}

extension Decimal {
    var currency: String { Formatter.currency.string(for: self) ?? "" }
}

extension LosslessStringConvertible {
    var string: String { .init(self) }
}

extension Int {
    func penniesToFormattedCurrency() -> String {
        let dollars = Double(self) / 100
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if let dollarString = formatter.string(from: dollars as NSNumber) {
            return dollarString
        }
        
        return "$0.00"
    }
}

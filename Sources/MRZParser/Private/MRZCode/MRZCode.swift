//
//  MRZCode.swift
//
//
//  Created by Roman Mazeev on 20.07.2021.
//

import Foundation

public struct MRZCode {
    public let format: MRZFormat
    public var documentTypeField: Field
    public var countryCodeField: Field
    public var documentNumberField: ValidatedField<String>
    public var birthdateField: ValidatedField<Date?>
    public var sexField: Field
    public var expiryDateField: ValidatedField<Date?>
    public var nationalityField: Field
    public var optionalDataField: ValidatedField<String>
    public var optionalData2Field: ValidatedField<String>?
    public var namesField: NamesField
    public var finalCheckDigit: String

    public var isValid: Bool {
        if !finalCheckDigit.isEmpty {
            var fieldsValidate: [ValidatedFieldProtocol] = [ documentNumberField ]

            if format == .td1, let optionalData2Field = optionalData2Field {
                fieldsValidate.append(optionalDataField)
                fieldsValidate.append(contentsOf: [
                    birthdateField,
                    expiryDateField
                ])
                fieldsValidate.append(optionalData2Field)
            } else {
                fieldsValidate.append(contentsOf: [
                    birthdateField,
                    expiryDateField
                ])

                fieldsValidate.append(optionalDataField)
            }

            let compositedValue = fieldsValidate.reduce("", { $0 + $1.rawValue + $1.checkDigit })
            let isCompositedValueValid = MRZFieldFormatter.isValueValid(compositedValue, checkDigit: finalCheckDigit)
            return documentNumberField.isValid &&
                birthdateField.isValid &&
                expiryDateField.isValid &&
                isCompositedValueValid
        } else {
            return documentNumberField.isValid &&
                birthdateField.isValid &&
                expiryDateField.isValid
        }
    }
}

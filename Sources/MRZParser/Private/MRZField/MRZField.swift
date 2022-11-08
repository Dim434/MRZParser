//
//  MRZField.swift
//  
//
//  Created by Roman Mazeev on 15.06.2021.
//

public enum MRZFieldType {
    case documentType, countryCode, names, documentNumber, nationality, birthdate, sex,
         expiryDate, personalNumber, optionalData, hash
}

// MARK: - BasicFields
public typealias NamesField = (surnames: String, givenNames: String)

public struct Field {
    public let value: String
    public let rawValue: String
}

// MARK: ValidatedField
public protocol ValidatedFieldProtocol {
    var rawValue: String { get }
    var checkDigit: String { get }
    var isValid: Bool { get }
}

public extension ValidatedFieldProtocol {
    public var isValid: Bool {
        return MRZFieldFormatter.isValueValid(rawValue, checkDigit: checkDigit)
    }
}

public struct ValidatedField<T>: ValidatedFieldProtocol {
    public let value: T
    public let rawValue: String
    public let checkDigit: String
}

//
//  Validator.swift
//  WeSports
//
//  Created by datNguyem on 16/11/2021.
//

import Foundation

final class ValidatorError: Error {
    var message: String
    
    init(_ message: String) {
        self.message = message
    }
}

enum ValidatorFactory {
    static func validatorFor(type: ValidatorType) -> ValidatorConvertible {
        switch type {
        case .name:
            return NameValidator()
        case .username:
            return UsernameValidator()
        case .mail:
            return MailValidator()
        case .password:
            return PasswordValidator()
        case .repassword:
            return RePasswordValidator()
        case .phone:
            return PhoneValidator()
        }
    }
}

struct NameValidator: ValidatorConvertible {
    func validated(_ value: String, value compareWith: String?) throws -> String {
        guard !value.isEmpty else {
            throw ValidatorError("Họ tên không được trống")
        }
        return value
    }
}

struct UsernameValidator: ValidatorConvertible {
    func validated(_ value: String, value compareWith: String?) throws -> String {
        guard !value.isEmpty else {
            throw ValidatorError("Tên đăng nhập không được trống")
        }
        
        guard value.count >= 3 else {
            throw ValidatorError("Tên đăng nhập cần ít nhất 3 ký tự")
        }
        
        do {
            if try NSRegularExpression(pattern: "^[a-zA-Z0-9]{3,18}$",  options: .caseInsensitive).firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count)) == nil {
                throw ValidatorError("Tên đăng nhập sai định dạng")
            }
        } catch {
            throw ValidatorError("Tên đăng nhập sai định dạng")
        }
        return value
    }
}

struct PhoneValidator: ValidatorConvertible {
    func validated(_ value: String, value compareWith: String?) throws -> String {
        guard !value.isEmpty else {
            throw ValidatorError("Số điện thoại không được trống")
        }
        
        do {
            if try NSRegularExpression(pattern: #"^\(?\d{3}\)?[ -]?\d{3}[ -]?\d{4}$"#, options: .caseInsensitive)
                .firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count)) == nil  {
                throw ValidatorError("Số điện thoại không đúng định dạng")
            }
        }
        
        return value
    }
}

struct MailValidator: ValidatorConvertible {
    func validated(_ value: String, value compareWith: String?) throws -> String {
        guard !value.isEmpty else {
            throw ValidatorError("Email không được trống")
        }
        
        do {
            if try NSRegularExpression(pattern: ##"^\S+@\S+\.\S+$"##, options: .caseInsensitive).firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count)) == nil {
                throw ValidatorError("Email sai định dạng")
            }
        }
        return value
    }
}

struct PasswordValidator: ValidatorConvertible {
    func validated(_ value: String, value compareWith: String?) throws -> String {
        guard !value.isEmpty else {
            throw ValidatorError("Mật khẩu không được để trống")
        }
        
        guard value.count >= 6 else {
            throw ValidatorError("Mật khẩu ít nhất phải 6 ký tự")
        }
        
        return value
    }
}

struct RePasswordValidator: ValidatorConvertible {
    func validated(_ value: String, value compare: String?) throws -> String {
        if value != compare {
            throw ValidatorError("Nhập lại mật khẩu không khớp")
        }
        return value
    }
}

//
//  task_7.swift
//  Задание 7. Безопасная обработка пользовательского ввода.
//  Запуск: swift task_7.swift
//

import Foundation

struct ValidationError: Error, CustomStringConvertible {
    let message: String
    let field: String
    let value: Any
    var description: String { "[\(field)] \(message) (значение=\(value))" }
}

struct MultipleValidationErrors: Error, CustomStringConvertible {
    let errors: [Error]
    var description: String {
        errors.map { "\(type(of: $0)): \($0)" }.joined(separator: "; ")
    }
    func byType<T>(_ type: T.Type) -> [Error] {
        return errors.filter { $0 is T }
    }
}

struct InputError: Error, CustomStringConvertible {
    let value: Any
    let reason: String
    var description: String { "некорректный ввод '\(value)': \(reason)" }
}

struct User {
    let name: String
    let age: Int
    let email: String
}

func parse_int(_ value: String?) throws -> Int {
    guard let value = value, let n = Int(value) else {
        throw InputError(value: value ?? "nil", reason: "ожидалось целое число")
    }
    return n
}

func parse_email(_ value: String?) throws -> String {
    guard let value = value,
          value.contains("@"),
          !value.hasPrefix("@"),
          !value.hasSuffix("@") else {
        throw InputError(value: value ?? "nil",
                         reason: "email должен содержать '@' и локальную/доменную части")
    }
    return value
}

func buildUser(_ data: [String: String?]) throws -> User {
    var errors: [Error] = []

    let name = data["name"] ?? nil
    if name == nil || name!.trimmingCharacters(in: .whitespaces).isEmpty {
        errors.append(ValidationError(message: "имя обязательно", field: "name", value: name ?? "nil"))
    }

    var age: Int?
    do {
        age = try parse_int(data["age"] ?? nil)
    } catch {
        errors.append(ValidationError(message: "\(error)", field: "age", value: data["age"] ?? "nil"))
    }

    var email: String?
    do {
        email = try parse_email(data["email"] ?? nil)
    } catch {
        errors.append(ValidationError(message: "\(error)", field: "email", value: data["email"] ?? "nil"))
    }

    if !errors.isEmpty {
        throw MultipleValidationErrors(errors: errors)
    }

    return User(name: name!.trimmingCharacters(in: .whitespaces),
                age: age!,
                email: email!)
}

// MARK: - Demo

func task7Demo() {
    print("=== Задание 7 ===")

    do {
        let user = try buildUser(["name": " Иван ", "age": "30", "email": "i@ex.com"])
        print("  User(name: \"\(user.name)\", age: \(user.age), email: \"\(user.email)\")")
    } catch {
        print("  ошибка: \(error)")
    }

    do {
        _ = try buildUser(["name": "", "age": "abc", "email": "no-at"])
    } catch let e as MultipleValidationErrors {
        print("  MultipleValidationErrors (\(e.errors.count) ошибок):")
        for err in e.errors {
            print("    - \(err)")
        }
    } catch {
        print("  ошибка: \(error)")
    }

    do {
        _ = try parse_int("not-a-number")
    } catch let e as InputError {
        print("  InputError: \(e)")
    } catch {
        print("  ошибка: \(error)")
    }
}

task7Demo()
//
//  task_5.swift
//  Задание 5. Множественные ошибки валидации (вариант B, как в Swift — аналога ExceptionGroup нет).
//  Запуск: swift task_5.swift
//

import Foundation

struct ValidationError: Error, CustomStringConvertible {
    let message: String
    let field: String
    let value: Any

    var description: String {
        return "[\(field)] \(message) (значение=\(value))"
    }
}

struct MultipleValidationErrors: Error, CustomStringConvertible {
    let errors: [Error]

    var description: String {
        return errors.map { "\(type(of: $0)): \($0)" }.joined(separator: "; ")
    }

    func byType<T>(_ type: T.Type) -> [Error] {
        return errors.filter { $0 is T }
    }
}

// MARK: - Demo

func task5Demo() {
    print("=== Задание 5 ===")

    let errors: [Error] = [
        ValidationError(message: "пусто", field: "name", value: ""),
        ValidationError(message: "нет @", field: "email", value: "abc")
    ]

    let mve = MultipleValidationErrors(errors: errors)
    print("  MultipleValidationErrors: \(mve)")
    print("  только ValidationError: \(mve.byType(ValidationError.self).count)")

    // Попытка "обработать" как группу — в Swift такого механизма нет,
    // поэтому просто пробрасываем и ловим как один тип.
    do {
        throw mve
    } catch let e as MultipleValidationErrors {
        print("  пойман MultipleValidationErrors с \(e.errors.count) ошибками")
    } catch {
        print("  поймана одиночная ошибка: \(error)")
    }
}

task5Demo()
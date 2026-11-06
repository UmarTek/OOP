
import Foundation

struct ExpectedError: Error, CustomStringConvertible {
    let message: String
    var description: String { "ExpectedError: \(message)" }
}

struct UnexpectedWrapError: Error, CustomStringConvertible {
    let message: String
    let underlying: Error?
    var description: String {
        if let u = underlying {
            return "\(message) (первопричина: \(type(of: u)): \(u))"
        }
        return message
    }
}

func dangerousOperation(shouldFailExpected: Bool = false,
                        shouldFailOther: Bool = false) throws -> String {
    if shouldFailExpected {
        throw ExpectedError(message: "ожидаемый сбой (например, кэш не прогрет)")
    }
    if shouldFailOther {
        struct OtherError: Error, CustomStringConvertible {
            let message: String
            var description: String { "OtherError: \(message)" }
        }
        throw OtherError(message: "непредвиденный сбой")
    }
    return "success"
}

/// Обёртка над dangerousOperation().
///
/// Подавление ExpectedError здесь допустимо, потому что:
/// - это документированная «штатная» ошибка (например, отсутствие
///   необязательного кэша);
/// - у нас есть осмысленный fallback-результат, эквивалентный
///   нормальному поведению;
/// - мы не скрываем баг: любые другие исключения пробрасываются
///   с сохранением первопричины в поле `underlying`.
func safeOperation(expected: Bool = false,
                   other: Bool = false,
                   fallback: String = "fallback") throws -> String {
    do {
        return try dangerousOperation(shouldFailExpected: expected,
                                      shouldFailOther: other)
    } catch is ExpectedError {
        return fallback
    } catch {
        throw UnexpectedWrapError(
            message: "safeOperation: непредвиденная ошибка: \(error)",
            underlying: error
        )
    }
}

// MARK: - Demo

func task8Demo() {
    print("=== Задание 8* ===")

    do {
        print("  ok: \(try safeOperation())")
    } catch {
        print("  ошибка: \(error)")
    }

    do {
        print("  ExpectedError подавлен -> \(try safeOperation(expected: true, fallback: "DEFAULT"))")
    } catch {
        print("  ошибка: \(error)")
    }

    do {
        _ = try safeOperation(other: true)
    } catch let e as UnexpectedWrapError {
        print("  UnexpectedWrapError: \(e.message)")
        print("  underlying: \(e.underlying.map { String(describing: type(of: $0)) } ?? "nil")")
    } catch {
        print("  неожиданная ошибка: \(error)")
    }
}

task8Demo()
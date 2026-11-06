//
//  task_3.swift
//  Задание 3. Retry с экспоненциальной задержкой.
//  Запуск: swift task_3.swift
//

import Foundation

enum RetryError: Error, CustomStringConvertible {
    case exhausted(attempts: Int, last: Error)

    var description: String {
        switch self {
        case .exhausted(let attempts, let last):
            return "Не удалось выполнить за \(attempts) попыток; последняя ошибка: \(last)"
        }
    }

    var lastException: Error {
        switch self {
        case .exhausted(_, let last): return last
        }
    }
}

/// Аналог Python-декоратора: принимает функцию и возвращает обёртку с ретраями.
/// В Swift декораторов нет, поэтому реализуем через generic-функцию высшего порядка.
func retryWithBackoff<T>(
    maxAttempts: Int = 3,
    backoffFactor: Double = 2.0,
    shouldRetry: (Error) -> Bool = { _ in true },
    _ operation: () throws -> T
) throws -> T {
    var lastError: Error?
    for attempt in 1...maxAttempts {
        do {
            return try operation()
        } catch {
            guard shouldRetry(error) else { throw error }
            lastError = error
            if attempt < maxAttempts {
                let delay = pow(backoffFactor, Double(attempt - 1))
                Thread.sleep(forTimeInterval: delay)
            }
        }
    }
    throw RetryError.exhausted(attempts: maxAttempts, last: lastError!)
}

// MARK: - Demo

func task3Demo() {
    print("=== Задание 3 ===")

    // Воспроизводимость: простой LCG вместо random()
    var seed: UInt64 = 1
    func pseudoRandom() -> Double {
        seed = seed &* 6364136223846793005 &+ 1442695040888963407
        return Double(seed % 10_000) / 10_000.0
    }

    func flaky() throws -> String {
        if pseudoRandom() < 0.7 {
            throw NSError(domain: "Flaky", code: 1,
                          userInfo: [NSLocalizedDescriptionKey: "случайный сбой"])
        }
        return "ok"
    }

    do {
        let result = try retryWithBackoff(maxAttempts: 3, backoffFactor: 0.01) {
            try flaky()
        }
        print("  результат: \(result)")
    } catch let RetryError.exhausted(attempts, last) {
        print("  RetryError: попыток=\(attempts), последняя=\(type(of: last))")
        print("  исходная ошибка сохранена в .lastException")
    } catch {
        print("  неожиданная ошибка: \(error)")
    }
}

task3Demo()

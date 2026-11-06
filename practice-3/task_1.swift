"""
Задание 1. Иерархия исключений для домена «Заказы».
Запуск: python task_1.py
"""


class OrderError(Exception):
    """Базовое исключение домена заказов."""
    pass


class OrderNotFoundError(OrderError):
    def __init__(self, order_id: str):
        self.order_id = order_id
        super().__init__(f"Заказ '{order_id}' не найден")


class InsufficientStockError(OrderError):
    def __init__(self, product_id: str, requested: int, available: int):
        self.product_id = product_id
        self.requested = requested
        self.available = available
        super().__init__(
            f"Недостаточно товара '{product_id}': "
            f"запрошено {requested}, доступно {available}"
        )


class PaymentFailedError(OrderError):
    def __init__(self, reason: str):
        self.reason = reason
        super().__init__(f"Ошибка оплаты: {reason}")


class InvalidOrderStateError(OrderError):
    def __init__(self, order_id: str, state: str, action: str):
        self.order_id = order_id
        self.state = state
        self.action = action
        super().__init__(
            f"Действие '{action}' недоступно для заказа '{order_id}' "
            f"в состоянии '{state}'"
        )


if __name__ == "__main__":
    print("=== Задание 1 ===")

    try:
        raise OrderNotFoundError("ORD-42")
    except OrderNotFoundError as e:
        print(f"  [1] {e} (order_id={e.order_id})")

    try:
        raise InsufficientStockError("SKU-7", requested=5, available=2)
    except InsufficientStockError as e:
        print(f"  [2] {e} (product_id={e.product_id})")

    try:
        raise PaymentFailedError("карта отклонена")
    except PaymentFailedError as e:
        print(f"  [3] {e} (reason={e.reason})")

    try:
        raise InvalidOrderStateError("ORD-42", state="cancelled", action="ship")
    except OrderError as e:
        print(f"  [4] {type(e).__name__}: {e}")
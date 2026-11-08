class PaymentError(Exception):
    pass


def charge(gateway, account, amount):
    """Charge amount on account. Returns the transaction id."""
    try:
        return gateway.charge(account, amount)
    except PaymentError:
        return None

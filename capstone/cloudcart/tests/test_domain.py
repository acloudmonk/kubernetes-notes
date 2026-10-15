from uuid import UUID

import pytest

from cloudcart.domain import OrderLine, request_fingerprint, validate_lines


PRODUCT_A = UUID("10000000-0000-0000-0000-000000000001")
PRODUCT_B = UUID("10000000-0000-0000-0000-000000000002")


def test_fingerprint_is_independent_of_line_order() -> None:
    first = [OrderLine(PRODUCT_A, 1), OrderLine(PRODUCT_B, 2)]
    second = list(reversed(first))
    assert request_fingerprint(first) == request_fingerprint(second)


@pytest.mark.parametrize(
    "lines",
    [[], [OrderLine(PRODUCT_A, 0)], [OrderLine(PRODUCT_A, 1), OrderLine(PRODUCT_A, 2)]],
)
def test_invalid_lines_are_rejected(lines: list[OrderLine]) -> None:
    with pytest.raises(ValueError):
        validate_lines(lines)

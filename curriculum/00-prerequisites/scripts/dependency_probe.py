"""Probe one configured HTTP dependency using only the Python standard library."""

import os
import sys
import urllib.error
import urllib.request


def main() -> int:
    url = os.getenv("DEPENDENCY_URL")
    if not url:
        print("configuration error: DEPENDENCY_URL is not set", file=sys.stderr)
        return 2

    print(f"probing {url}")
    try:
        with urllib.request.urlopen(url, timeout=2) as response:
            print(f"success: HTTP {response.status}")
            return 0
    except urllib.error.HTTPError as error:
        print(f"http error: {error.code}", file=sys.stderr)
    except urllib.error.URLError as error:
        print(f"connection error: {error.reason}", file=sys.stderr)
    except TimeoutError:
        print("timeout: dependency exceeded 2 seconds", file=sys.stderr)
    return 1


if __name__ == "__main__":
    raise SystemExit(main())

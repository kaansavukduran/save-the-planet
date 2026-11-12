"""Poll through DevTools; page-side string evaluation is correctly blocked by CSP."""
import time
from playwright.sync_api import TimeoutError

def wait_js(page, expression, timeout=30000):
    deadline=time.monotonic()+timeout/1000
    while time.monotonic()<deadline:
        value=page.evaluate(expression)
        if value:
            return value
        page.wait_for_timeout(80)
    raise TimeoutError('JavaScript condition was not met: '+expression)

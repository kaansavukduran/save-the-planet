"""Use the installed browser locally, or Playwright's pinned browser in CI."""
from pathlib import Path
import os
CHROMIUM=os.environ.get('STP_CHROMIUM') or ('/usr/bin/chromium' if Path('/usr/bin/chromium').exists() else None)

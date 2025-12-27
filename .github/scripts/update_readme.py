#!/usr/bin/env python3
"""
Parse Homebrew formulas and update README.md with formula information.
"""

import os
import re
import subprocess
from pathlib import Path
from typing import Dict, Optional


def get_last_commit_date(file_path: Path) -> str:
    """Get the last commit date for a file."""
    try:
        result = subprocess.run(
            ["git", "log", "-1", "--format=%cd", "--date=short", str(file_path)],
            capture_output=True,
            text=True,
            check=True
        )
        return result.stdout.strip() or "Unknown"
    except subprocess.CalledProcessError:
        return "Unknown"


def parse_formula(formula_path: Path) -> Optional[Dict[str, str]]:
    """Parse a Homebrew formula file and extract metadata."""
    try:
        content = formula_path.read_text()

        # Extract class name (formula name)
        class_match = re.search(r'class\s+(\w+)\s+<\s+Formula', content)
        if not class_match:
            return None

        # Extract description
        desc_match = re.search(r'desc\s+"([^"]+)"', content)
        description = desc_match.group(1) if desc_match else "No description available"

        # Extract homepage
        homepage_match = re.search(r'homepage\s+"([^"]+)"', content)
        homepage = homepage_match.group(1) if homepage_match else ""

        # Extract version
        version_match = re.search(r'version\s+"([^"]+)"', content)
        version = version_match.group(1) if version_match else "Unknown"

        # Extract license
        license_match = re.search(r'license\s+"([^"]+)"', content)
        license_info = license_match.group(1) if license_match else ""

        # Get last commit date
        last_updated = get_last_commit_date(formula_path)

        return {
            "name": class_match.group(1),
            "description": description,
            "homepage": homepage,
            "version": version,
            "license": license_info,
            "filename": formula_path.stem,
            "last_updated": last_updated
        }
    except Exception as e:
        print(f"Error parsing {formula_path}: {e}")
        return None


def generate_readme_content(formulas: list) -> str:
    """Generate README.md content with formula information."""
    content = """# homebrew-tap

[vrypan's](https://github.com/vrypan) custom formulae.

## Installation

```bash
brew tap vrypan/tap
brew install <FORMULA>
```

Alternatively: `brew install vrypan/tap/<FORMULA>`

## Available Formulae

<table>
  <thead>
    <tr>
      <th style="background:#f6f8fa; padding:6px 12px; border:1px solid #d0d7de; text-align:left; white-space:nowrap;"><small>Formula</small></th>
      <th style="background:#f6f8fa; padding:6px 12px; border:1px solid #d0d7de; text-align:left;"><small>Version</small></th>
      <th style="background:#f6f8fa; padding:6px 12px; border:1px solid #d0d7de; text-align:left;"><small>Description</small></th>
      <th style="background:#f6f8fa; padding:6px 12px; border:1px solid #d0d7de; text-align:left;"><small>Project Page</small></th>
    </tr>
  </thead>
  <tbody>
"""

    # Sort formulas by name
    formulas.sort(key=lambda x: x["name"].lower())

    for index, formula in enumerate(formulas):
        # Alternate row backgrounds
        row_bg = "#ffffff" if index % 2 == 0 else "#f6f8fa"
        homepage_link = f'<a href="{formula["homepage"]}">GitHub</a>' if formula['homepage'] else ""

        # Append last updated date to description
        description_with_date = f"{formula['description']} <em>(Last updated: {formula['last_updated']})</em>"

        content += f"""    <tr style="background:{row_bg};">
      <td style="border:1px solid #d0d7de; padding:6px 12px; white-space:nowrap;"><small>{formula['filename']}</small></td>
      <td style="border:1px solid #d0d7de; padding:6px 12px;"><small>{formula['version']}</small></td>
      <td style="border:1px solid #d0d7de; padding:6px 12px;"><small>{description_with_date}</small></td>
      <td style="border:1px solid #d0d7de; padding:6px 12px;"><small>{homepage_link}</small></td>
    </tr>
"""

    content += """  </tbody>
</table>

## License

MIT
"""

    return content


def main():
    """Main function to update README.md."""
    # Get repository root
    repo_root = Path(__file__).parent.parent.parent
    formula_dir = repo_root / "Formula"
    readme_path = repo_root / "README.md"

    if not formula_dir.exists():
        print("Formula directory not found!")
        return

    # Parse all formula files
    formulas = []
    for formula_file in sorted(formula_dir.glob("*.rb")):
        formula_data = parse_formula(formula_file)
        if formula_data:
            formulas.append(formula_data)
            print(f"Parsed: {formula_data['filename']} v{formula_data['version']}")

    if not formulas:
        print("No formulas found!")
        return

    # Generate and write README
    readme_content = generate_readme_content(formulas)
    readme_path.write_text(readme_content)
    print(f"\nREADME.md updated with {len(formulas)} formula(e)")


if __name__ == "__main__":
    main()

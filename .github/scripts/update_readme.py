#!/usr/bin/env python3
"""
Parse Homebrew formulas and update README.md with formula information.
"""

import os
import re
from pathlib import Path
from typing import Dict, Optional


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

        return {
            "name": class_match.group(1),
            "description": description,
            "homepage": homepage,
            "version": version,
            "license": license_info,
            "filename": formula_path.stem
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

| Formula | Version | Description | Project Page |
|---------|---------|-------------|--------------|
"""

    # Sort formulas by name
    formulas.sort(key=lambda x: x["name"].lower())

    for formula in formulas:
        homepage_link = f"[GitHub]({formula['homepage']})" if formula['homepage'] else ""
        content += f"| **{formula['filename']}** | {formula['version']} | {formula['description']} | {homepage_link} |\n"

    content += "\n## License\n\nMIT\n"

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

#!/usr/bin/env python3
"""Parse Homebrew formulae and casks and update README.md."""

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


def parse_package(package_path: Path, package_type: str) -> Optional[Dict[str, str]]:
    """Parse a Homebrew formula or cask file and extract metadata."""
    try:
        content = package_path.read_text()

        if package_type == "formula":
            name_match = re.search(r'class\s+(\w+)\s+<\s+Formula', content)
            if not name_match:
                return None
            display_name = name_match.group(1)
        else:
            name_match = re.search(r'cask\s+"([^"]+)"', content)
            if not name_match:
                return None
            display_name = name_match.group(1)

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
        last_updated = get_last_commit_date(package_path)

        return {
            "name": display_name,
            "description": description,
            "homepage": homepage,
            "version": version,
            "license": license_info,
            "filename": package_path.stem,
            "last_updated": last_updated,
            "type": package_type,
        }
    except Exception as e:
        print(f"Error parsing {package_path}: {e}")
        return None


def generate_readme_content(packages: list) -> str:
    """Generate README.md content with package information."""
    content = """# homebrew-tap

[vrypan's](https://github.com/vrypan) custom Homebrew packages.

## Installation

```bash
brew tap vrypan/tap
brew install <FORMULA>
```

Alternatively: `brew install vrypan/tap/<FORMULA>` or `brew install --cask vrypan/tap/<CASK>`

## Available Packages

<table>
  <thead>
    <tr>
      <th style="background:#f6f8fa; padding:6px 12px; border:1px solid #d0d7de; text-align:left; white-space:nowrap;"><small>Package</small></th>
      <th style="background:#f6f8fa; padding:6px 12px; border:1px solid #d0d7de; text-align:left;"><small>Type</small></th>
      <th style="background:#f6f8fa; padding:6px 12px; border:1px solid #d0d7de; text-align:left;"><small>Version</small></th>
      <th style="background:#f6f8fa; padding:6px 12px; border:1px solid #d0d7de; text-align:left;"><small>Description</small></th>
      <th style="background:#f6f8fa; padding:6px 12px; border:1px solid #d0d7de; text-align:left;"><small>Project Page</small></th>
    </tr>
  </thead>
  <tbody>
"""

    # Sort packages by type, then name
    packages.sort(key=lambda x: (x["type"], x["name"].lower()))

    for index, package in enumerate(packages):
        # Alternate row backgrounds
        row_bg = "#ffffff" if index % 2 == 0 else "#f6f8fa"
        homepage_link = f'<a href="{package["homepage"]}">GitHub</a>' if package["homepage"] else ""

        # Append last updated date to description
        description_with_date = f"{package['description']} <br><em>(Last updated: {package['last_updated']})</em>"

        content += f"""    <tr style="background:{row_bg};">
      <td style="border:1px solid #d0d7de; padding:6px 12px; white-space:nowrap;"><small>{package['filename']}</small></td>
      <td style="border:1px solid #d0d7de; padding:6px 12px;"><small>{package['type'].title()}</small></td>
      <td style="border:1px solid #d0d7de; padding:6px 12px;"><small>{package['version']}</small></td>
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
    readme_path = repo_root / "README.md"
    package_dirs = {
        "formula": repo_root / "Formula",
        "cask": repo_root / "Casks",
    }

    if not any(path.exists() for path in package_dirs.values()):
        print("No Formula or Casks directory found!")
        return

    packages = []
    for package_type, package_dir in package_dirs.items():
        if not package_dir.exists():
            continue

        for package_file in sorted(package_dir.glob("*.rb")):
            package_data = parse_package(package_file, package_type)
            if package_data:
                packages.append(package_data)
                print(
                    f"Parsed {package_type}: "
                    f"{package_data['filename']} v{package_data['version']}"
                )

    if not packages:
        print("No packages found!")
        return

    # Generate and write README
    readme_content = generate_readme_content(packages)
    readme_path.write_text(readme_content)
    print(f"\nREADME.md updated with {len(packages)} package(s)")


if __name__ == "__main__":
    main()

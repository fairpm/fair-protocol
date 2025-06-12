# Submitting Packages to a Node

A Package is any zip installed from a Node. This can be a plugin, a theme, a pattern, or even WordPress itself. In order for a Package to be installable, it must be hosted on a Node.

## Automated Checks

Each Node must perform the following automated checks:

* **API compliance:** Confirm the package includes a properly structured readme file (or equivalent metadata) that meets federation formatting standards for discoverability, descriptions, and compatibility tagging.
* **Duplication:** Check whether the same package (by slug or declared name) is already hosted on the Node or discoverable through federation. This prevents duplicate listings and helps maintain namespace clarity.
* **Content integrity:** Validate that the submitted file is in a supported format (e.g., a valid ZIP archive) and contains all required files, such as a main plugin file or theme stylesheet, license declaration, and metadata for blocks.
* **License validation:** Check that the declared license in the readme matches the license included in the package files.
* **Security:** Perform a basic automated security scan at upload time to identify potentially dangerous code, such as known vulnerable patterns, eval misuse, filesystem abuse, or unauthorized remote calls.

In addition, individual Nodes can:
* Scan for use of obfuscation techniques like base64 encoding, ROT13, or unreadable one-liners.
* Look for raw API keys, secret tokens, or OAuth credentials committed in the source.
* Compare submitted author name and plugin slug against known identifiers (DIDs, GitHub handles, etc.).
* Check if the plugin uses syntax or functions unsupported in modern PHP.

## Manual Policy Checks

Once a Node or Plugin passes technical validation, it is subject to a manual policy review by FAIR’s delegated working group to ensure it adheres to federation-wide non-technical standards, including:

* **Copyright compliance:** Review the package for obvious copyright violations or unauthorized redistribution
* **Licensing validation:** Confirm all distributed code claims GPLv2 compatibility or a compatible open-source license (this includes all libraries)
* **Content alignment:** Ensure the submission does not promote illegal content, hate speech, or materials that violate the Node's published ethical standards

## Post-Approval

Once the package passes all checks, it is added to the Node for download and distribution.

Any connected Aggregators will detect the new plugin and return it's information in searches.

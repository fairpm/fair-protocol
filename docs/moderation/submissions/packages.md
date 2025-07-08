# Submitting Packages to a Repository

A Package is any digital file which may be downloaded, installed, or served from a Repository. This may be include:
* **Software:** Software may be in binary or source code form, whether excutable or not.
* **Digital archive files:** File archives may bundle and/or compress multiple files into a single file to be "extracted" into its original form for use. (e.g., .zip, .tar.gz, .rar, etc.)
* **Other content:** Other content may include text, images, media such as audio or video, or other digitally stored information.

Packages do not need to be complete works and do not have to be usable on their own. For example, this would be the case for software extensions to another package or media which requires other software to view its content. Where a package consists of or requires multiple files, it must be made available for download as a single valid archive file.

## Automated Checks

Each Repository must perform the following automated checks:

* **API compliance:** Confirm the package includes a properly structured readme file (or equivalent metadata) that meets federation formatting standards for discoverability, descriptions, and compatibility tagging relative to the type of package being hosted.
* **Duplication:** Check whether the same package (by slug, DID, declared name, or other unique identifier) is already hosted on the Repository or discoverable through federation. This prevents duplicate listings and helps maintain namespace clarity.
* **Content integrity:** Validate that the submitted file is in a supported format and contains all listed or required files, license declaration, and other metadata necessary to its intended use. For example, a package presented as a WordPress plugin must be a single .zip file which includes a GPL v.2-compatible license file as well as properly-formatted PHP file(s) and any Javascript, stylesheets, or other files necessary for the plugin to be installed and function. A package presented as a "code snippet" or software library may be in any appropriate format and need only declare the license under which it is distributed.
* **License validation:** Check that the declared license in the readme file or metadata matches any license document included in the package.
* **Security:** Perform an automated security scan at upload time to identify potentially dangerous code, such as known vulnerable patterns or libraries, malware, filesystem abuse, or unauthorized remote calls.

In addition, software Repositories can:
* Scan for use of obfuscation techniques like base64 encoding, ROT13, or unreadable one-liners.
* Look for raw API keys, secret tokens, or OAuth credentials committed in the source.
* Compare submitted author name and plugin slug against known identifiers (DIDs, GitHub handles, etc.).
* Check if the package uses unsupported syntax or deprecated functions in its program code. (e.g., confirm compatibility with supported versions of PHP or other programming language.)

## Manual Policy Checks

Once a Repository or Package passes technical validation, it is subject to a manual policy review at any time by FAIR’s delegated working group to ensure it adheres to federation-wide non-technical standards, including:

* **Copyright compliance:** Review the package for obvious copyright or trademark violations or unauthorized redistribution.
* **Licensing validation:** Confirm all distributed content is properly licensed for its intended use and does not violate the license terms of any included third-party content (e.g., software libraries).
* **Content alignment:** Ensure the submission does not promote illegal content, hate speech, or materials that violate the Repository's or FAIR's published ethical standards or Code of Conduct.

## Post-Approval

Once the package passes all checks, it is added to the Repository for distribution.

Any connected Aggregators will detect and index the new package in accordance with its own policies, and advertise it for download from the Repository.

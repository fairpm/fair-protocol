# Submitting Nodes to Aggregators

A Node is a server which hosts a variety of packages. In order for a Node's content to be discoverable, it must be added to an Aggregator.

## Automated Checks

Each Aggregator must perform the following automated checks:

* **API compliance:** Verify the Node implements the federation’s standardized API (e.g., for search, metadata, download links)
* **Security headers:** Confirm the Node is served over HTTPS and includes required security headers
* **Content integrity:** Ensure files are served in expected formats (e.g., valid ZIP files with appropriate metadata)
* **Rate limits and uptime:** Test basic responsiveness, rate-limiting behavior, and accessibility

## Manual Policy Check

Once a Node passes technical validation, it is subject to a manual policy review by the Aggregator to ensure it adheres to federation-wide non-technical standards, including:

* **Copyright compliance:**  Reviewing a sample of hosted content to check for obvious copyright violations or unauthorized redistribution
* **Licensing validation:**  Confirming that all distributed code claims GPLv2 compatibility or a compatible open-source license
* **Content alignment:**  Ensuring the submission does not promote illegal content, hate speech, or materials that violate the federation’s ethical standards

* **Clear Guidelines:**  Check that the Node has a published set of submission and listing guidelines.
* **Appeals or Moderation Process (if applicable):**  If the Node accepts public submissions, it should include a process for disputes or moderation transparency.
* **Declaration of Sponsorships or Financial Ties:**  If the Node features sponsored listings, those must be clearly disclosed in metadata.
* **Conduct and transparency:**  Verifying that the operator follows the FAIR Code of Conduct and provides the required public/private contact details
* **Misleading Branding or Identity:**  Confirm the Node is not trying to impersonate known directories or developers (e.g., `wpdotorg-mirror.net` hosted by an unrelated party).

## Post-Approval

Once the Node passes all checks, it is:

* Added to the FAIR Aggregator
* Indexed and made available through WordPress-compatible discovery tools
* Automatically monitored for availability and compliance over time

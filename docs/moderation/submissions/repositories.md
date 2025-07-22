# Submitting Repositories to Aggregators

| <!-- --> | <!-- -->   |
|----------|------------|
| Status   | Proposal   |
| Date     | 2025-07-22 |

A Repository is a server which hosts a variety of packages. In order for a Repository's content to be discoverable, it must be added to an Aggregator.

## Automated Checks

Each Aggregator must perform the following automated checks on the Repositories it wishes to index:

* **API compliance:** Verify the Repository implements the federation’s standardized API (e.g., for search, metadata, download links).
* **Security headers:** Confirm the Repository is served over HTTPS and includes the appropriate security headers.
* **Content integrity:** Ensure files are served in expected formats (e.g., valid ZIP files with appropriate metadata) and does not contain malware.
* **Rate limits and uptime:** Test basic responsiveness, rate-limiting behavior, and accessibility.

## Manual Policy Check

Once a Repository passes technical validation, it is subject to a manual policy review by the Aggregator to ensure it adheres to federation-wide non-technical standards, including:

* **Copyright & trademark compliance:**  Reviewing a sample of hosted content to check for obvious copyright or trademark violations or other unauthorized redistribution.
* **Licensing validation:**  Confirming that all distributed content indicates licensing terms, and where applicable is compatibile for its intended purpose. (e.g., WordPress packages must use the GPL v2 or [compatible license](https://www.gnu.org/licenses/license-list.html) as determined by the Free Software Foundation.)
* **Content alignment:**  Ensuring the submission does not promote illegal content, hate speech, or materials that violate the federation’s ethical standards or Code of Conduct.

* **Clear Guidelines (where applicable):**  For repositories that accept submissions from the public, checking that the Repository has a published set of submission and listing guidelines.
* **Appeals or Moderation Process (if applicable):**  If the Repository accepts public submissions, it should publish its policies and processes for disputes and moderation transparency.
* **Declaration of Sponsorships or Financial Ties:**  If the Repository features sponsored listings or other incentives for promoting specific packages, those must be clearly disclosed in metadata. (For greater clarity, this disclosure requirement does not apply to any fees which may be charged by the Repository to host the package, only to situations where the Repository may derive a benefit, financial or otherwise, from recommending one package over another.)
* **Conduct and transparency:**  Verifying that the operator follows the FAIR Code of Conduct and provides the required public and private contact information.
* **Misleading Branding or Identity:**  Confirm the Repository is not misrepresenting as authentic any content from known directories, developers, or packages. This may include content which is modified or forked but not renamed or fails to disclose the modifications, including attempted supply chain disruption, phishing, or other malware or deceptive practice.

## Post-Approval

Once the Repository passes all checks, it is:

* Added to the Aggregator
* Indexed and made available through compatible discovery tools including browsers and package installers
* Monitored by FAIR for availability and compliance over time

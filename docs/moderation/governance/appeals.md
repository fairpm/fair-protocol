# Appeals Process for FAIR Moderation Decisions

| <!-- --> | <!-- -->   |
|----------|------------|
| Status   | Proposal   |
| Date     | 2025-07-22 |

FAIR aims to foster a just and transparent ecosystem. While our moderation and governance systems are designed to be applied consistently and fairly, we recognize that errors can occur or new information may come to light. This document outlines the appeals process for decisions made by FAIR working groups or through FAIR-operated automated systems (such as the application of certain high-impact labels via the FAIR Labeler Service).

## Purpose of the Appeals Process

The appeals process serves several key functions:

- **Rectify Errors:** To provide a mechanism for correcting mistakes in judgment or application of FAIR policies.
- **Ensure Fairness:** To offer recourse to those who believe a decision made by FAIR was unjust, disproportionate, or based on incomplete information.
- **Improve Policies:** To gather feedback that can help refine FAIR's governance policies and moderation practices over time.
- **Maintain Trust:** To demonstrate FAIR's commitment to accountability and due process within the federation.

## Scope of Appeals Handled by FAIR

This appeals process applies specifically to:

- **Removal or Suspension from FAIR-Operated Services:** Decisions to defederate, delist, or suspend a Repository or Aggregator from a directory or service directly operated by FAIR.
- **Application of Critical FAIR-Issued Labels:** Challenges to specific, high-impact moderation labels (e.g., `fair:threshold:suspended75`, `package:malicious` if disputed) applied by the official FAIR Labeler Service, particularly if these labels result in widespread negative consequences across the ecosystem.
- **Decisions made by FAIR Working Groups:** Formal findings or sanctions issued by a designated FAIR working group related to governance or moderation.

**Important Note:** This process **does not** cover:

- Decisions made by independent Repository operators regarding content they host.
- Decisions made by independent Aggregator operators regarding listings on their services, except where the decision being appealed is the application of a FAIR-issued label.
- General disagreements with FAIR policies. (Policy feedback should be directed through community discussion channels, though an appeal might highlight a policy's unintended consequence.)

Individual Repositories and Aggregators are encouraged, but not required by FAIR, to offer their own appeals or dispute resolution mechanisms for decisions they make independently.

## Who Can Submit an Appeal?

Appeals can be submitted by:

- The primary maintainer(s) of a Repository or Aggregator directly affected by a FAIR decision.
- The primary developer(s), maintainer(s), or copyright holder(s) of a package or other content directly impacted by a critical FAIR-issued label.

## Grounds for Appeal

Valid grounds for an appeal may include, but are not limited to:

- **Factual Error:** The decision was based on incorrect or incomplete information.
- **Misapplication of Policy:** FAIR's policies or guidelines were not correctly applied to the specific case.
- **New Evidence:** Significant new information has become available that could not be presented for consideration in the initial decision.
- **Procedural Irregularity:** A significant flaw in the decision-making process itself, such as a logical error or rendering of a decision that would conflict with another FAIR policy.
- **Disproportionate Action:** The action taken was significantly disproportionate to the issue identified. (In simple terms, "the punishment should fit the crime.")

_Simply disagreeing with the decision is not adequate grounds for appeal: new information or reasoning **must** be presented for consideration based on the valid grounds listed here._

## The Appeals Process

1. **Submission:**
    * Appeals must be submitted via the form or published contact information on the FAIR website specifically addressing moderation requests, dispute resolutions and appeals.
    * The appeal should be submitted within 60 days of the notification of the decision being appealed.

2. **Required Information, in FAIR's Preferred Order:**
    * Appellant's name and contact information.
    * Clear identification of the decision or label being appealed (e.g., Repository URL, DID (if available, else package slug or other identifier), date of decision, specific label).
    * A summary of the grounds for appeal consisting of no more than 300 words.
    * A detailed explanation of the justifiable grounds for the appeal as listed here. When presenting new information, it will be helpful to note why the information was not available during the initial review process.
    * Any available applicable supporting evidence (e.g., logs, screenshots, corrected information).
    * The desired outcome of the appeal.

3.  **Review:**
    * Appeals will be reviewed by a designated FAIR Appeals Working Group, which whenever reasonably possible will be independent of the body that made the initial decision.
    * The Appeals Working Group may request further information from the appellant or other relevant parties.
    * The review process will aim to be completed within 60 days, though complex cases may take longer. Appellants will be kept informed of the progress.

4.  **Decision:**
    * The Appeals Working Group will issue a written decision, outlining the reasons for upholding, overturning, or modifying the original decision.
    * Possible outcomes include:
        * **Appeal Declined for Consideration:** Valid grounds for appeal have not been established.
        * **Appeal Upheld:** The original decision is overturned or modified.
        * **Appeal Partially Upheld:** Parts of the original decision are modified, while others stand.
        * **Appeal Denied:** The original decision stands.
    * The decision of the Appeals Working Group is typically final.

## Transparency and the Appeals Viewer

- Summaries of appeal decisions may at FAIR's discretion be made publicly available to ensure transparency and help the community understand the application of FAIR policies. Published decisions may be anonymized or redacted where appropriate for such reasons as privacy or security.
- As envisioned in the [Ozone Labeling System](../ozone-labeling-system.md) documentation, an "Appeals Viewer" component may be developed. This tool would provide a human-readable interface for tracking the status of appeals and reviewing (potentially signed and verifiable) appeal decisions, possibly by querying the ATProto record graph where appeal outcomes might be logged as label events or signed records.

## Limitations

While FAIR strives for a comprehensive appeals process for its own actions, it cannot compel independent Repository or Aggregator operators to adopt a specific appeals mechanism. Developers or operators interacting with third-party services should consult the policies of those individual services.

---

This document will evolve as the FAIR federation and its governance structures mature.

# Integrity and Transparency Requirements

In a federated ecosystem, maintaining trust requires more than decentralized participation — it demands visible, verifiable integrity. All Nodes and Aggregators must implement safeguards to prevent manipulation of moderation systems, ensuring that reports and enforcement actions remain transparent, tamper-resistant, and auditable.

Without oversight mechanisms, a bad actor could:

- Suppress valid user reports
- Fabricate reports to target competitors
- Block escalation triggers
- Misrepresent moderation activity

To protect against this, the following integrity requirements are mandatory.

## Disclosure of Affiliations and Financial Interests

To ensure the highest level of transparency and allow users to make informed decisions, all participating Nodes and Aggregators must clearly disclose material affiliations, sponsorships, and financial relationships that could influence their operations, content listings, or recommendations.

Open disclosure of these relationships is essential for:

* User Trust: Users can better assess the neutrality and motivations behind listings and recommendations.
* Fair Competition: It prevents hidden advantages and ensures that merit and quality can be more fairly judged.
* Preventing Deception: It guards against practices that could mislead users into believing endorsements are purely organic when they are commercially influenced.

This principle is vital for maintaining user trust and ensuring a level playing field within the FAIR ecosystem.

### Specific Disclosure Requirements:

* **Paid Listings or Preferential Treatment:**
    * **By Aggregators:** If an Aggregator receives payment from a Node for inclusion in its listings, for preferential placement (e.g., "featured," "sponsored"), or for any other form of paid promotion, this relationship **must** be clearly and conspicuously disclosed by the Aggregator.
    * **By Nodes:** If a Node receives payment from a plugin/theme author/developer for hosting their package, for preferential display on the Node, or for any other form of paid promotion, this **must** be clearly and conspicuously disclosed by the Node.
    * In both cases, this disclosure should be visible alongside the relevant listing(s) and in a dedicated, easily accessible section detailing all such arrangements.
* **Sponsorship of Infrastructure or Operations:** If server hosting, significant operational costs, or development are sponsored or paid for by a third-party entity (especially if that entity also participates in or benefits from the FAIR ecosystem, such as a commercial plugin company, hosting provider, or another Node/Aggregator), this sponsorship **must** be disclosed, **naming** the sponsoring entity and the nature of the support provided.
* **Other Material Affiliations:** Any other affiliations or relationships (e.g., common ownership between a Node and an Aggregator, significant investment by an ecosystem participant in another) that could reasonably be perceived by users as a potential conflict of interest or a source of bias **must** be disclosed.

### Method of Disclosure:

Disclosure information must be:

* Clear and Conspicuous: Not hidden in fine print or obscure locations.
* Easily Accessible: Users should not have to hunt for this information.
* Machine-Readable: Where feasible, such disclosures should also be available in a machine-readable format as part of the Node's or Aggregator's metadata API, allowing tools and other services to surface this information. For example, a `sponsored: true` flag or an `affiliations` array in metadata.
* Typically Provided On:
    * A dedicated "About Us," "Disclosure," "Sponsorship," or "Transparency" page on the Node or Aggregator's public-facing website/interface.
    * Directly on or adjacent to listings if the disclosure pertains to a specific item (e.g., a "Sponsored Listing" badge).

### Consequences of Non-Disclosure:

Failure to adequately disclose such material affiliations and financial interests will be considered a breach of FAIR's integrity standards. This may lead to:

* A formal warning from FAIR.
* The Node or Aggregator being flagged as "Lacking Transparency" by FAIR's official Aggregator or other community tools.
* Persistent or egregious non-disclosure may result in a review for suspension or delisting from FAIR's official Aggregator and potential defederation warnings issued to the community.

## Signed and Auditable Logs

All moderation reports must be stored in an append-only, tamper-evident system. Examples include:

- Hashed log files
- Merkle trees
- Signed JSON records

These logs must be available to FAIR and federation auditors and may optionally be mirrored to a trusted third-party archive. Sensitive reporter details (e.g., email, IP address) must be obfuscated to preserve privacy.

## Verifiable Moderation Actions via a Transparency Ledger

To further bolster the integrity of moderation decisions originating from FAIR itself (such as those made by FAIR working groups or through threshold escalations), FAIR aims to implement a "Transparency Ledger" for its significant moderation actions.

This involves:

* **Signed Records:** Key moderation events (e.g., formal warnings, suspensions, delistings initiated by FAIR, or the application of critical FAIR-issued labels) will be recorded as cryptographically signed, verifiable entries.
* **Publicly Auditable:** These signed records can be published to a distributed ledger or a system built on technologies like the AT Protocol graph. This makes FAIR's own moderation interventions transparent and available for public audit.
* **Contribution to System Integrity:** By making its own oversight actions verifiable and difficult to tamper with, FAIR not only ensures accountability for its role but also provides a trusted dataset that other participants in the ecosystem can reference. This complements the requirements for individual Nodes and Aggregators to maintain their own logs.

The mechanisms for creating and distributing these signed moderation records, including how they relate to the broader label-based system, are detailed further in the [Ozone Labeling System documentation](../ozone-labeling-system.md). This approach ensures that even FAIR's own interventions are subject to scrutiny, reinforcing the overall integrity of the federated ecosystem.

## Redundant Submissions and Federation Monitors

To prevent any single entity from unilaterally discarding or suppressing a report, all user-submitted reports must be forwarded through multiple channels. This ensures federation-wide visibility and accountability.

Specifically, reports must be sent to:

- The originating Node (where the plugin/theme is hosted or the Node itself is the subject).
- Any relevant Aggregators listing the item or Node.
- **A recognized Federation Monitor.**

The system must notify the package developer (or Node/Aggregator maintainer, as appropriate) at each significant stage of the report's lifecycle.

### Federation Monitors Explained

A **Federation Monitor** (or "Monitor") is a designated, trusted service whose primary role is to receive a duplicate copy of reports submitted within the FAIR network. This provides an independent record crucial for auditing and verification.

**Key aspects of Federation Monitors:**

- **Requirement for Aggregators:** All Aggregators participating in the FAIR ecosystem **must** be configured to forward copies of relevant reports they process or receive to at least one FAIR-recognized Federation Monitor.
- **Public List of Recognized Monitors:** FAIR will maintain and publish a list of recognized Federation Monitor services. This list will be:
    - Publicly accessible and machine-readable (e.g., via a JSON API endpoint like `GET /fair/v1/monitors`).
    - Provide necessary details for each Monitor, such as its name, report submission API endpoint, and public key if applicable.
- **FAIR's Default Usage:** The official FAIR Aggregator service(s) will utilize FAIR's own designated Federation Monitor service(s). FAIR's Aggregator and other ecosystem tools may flag or indicate Aggregators that are not verifiably connected to a recognized Monitor, signaling a potential risk or lack of full compliance with integrity standards.
- **Purpose:** Monitors serve as an independent receipt point, facilitating audits by FAIR working groups, verifying report acknowledgment, and helping investigate claims of suppression.

This redundant submission architecture, anchored by the Federation Monitor system, is critical for maintaining trust and ensuring that all reports are given due consideration within the federated ecosystem.

## Report Confirmation for Users

Users who submit a report must receive a confirmation token or reference ID. This serves as proof of submission and allows users to track the status of their report.

This confirmation must include:

- A hash or token unique to the report
- A brief summary of what to expect next
- A link to view or follow up on the report (if supported)

## Public Metrics Feed

All Nodes must expose an aggregated, machine-readable report summary including:

- Number of reports by type (e.g., license, security)
- Resolution status (e.g., pending, resolved, dismissed)
- Escalation history

This feed enables Aggregators, watchdogs, and community tools to monitor patterns and detect abuse or neglect.

## Monitoring and Canary Testing

FAIR and its partners may periodically submit test reports to verify:

- Logs are functioning and auditable
- Reports trigger proper escalations
- Federation notifications are delivered

Failure to process these reports correctly may result in defederation or suspension from Aggregators.

## Federation API Compliance

All participants must implement a standardized `/reports` endpoint for federation data exchange. This endpoint must:

- Accept inbound reports from authorized sources
- Return confirmation or status codes
- Be secured against unauthorized or spammy input

Failure to maintain this endpoint will result in a governance review and possible delisting.

---

Robust integrity measures ensure that no participant can operate as a black box. By enforcing transparency, shared responsibility, and verifiable moderation workflows, the FAIR federation protects users and developers alike, while preserving the decentralized ethos at its core.

# Guidelines for Repositories and Aggregators

These foundational guidelines establish the minimum standards for participation in the FAIR ecosystem. While individual Aggregators may choose to impose stricter requirements, no Repository or Aggregator may operate within FAIR if they fail to meet these baseline expectations. Adherence to these guidelines is essential for ensuring a baseline of trust, legal compliance, and ethical participation across the federation.

## 1. Awareness of Ecosystem-Specific Licensing Norms

While the FAIR protocol does not mandate specific software licenses, participants intending to serve particular software ecosystems **must** be aware of respect the established licensing requirements and compatibility norms of those ecosystems.

**Example: WordPress Ecosystem:**

Content intended for integration with WordPress (such as plugins and themes) is widely expected by the WordPress community and its official channels to be licensed under the GNU General Public License v2 (GPLv2) or a [GPLv2-compatible license](https://www.gnu.org/licenses/license-list.html). This is critical for compatibility with WordPress core and aligns with the foundational principles of that ecosystem.

**Consequences of Non-Alignment:**

Repositories distributing content for a specific ecosystem that does not align with that ecosystem's prevailing licensing norms (e.g., distributing non-GPLv2 compatible plugins for WordPress) may find:
 * Their content is not accepted or listed by Aggregators focused on that ecosystem.
 * Their Repository or content is flagged by community tools or labelers as "not recommended" for that specific ecosystem due to licensing incompatibility.
 * They face challenges with user adoption and trust within that target community.

**Repository/Aggregator Responsibility:**

It is the responsibility of Repository and Aggregator operators to understand the licensing expectations of the communities they aim to serve and to set their content and listing policies accordingly. FAIR's role is not to adjudicate complex licensing disputes specific to external projects.

*This guideline encourages good citizenship and practical interoperability within established communities.*

## 2. Compliance with the FAIR Code of Conduct

Operators of both Repositories and Aggregators **must** uphold and, where applicable, enforce the FAIR Code of Conduct. This Code establishes expectations for respectful communication, non-discrimination, harassment prevention, and inclusive collaboration.

* The Code of Conduct applies to all public interactions related to FAIR, including those within review systems, community discussions, and moderation practices connected to the Repository or Aggregator.
* Failure to follow or enforce the Code may result in warnings, review, or defederation by FAIR working groups.

## 3. Adherence to Copyright and Intellectual Property Law

All content hosted by Repositories or indexed by Aggregators **must** comply with applicable copyright and intellectual property (IP) laws. This includes, but is not limited to:

* Not hosting or distributing pirated software or unlicensed forks of software packages.
* Respecting author attribution and licensing terms.
* Responding promptly and appropriately to valid takedown requests (e.g., DMCA notices or equivalent legal processes in relevant jurisdictions).
* Avoiding the unauthorized use of trademarks, branding, or other third-party assets.

Repositories are expected to have a clearly defined copyright complaint process. Aggregators must also be responsive to legitimate IP concerns raised about the content they list or the Repositories they index.

## 4. Transparency and Contact Requirements

To ensure accountability and open communication, all Repositories and Aggregators **must** maintain clear, reliable contact channels and provide transparency in their operations. (See also: [Contact and Privacy](./governance/contact-and-privacy.md) and [Disclosure of Affiliations and Financial Interests](./governance/integrity.md#disclosure-of-affiliations-and-financial-interests)).

* **Minimum Requirements:**
    * **Public Contact:** Each Repository or Aggregator **must** publish easily accessible public-facing contact information (e.g., a name, organization, website, pseudonym, or properly forwarded email alias).
    * **Private Administrative Contact:** Operators **must** maintain private contact details (e.g., an administrative email address or secure contact form) made available to FAIR and other authorized federation participants for:
        * Abuse or security incident coordination.
        * Compliance checks or moderation escalations.
        * Federation audits and integrity verifications.
        * Privacy law investigations.

* **Timely Response Obligation:** Operators are expected to respond in a timely manner to:
    * Legitimate abuse reports (including copyright infringement notices).
    * Inquiries from FAIR working groups or moderation teams.
    * Requests for updates or clarifications from other directory maintainers or federation participants.
* **Appeals Process (Recommended):** If a Repository or Aggregator hosts user-submitted content or makes moderation decisions, they are strongly encouraged, though not strictly required by FAIR for all cases, to have an appeals process for content removals or other moderation actions they take. FAIR itself will have an appeals process for its own decisions (see [Appeals Process](./appeals.md)).

## 5. Technical Interoperability

To ensure seamless operation and compatibility within the federation:

* **Repositories must** implement the current FAIR federated API specification (covering search, metadata, download links, and reporting endpoints).
* **Aggregators must** accurately reflect Repository metadata, including any escalation notices (labels) and current listing status.
* Both Repositories and Aggregators **must** support the standardized `/reports` endpoint and associated review/report escalation workflows as defined by FAIR.

## 6. Report and Removal Transparency

If any plugin, theme, Repository, or Aggregator is removed from a listing by a Repository or Aggregator, or if FAIR issues a defederation notice, a public reason **must** be provided where legally permissible and appropriate. This reason should be available in both human-readable and machine-readable formats. Users and developers should not be left without context for significant changes in listing status or removals. (See also: [Defederation and Removal Policy](./governance/defederation.md)).

## 7. Repository Operator Responsibility for Hosted Content

Repository operators are fully responsible for all content distributed through their services, since they host the code. This responsibility pertains to the provenance, licensing, and integrity of the content as it is stored and distributed by their Repository.

Repository operators are _not_ liable for the behavior of code they host.

* **Scope:** This responsibility covers:
    * Packages (plugins, themes, other software, or content of any type) served via the Repository’s API.
    * Associated metadata (descriptions, images, documentation, changelogs, etc.).
    * Any hosted files made available through discovery tools or client systems originating from the Repository.
* **Key Responsibilities Include:**
    * **Content Vetting & Moderation:** Repository operators **must** have processes to ensure hosted content meets these FAIR guidelines, their own published Repository policies, and applicable local laws.
    * **Security:** Repository operators are expected to monitor for and respond to known security issues or malicious submissions within the content they host.
    * **Accuracy:** Metadata, versioning, and licensing information provided by the Repository for its hosted content **must** accurately reflect the actual content being served.
    * **Removal Compliance:** If content is legitimately flagged or subject to a valid takedown request (e.g., for abuse, licensing violation, copyright infringement, or legal claim), the Repository operator **must** act promptly to address the issue or remove the content as appropriate.
    * **Traceability & Cooperation:** Repositories **must** maintain reasonable audit logs of submissions and publishing events and **must** cooperate with FAIR during authorized investigations. Logs must be retained for not less than 120 days at minimum.

Claims such as “a user uploaded this” or “we just mirrored it without review” do not absolve a Repository operator of their responsibilities for the content they choose to distribute within the FAIR federation. Repository operators who fail to take adequate ownership of their distributed content may be subject to warnings, negative labeling, review by FAIR working groups, or delisting/defederation actions.

## 8. Aggregator Operator Responsibility for Infrastructure and Listings

While Aggregator servers do not host plugin or theme package files directly, they are responsible for the integrity, accuracy, availability, and security of their listing infrastructure and any metadata they aggregate, display, or generate.

* **Key Responsibilities Include:**
    * **Listing Integrity:** Aggregators **must** strive to accurately reflect the content, metadata, and moderation status (including labels) of the Repositories and packages they index.
    * **Infrastructure Maintenance:** Aggregators **must** maintain secure, compliant, and interoperable infrastructure, adhering to FAIR API specifications.
    * **Security Practices:** Aggregators are responsible for contributing to a secure and trustworthy discovery layer.
    * **Transparency of Listing Policies:** Aggregators **must** provide clear public policies on how they select Repositories for inclusion/exclusion and how they curate their listings.
    * **Disclosure of Sponsorship/Affiliation:** Any sponsored listings, promoted placements, or material affiliations **must** be clearly disclosed to users (see [Disclosure of Affiliations and Financial Interests](./integrity.md#disclosure-of-affiliations-and-financial-interests)).
    *   **Timely Updates & Syncing:** Aggregators **must** routinely synchronize with participating Repositories and accurately reflect additions, removals, or changes in status, including acting upon FAIR-issued defederation notices or critical labels.

Aggregators are accountable for the systems, signals, and processes by which content is displayed and discovered through their service. Failure to uphold these responsibilities may result in delisting from FAIR's official Aggregator index, negative labeling, or federation warnings.

## 9. Repository and Aggregator Operators Must Maintain Secure Infrastructure

All participants **must** be diligent in keeping their infrastructure secure, trustworthy, and resistant to tampering.

* **This includes:**
    * Regularly auditing platforms for unauthorized access, manipulation, or misconfigurations.
    * Ensuring metadata integrity, ideally by pulling information directly from verified sources or using cryptographic verification where available.
    * Promptly removing or delisting (for Aggregators) or ceasing distribution of (for Repositories) any content found to be distributing malware, actively exploiting users, or containing unaddressed critical security vulnerabilities.
    * Respecting and acting upon FAIR-issued security advisories, defederation notices, and verified abuse reports.
    * Respecting and acting upon notifications from legal authorities or their representatives regarding infringement or illegal content they host or list.
    * Not facilitating or indirectly enabling the continued availability of unsafe content through negligence or undue delay.

Participation implies a duty to protect users from malicious code, compromised infrastructure, and ecosystem-level threats. Failure to maintain secure systems may result in FAIR investigation, temporary suspension, negative labeling, or defederation.

## 10. Federation Participants Must Not Facilitate Distribution of Harmful or Malicious Content

To protect users and preserve trust, no Aggregator or Repository may knowingly list, distribute, or facilitate access to content that is confirmed to compromise user safety or engage in malicious activities.

* **This includes, but is not limited to:**
    * Packages containing malware, backdoors, undisclosed trackers, or unpatched critical security vulnerabilities.
    * Repositories that consistently or knowingly distribute unpatched, dangerous, or intentionally harmful code.
    * Content authoritatively flagged and verified by FAIR or other widely trusted security bodies as malicious or legally actionable.
* **Responsibilities:**
    * **Aggregators must** delist any Repository or package that is reliably verified to distribute harmful content, even if the Aggregator does not host the code itself.
    * **Repositories must** remove or suspend access to any plugin or theme hosted on their platform that is identified as malicious, imminently dangerous, or in critical violation of federation safety standards.

Failure to act within a reasonable timeframe after credible notification may result in defederation from FAIR systems and removal from federation discovery services. Federation participants are expected to be proactive, not passive mirrors, when faced with credible, verified safety issues.

## 11. FAIR Is Not Responsible for the Actions of Individual Repositories or Aggregators

FAIR operates as a standards body, a provider of default discovery services (e.g., a FAIR-operated Aggregator), an issuer of trust signals (via its Labeler Service), and an oversight facilitator. However, FAIR does not govern or control the internal day-to-day operations of independent federation participants.

* **This means:**
    * Repositories and Aggregators are autonomous and independently operated entities. They are solely responsible for their own actions, the content they distribute or list, their adherence to local laws, and their own terms of service.
    * FAIR provides guidelines, coordination mechanisms, and escalation frameworks but **does not and cannot guarantee** the safety, legality, quality, or functionality of any individual software package or other content, Repository, or Aggregator within the broader federation.
* **FAIR is not liable for:**
    * Harm caused by software or other content obtained from or listed by participating Repositories or Aggregators.
    * The specific inclusion, removal, or moderation decisions made by independent third-party Repository or Aggregator operators.
    * Legal violations or compliance failures by individual federation members.

Each federation participant assumes full responsibility for its own actions and operations. FAIR’s role is primarily advisory, standard-setting, and facilitative, taking no role in legal regulation over independent entities.

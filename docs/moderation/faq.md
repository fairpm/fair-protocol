# Frequently Asked Questions

## What's the difference between a Repository and an Aggregator?

Think of it this way:

* A **Repository** is like a warehouse or a shop that actually *stores and hosts* the plugin/theme packages. Repository operators are responsible for the content on their Repository.
* An **Aggregator** is like a search engine or a catalog that *indexes information* from many different Repositories and Aggregators. It helps users discover plugins and themes but doesn't host the package files itself. Aggregators decide which Repositories they want to list.

You can read more about them in the [FAIR Directory overview](./discovery.md) (or a similar introductory document if you have one defining these).

## If FAIR is decentralized, how are standards or rules enforced?

FAIR's governance framework relies on a combination of:

* **Clearly Defined Policies:** Documents in the [Governance section](./governance/README.md) outline expectations for participants (e.g., regarding integrity, disclosure, contact information).
* **Label-Based:** Services like FAIR's official Labeler (using an [Ozone-based system](./ozone-labeling-system.md)) can apply labels (e.g., "non-compliant," "security-risk") to Repositories or Aggregators that don't meet standards. These labels are visible and can be used by others to make decisions.
* **Federation Monitors:** These services help ensure that reports aren't suppressed, adding a layer of accountability (see [Integrity Requirements](./governance/integrity.md#redundant-submissions-and-federation-monitors)).
* **Aggregator Discretion:** Aggregators can choose not to list Repositories that don't comply with FAIR standards or their own policies.
* **Community Tools:** Tools like the [FAIR WordPress Plugin](./tools/fair-wordpress-plugin.md) can alert users to non-compliant or risky entities.
Enforcement is less about central control and more about transparency, community-driven signals, and informed choices by participants.

## As a developer, how do I get my plugin or theme listed across FAIR?

There's no single central submission point to FAIR itself for plugins; it's a federated process via Repositories and Aggregators. You can find more about the general process in the [Submissions Overview](./submissions/README.md).

The basic process is as follows:

1. **Submit to a Repository:** Find one or more Repositories that accept submissions and submit your package to them, following their specific guidelines. Repositories are not obligated to accept any given package. When a Repository rejects a package due to its guidelines, another with different guidelines may still accept and host it.
2. **Repository Submits to Aggregators (or is already listed):** The Repository operator is then responsible for getting their Repository listed with various Aggregators. If the Repository hosting your package is already listed with Aggregators, your package will become discoverable through those Aggregators once it is indexed.

## What are "Labels" and how do they affect me as a user or developer?

Labels are digital tags applied to plugins, themes, Repositories, or Aggregators by "Labeler Services" (like FAIR's official one or third-party services). These labels provide information or signals about the entity.

* **For Users:** Labels can help you make informed decisions. For example, a plugin might be labeled `plugin:security-vulnerability:active` (warning you of a risk) or `plugin:community-trusted` (a positive signal). The [FAIR WordPress Plugin](./tools/fair-wordpress-plugin.md) will surface these labels as warnings or indicators.

* **For Developers/Operators:** Labels can reflect the status or reputation of your plugin, Repository, or Aggregator. Positive labels can build trust, while negative ones (e.g., `node:non-compliant`) might indicate issues you need to address. Persistent negative labels from reputable labelers could affect your discoverability.

You can learn more about the system in [Ozone Labeling System](./ozone-labeling-system.md) and  Services](./governance-services.md).

## Can I run my own Aggregator? What's involved?

Yes, you can run your own Aggregator. This involves:

1. **Setting up the Aggregator software:** This would be a system capable of indexing metadata from various FAIR Repositories.
2. **Defining your listing policies:** Deciding which Repositories you want to include and your criteria for doing so.
3. **Integrating with Federation Monitors:** You'll need to connect your Aggregator to at least one recognized [Federation Monitor](./governance/integrity.md#redundant-submissions-and-federation-monitors) to comply with FAIR integrity standards.
4. **Implementing disclosure policies:** For example, disclosing any paid listings (see [Disclosure of Affiliations](./governance/integrity.md#disclosure-of-affiliations-and-financial-interests)).
5. **Optionally subscribing to Labeler Services:** To help curate your listings and inform your users.

Running an Aggregator comes with responsibilities to maintain transparency and contribute positively to the ecosystem's health.

## What is a "Federation Monitor" and do I interact with it?

A **Federation Monitor** is a service that acts as an independent, trusted recipient for copies of reports filed within the FAIR network (e.g., reports about plugins, Repositories, etc.). Its main purpose is to ensure reports aren't lost or suppressed by a single Repository or Aggregator.

*  **As a User:** You generally won't interact directly with a Federation Monitor. When you submit a report through a compliant system, a copy should automatically be sent to a Monitor in the background.
*  **As a Repository Operator:** You need to ensure your system forwards reports correctly.
*  **As an Aggregator Operator:** You are *required* to ensure your Aggregator is connected to and forwards relevant report data to at least one recognized Federation Monitor.

You can find more details in the [Integrity Requirements documentation](./governance/integrity.md#redundant-submissions-and-federation-monitors).

## Does this mean FAIR directory searches will be a free-for-all with no quality control?

Not necessarily. While FAIR promotes a broader and more open discovery of plugins and themes, it's not an unmoderated free-for-all. Individual **Aggregators** (which power directory searches) can, and are encouraged to, implement their own listing policies, including subscribing to labels from services like FAIR's official labeler or trusted third-party labelers (see [Ozone Labeling System](./ozone-labeling-system.md) and [Services](./governance-services.md)).

This **does** mean:

* **You choose your experience:** Users and site administrators can often select which Aggregators their WordPress site queries, or their chosen Aggregator may offer filtering based on trust signals.
* **Transparency tools:** Tools like the [FAIR WordPress Plugin](./tools/fair-wordpress-plugin.md) will surface warnings and trust indicators about plugins, themes, Repositories, and Aggregators based on community reporting and official labels.

So, while the *potential pool* of discoverable items is larger, FAIR provides mechanisms for informed choices and for Aggregators to curate their listings.

## Who vets the plugins and themes being added to an individual Repository?

The **Repository owners** are primarily responsible for the content they host and the vetting processes they implement for their Repository. They set their own submission guidelines and are accountable for what they distribute.

FAIR encourages Repository owners to adopt robust vetting practices, and their performance and the quality of their hosted content may be reflected in labels applied by services. Repeatedly hosting problematic content could lead to negative labels and impact the Repository's discoverability or trustworthiness within the federated network.

Repositories are not obligated to host every package submitted to them and are required to [disclose any affiliations and connections of financial interests](./governance/integrity.md#disclosure-of-affiliations-and-financial-interests) for transparency regarding paid listings.

## Who vets adding a Repository to an Aggregator?

**Aggregator owners** have the discretion to decide which Repositories they list. Each Aggregator can establish its own criteria for including a Repository, which involves:

* Technical checks (e.g., API compliance, security headers);
* Reviewing of the Repository's own policies and history;
* Checking for labels applied to the Repository by FAIR or other trusted labelers; and
* Compliance with the Aggregator's terms of service.

Aggregators are not obligated to list every Repository submitted to them and are required to [disclose any affiliations and connections of financial interests](./governance/integrity.md#disclosure-of-affiliations-and-financial-interests) for transparency regarding paid listings.

## So I could make my own Repository with my own plugins and themes?

**Absolutely!** This is one of the core strengths of FAIR – empowering anyone to host and distribute their software. You have full control over your Repository and its content. In fact, FAIR even distributes software that enables you to do this.

However, keep in mind:

* **Aggregator Listing is Not Guaranteed:** While you can run your Repository, individual Aggregators are not required to list it. They will make decisions based on their own policies (as mentioned above).
* **Responsibility:** You are responsible for maintaining your Repository, ensuring its security, and adhering to FAIR's baseline participation requirements (e.g., contact information, API compliance for discovery).
* **Building Trust:** To increase the chances of being listed by Aggregators and trusted by users, consider implementing clear guidelines, robust vetting for any third-party content you might host, and adhering to best practices outlined in FAIR's documentation.

## Could I be sued for what I host on my Repository?

**Yes, potentially.**

As a Repository operator, you are publishing content to the internet. Depending on your jurisdiction and the nature of the content you host, you could face legal liability for issues such as copyright infringement, distribution of malware, or other illegal content if you are found to be responsible for its distribution.

This is why:

* **Clear Guidelines are Critical:** Establishing and enforcing your own clear terms of service and content submission guidelines for your Repository is crucial.
* **Vetting Processes:** Implementing a process for evaluating or vetting content before it's hosted can help mitigate risks.
* **Reporting and Takedown Mechanisms:** Having a clear way for people to report issues with content on your Repository and a process for responding to legitimate takedown requests (e.g., DMCA notices) is essential.
* **Understanding Local Laws:** You should be aware of the laws in your jurisdiction regarding online publishing and liability.

FAIR provides a framework for decentralized distribution, but it does not absolve individual Repository operators of their legal responsibilities. Neither the Linux Foundation nor FAIR itself can be used as a legal shield. There is no guarantee that any package distributed from a federated repository will comply with laws or regulations in your jurisdiction.

## As a Repository operator, what is my liability for the content hosted on my Repository?

This is a critical question, and understanding your responsibilities is key.

**Legal Liability (Copyright, Illegal Content, etc.):**

* **You, as the Repository operator, are generally responsible and potentially liable for complying with all applicable laws in your jurisdiction regarding the content you host.** This includes, but is not limited to:
    * **Copyright Law:** You are responsible for addressing copyright infringement claims (e.g., through DMCA takedown notices or similar legal processes in your region). Hosting copyrighted material without permission can lead to legal action against you.
    * **Other Illegal Content:** Distributing content that is illegal in your jurisdiction (e.g., malware, incitement to violence, child exploitation material) can also result in severe legal consequences for you as the publisher.

**FAIR's View on Accountability (Within the FAIR Ecosystem):**

Within the FAIR protocol's framework, there's a distinction between direct liability for content *behavior* (e.g., a plugin malfunctioning or having a security flaw *after* installation) and accountability for the *systems and processes* around that content on your Repository.

* **Accountability for Systems, Signals, and Processes:**
    * While FAIR's model encourages developers to be responsible for the code they write, **Repository operators are held accountable by the FAIR community and governance for the systems, signals, and processes by which content is submitted, vetted (according to your Repository's policies), displayed, and discovered on your Repository.**
    * This means you are accountable for:
        * Implementing and enforcing your Repository's submission and content guidelines.
        * How you integrate with FAIR's moderation and labeling systems (e.g., applying labels, responding to threshold warnings).
        * Ensuring transparency about your Repository's operations and affiliations.
        * Your processes for handling reported issues or takedown requests.
        * Adhering to FAIR's integrity requirements (e.g., connecting to Federation Monitors).
* **Behavior of Hosted Content:**
    * FAIR's reporting and labeling systems are designed to help identify and flag problematic content *behavior* (like security vulnerabilities or spammy actions) after it's been distributed.
    * If content hosted on your Repository is found to be problematic, your Repository may receive negative labels, and you would be expected to act on such information (e.g., by removing the content or working with the developer, according to your policies and FAIR guidelines). Persistent failure to manage problematic content responsibly can impact your Repository's reputation and standing within the FAIR ecosystem.

**In summary:**

* **Real-world legal liability, especially for copyright and illegal content, rests with you, the Repository operator.** It is crucial to understand and comply with the laws applicable to you.
* **Within FAIR, your accountability focuses on maintaining a trustworthy and transparent Repository environment** through your operational practices, adherence to FAIR principles, and responsible handling of content issues as they are identified.

**Disclaimer:** This FAQ is for informational purposes only and does not constitute legal advice. Repository operators should consult with a qualified legal professional to understand their specific legal obligations and risks.

## Can I run a private Repository or Aggregator that isn't publicly accessible for content? What rules still apply?

Operating a "private" Repository (e.g., for internal company use, a specific closed community, or for testing) or a private Aggregator (e.g., curating a specific set of private Repositories) is entirely permissible within the FAIR framework. You are not obligated to make your hosted content or aggregated listings universally public.

However, even for private instances, certain FAIR participation requirements **still apply** to ensure the overall health, security, and administrative manageability of the federated network. These are primarily:

1. **Contact Information Requirements:**
    * You **must** still provide both **Public Contact** information (which might be the name of your organization or a designated public point of contact, even if the service itself is private) and, crucially, **Private Administrative Contact** details to FAIR.
    * This is essential for FAIR (or other authorized entities) to reach you for critical administrative reasons, such as:
        * Security advisories that might affect your instance.
        * Reports of your Repository/Aggregator potentially being involved in network abuse (even unintentionally).
        * Coordination during federation-wide incidents.
        * Verifying your Repository/Aggregator's operational status if it interacts with any public FAIR services (e.g., if your private Repository still reports to a public Federation Monitor, or if your private Aggregator wants to list *other* public Repositories).
    * (See [Contact and Privacy Requirements](./governance/contact-and-privacy.md) for full details).

2. **Basic Metadata Publication for Verification:**
    * While your *content* can be private, your Repository or Aggregator instance itself (identified by its DID or network address) may still need to publish some basic, non-sensitive metadata for verification and administrative purposes if it is to be recognized at any level by the FAIR network (e.g., if you want it to appear in a list of "known but private" instances for administrative oversight, or if it needs to interact with any FAIR system components).
    * This metadata would typically include things like its operational status, supported FAIR API versions, and its declared operator identity (DID), but not the private content itself. This allows for basic health checks and ensures the instance can be properly identified within administrative tools.

3. **Adherence to FAIR Code of Conduct:**
    * In any interactions your representatives have with the broader FAIR community, FAIR working groups, or official FAIR channels, adherence to the [FAIR Code of Conduct](./governance/guidelines.md#2-compliance-with-the-fair-code-of-conduct) is still expected.

**Why these rules apply to private instances:**

* **Federation Integrity:** Even private instances can (intentionally or unintentionally) impact the network if they are misconfigured or compromised. Being able to contact an operator is key.
* **Security Coordination:** If a vulnerability is discovered that affects the software your private Repository/Aggregator runs, FAIR needs to be able to notify you.
* **Accountability:** Ensures that all entities identifiable within the FAIR operational space can be traced to a responsible party if issues arise.

**What might *not* apply (or apply differently):**

* Public content licensing rules (like GPLv2 compatibility for WordPress plugins) might not be relevant if your content is strictly private and not intended for distribution within those public ecosystems.
* Requirements for public disclosure of affiliations or paid listings might be less relevant if your service is entirely internal and not offering services to the public.

The core principle is that participation in the FAIR network, even in a private capacity, comes with a baseline expectation of contactability and identifiability for essential administrative and security purposes.

## How does FAIR prevent "bad" Repositories or Aggregators from just suppressing reports or negative labels?

FAIR's [Integrity and Transparency Requirements](./governance/integrity.md) are designed to combat this. Key mechanisms include:

* **Redundant Submissions to Federation Monitors:** Reports are sent not just to the Repository/Aggregator but also to independent Federation Monitors, creating an external record.
* **Publicly Verifiable Labels:** labels, especially those from FAIR's official labeler, are often public and can be cryptographically signed.
* **Canary Testing:** FAIR may conduct tests to ensure reporting systems are functioning.
* **Community Oversight:** Tools and public metrics feeds can help the community identify services that appear to be acting in bad faith.
Failure to adhere to these integrity standards can lead to an entity being flagged, delisted from official FAIR services, or publicly noted as non-compliant.

## Where can I get legal advice for operating my Repository or Aggregator?

Operating a Repository or Aggregator involves distributing software and data, which can have legal implications related to copyright, data privacy, terms of service, liability, and other areas. The specific laws and regulations can vary significantly depending on your geographic location, the location of your users, and the nature of the content you handle.

**FAIR, as an organization or protocol, cannot provide legal advice.** The information in this documentation is for informational purposes only and does not constitute legal counsel. Neither FAIR nor the Linux Foundation is able to act as your legal counsel for content you host.

If you have legal questions or concerns about operating your Repository or Aggregator, it is highly recommended that you **consult with a qualified legal professional**.

Here are some suggestions on how to find appropriate legal counsel:

* **Local Bar Associations:** Many regional or national bar associations offer referral services that can help you find lawyers specializing in relevant areas such as:
    * Technology Law
    * Intellectual Property Law (especially copyright and software licensing)
    * Internet Law
    * Data Privacy Law (e.g., GDPR, CCPA, PIPEDA)
    * Business Law

* **Lawyers Specializing in Open Source Software:** Some lawyers and law firms specialize in legal issues surrounding free and open source software (FOSS). Searching for legal professionals with this specific expertise might be beneficial, especially concerning licensing.

* **Organizations Supporting Digital Rights or Open Source:** While they may not provide direct legal counsel to individuals or businesses in all cases, organizations like:
    * The Electronic Frontier Foundation (EFF)
    * The Software Freedom Law Center (SFLC)
    * Local digital rights groups may have resources, guides, or be able to point you towards lawyers who work in these areas. Some may offer clinics or pro bono services for specific types of cases or clients (often non-profits).

* **Referrals:** If you know other individuals or organizations operating similar services, they might be able to refer you to legal professionals they have worked with.

When seeking legal advice, be prepared to discuss the specifics of your Repository or Aggregator, the types of content you plan to host or index, your target audience, and your operational practices. A legal professional can help you understand your specific rights and responsibilities, draft appropriate terms of service and privacy policies, and navigate any legal challenges that may arise.


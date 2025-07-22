# FAIR's Label-Based Moderation System with Ozone

| <!-- --> | <!-- -->   |
|----------|------------|
| Status   | Proposal   |
| Date     | 2025-07-22 |

To effectively manage content and behavior in a decentralized ecosystem like FAIR, we employ a label-based moderation system. This system is designed to be flexible, transparent, and community-driven, leveraging tools and concepts from the AT Protocol ecosystem, primarily **Ozone**.

This document details how FAIR utilizes Ozone to create a shared, open label system for Repositories, Aggregators, Plugins, and Themes, enabling verifiable moderation decisions and supporting a diverse trust infrastructure.

## What is Ozone?

[Ozone](https://github.com/bluesky-social/ozone) is a composable moderation service developed by Bluesky for the AT Protocol. It serves as a tool that helps communities manage what content is visible or hidden in a decentralized network.

In systems like FAIR, where there’s no single central authority, anyone can publish content or run a service. Ozone provides a mechanism for trusted organizations or individuals to "label" content, accounts, or services with descriptive tags (e.g., “safe,” “unverified,” “spam,” “malicious”).

Key characteristics of Ozone:

- **Labels as Guidance:** These labels do not delete content from the underlying network. Instead, they act as signals or guidance that applications, users, or directory services (like FAIR Aggregators) can choose to interpret and act upon based on their own policies and preferences.
- **Community-Powered:** It facilitates a form of community-powered moderation. If a Repository is known for distributing insecure plugins, FAIR (or another trusted entity acting as a "labeler") can apply relevant labels to that Repository.
- **Public and Transparent:** Labels and the identity of the labeler are generally public, allowing for transparency and accountability.
- **Pluggable Labelers:** The system allows for multiple entities to issue labels. Clients and services can then decide which labelers they trust and whose labels they wish to subscribe to.

## Ozone + FAIR: A Natural Fit

The philosophy behind Ozone aligns well with FAIR's goals for a decentralized ecosystem:

- **Decentralized Trust:** It enables trust to be built and managed in a distributed manner, rather than relying on a single point of control.
- **Preserves Openness:** It allows the federation to remain open and independent while still providing tools for users and developers to protect themselves and curate their experience.
- **Verifiable Decisions:** Moderation actions, when represented as signed labels, can be reviewed and potentially appealed, fostering transparency.
- **No Monoculture:** It supports multiple moderation viewpoints, as different services can choose to subscribe to different labelers or interpret labels differently.

## How FAIR Uses Ozone

FAIR will leverage Ozone's capabilities in the following ways:

1. **FAIR as a Labeling Authority:**
    * FAIR (or designated working groups within FAIR) will operate one or more "labeler" services built upon Ozone.
    * These services will issue labels relevant to the FAIR ecosystem, such as:
        * `package:malicious`
        * `package:unverified`
        * `package:deprecated`
        * `repository:insecure`
        * `repository:non-compliant`
        * `aggregator:compliant`
        * `author:verified`
        * `fair:verified`
    * These and other labels will be publicly queryable and attached to the Decentralized Identifiers (DIDs) of Repositories, Aggregators, or developer identities.

2. **Transparency Ledger for Moderation Actions:**
    * FAIR’s working groups (e.g., for Security, Vetting, or future Appeals) could publish signed moderation records as ATProto data.
    * Each significant moderation event (e.g., a warning issued, a suspension, a guideline violation finding) becomes a verifiable label event, potentially including metadata about the decision. This contributes to the integrity of the moderation process (see also [Integrity and Transparency Requirements](./governance/integrity.md)).

3. **Aggregator-Level Enforcement and Filtering:**
    * FAIR Aggregators, and potentially third-party aggregators, can choose which labelers to trust (e.g., FAIR's official labeler or other community-recognized labelers).
    * Based on subscribed labels, Aggregators can implement their filtering policies (e.g., hide items labeled `package:malicious`, warn about `repository:insecure`, or boost `author:verified` content). This maintains federation while allowing directories to apply moderation in a composable, client-controlled way.

_End users may choose to subscribe to Aggregators which best align with their own moderation preferences._

## Integrating FAIR's Threshold-Based Reporting with Ozone Labels

FAIR’s [Vetting and Reporting](./governance/vetting-and-reporting.md) system outlines a threshold-based mechanism for escalating actions based on community reports (e.g., warnings at 25% report threshold, suspension at 75%).

Ozone itself does not implement threshold-specific rules directly within its core protocol, providing only the labeling mechanism. To integrate FAIR's logic, we will:

1. **Build a FAIR-Specific Labeler Service:** This service will use Ozone's infrastructure but incorporate FAIR’s specific reporting and escalation logic.
2. **Monitor Report Metrics:** The FAIR labeler will track report volume and the percentage of active users reporting an item, as defined in the reporting policy.
3. **Apply Escalation Labels:** Based on the defined thresholds, the FAIR labeler will automatically apply specific, clearly defined labels, such as:
    * `fair:threshold:warning25` (when 25% threshold is met)
    * `fair:threshold:notice50` (when 50% threshold is met)
    * `fair:threshold:review60` (when 60% threshold is met, signaling need for manual review)
    * `fair:threshold:suspended75` (when 75% threshold is met)
4. **Actioning Escalation Labels:** These `fair:threshold:*` labels will then be used by:
    * **Aggregators:** To automatically show/hide content, display warnings, or temporarily delist items.
    * **Package Installers (e.g., Clients like the FAIR Plugin for WordPress):** To notify end-users and site administrators of the status of plugins/themes or Repositories they interact with.
    * **FAIR Review Dashboards:** To alert FAIR working groups to items requiring manual review or decision-making.
5. **Audit Log:** Optionally, the FAIR labeler service will write to a publicly auditable log (e.g., as ATProto repository posts or signed JSON records) each time a threshold-based label is applied, further enhancing transparency.

## Supporting Technical Components

To implement this label-based moderation system effectively, several technical components will build upon or extend AT Protocol services:

- **Labeler Service:** The core FAIR moderation engine, based on Ozone, responsible for applying labels based on policies and reports.
- **Package/Repository Registry:** A system for cataloging and uniquely identifying (e.g., via DIDs) packages or other content, Repositories, and Aggregators so they can be accurately labeled. This will likely involve defining specific ATProto record types for these entities.
- **Moderation Policy Gateway:** An interface or mechanism (potentially extending ATProto relay or indexing layers) that allows Aggregators and other services to discover and subscribe to FAIR-aligned labelers.
- **(Future) Appeals Viewer:** A human-readable interface for reviewing moderation decisions and managing disputes, querying the ATProto record graph for label events (to be detailed in a future appeals process document).

By implementing this Ozone-based labeling system, FAIR aims to establish a robust, transparent, and adaptable moderation infrastructure that supports the health and trustworthiness of the entire decentralized ecosystem.

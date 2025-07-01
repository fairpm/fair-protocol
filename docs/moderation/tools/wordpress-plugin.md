# FAIR WordPress Plugin: Integrating Moderation and Trust Signals

The FAIR WordPress Plugin extends a standard WordPress installation to interact with the FAIR decentralized ecosystem. While its primary function is to enable WordPress sites to use FAIR services as a source for plugins and themes (details available at [https://github.com/fairpm/fair-plugin](https://github.com/fairpm/fair-plugin)), this document focuses on its crucial role in integrating moderation data and trust signals from the FAIR network directly into the WordPress admin experience.

The plugin acts as an intelligent client, consuming data from Federation Monitors, Labeler Services, and Aggregators to provide site administrators with timely warnings, contextual information, and clear indicators about the status and trustworthiness of the software and services they interact with.

## Core Moderation Integration Features

The FAIR WordPress Plugin actively participates in the ecosystem's integrity by:

1. **Consuming Federation Monitor Data:**
    * It regularly fetches or is updated with information regarding Aggregators' compliance with connecting to recognized [Federation Monitors](../../governance/integrity.md#federation-monitors-explained).
    * This data is used to assess the reliability and transparency of Aggregators.

2. **Processing Labels from Labeler Services:**
    * The plugin subscribes to or queries labels from FAIR's official Labeler Service and potentially other user-configured or community-trusted labelers (see [Ozone Labeling System](../../ozone-labeling-system.md) and [Moderation Services](../../governance/moderation-services.md)).
    * It interprets these labels to understand the status of plugins, themes, Repositories, and Aggregators (e.g., `fair:threshold:suspended75`, `Repository:insecure`, `plugin:malicious`, `aggregator:compliant`).

3. **Surfacing Trust Signals in the WordPress Admin:**
    * Instead of just presenting a list of plugins or themes, the plugin enhances listings and detail views with visual cues and textual alerts based on the moderation data it has processed.

## Displaying Trust Signals and Alerts

The plugin aims to provide clear, actionable information to the WordPress site administrator. Examples of alerts and indicators include:

* **Aggregator Status Alerts:**
    * **"This Aggregator is not connected to a recognized Federation Monitor - HIGH RISK"**: Displayed if an Aggregator the site is configured to use (or one being browsed) does not have a verified connection to a Federation Monitor, as per data from FAIR's public monitor list. This indicates a potential lack of transparency in its reporting mechanisms.
    * **"This Aggregator has limited moderation tool integration - CAUTION"**: Displayed if an Aggregator is not subscribing to key labelers or has not declared clear moderation policies.

* **Repository Status Alerts:**
    * **"This Repository is currently blocked/defederated by FAIR - CRITICAL RISK"**: Shown when a Repository has been issued a critical label by FAIR's official Labeler Service (e.g., `fair:defederated` or `fair:threshold:suspended75`) indicating severe or unresolved issues. Interactions with this Repository (e.g., downloads, updates) may be restricted or heavily warned against.
    * **"This Repository has outstanding unresolved critical reports - HIGH RISK"**: If labels indicate a high volume of unresolved critical issues.

* **Plugin/Theme Status Alerts:**
    * **"This plugin has unresolved critical security reports - HIGH RISK"**: Based on labels like `plugin:security-vulnerability:active`.
    * **"This theme is marked as deprecated by its author - CAUTION"**: Based on labels like `theme:deprecated`.
    * **"Community Warning: This item has numerous user reports pending review."**: Based on threshold labels like `fair:threshold:notice50`.

These alerts will be contextually displayed, for example, within the plugin/theme browser, on update screens, or on specific Repository/Aggregator information pages within the WordPress admin area.

## Dynamic Trust Assessment and Updates

The FAIR WordPress Plugin dynamically updates its assessment of entities within the FAIR network:

- **Aggregator Trust:** The plugin will periodically refresh its list of available Aggregators, enriching this list with status information derived from Monitor checks and labels. Aggregators deemed "untrusted" (e.g., not connected to a Monitor, or labeled as problematic) may be visually deprioritized, flagged, or, in severe cases, the plugin might suggest not using them.
- **Repository, Plugin, and Theme Trust:** Similarly, the perceived trustworthiness of Repositories, plugins, and themes is continuously updated as new labels are discovered. This ensures that the WordPress admin has the most current information available when making decisions about installing, updating, or trusting software.

The plugin provides a crucial layer of defense and awareness for end-users, translating the abstract concepts of decentralized moderation and trust into tangible, understandable information within their daily workflow.

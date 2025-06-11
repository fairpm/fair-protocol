#  Vetting and Reporting

To ensure trust and quality in the decentralized ecosystem, all Nodes and Aggregators must include a transparent, community-driven reporting mechanism. This system enables nodes to self-manage their content while remaining accountable to the broader federation.

## What Can Be Reported

Reports may be filed for issues including, but not limited to:

- Known or suspected security vulnerabilities
- Spam or deceptive practices
- License and/or Copyright violations
- Malicious behavior or unauthorized tracking
- Broken, deprecated, or non-functional code
- Deprecated or broken content (from your original list, ensuring comprehensive coverage)
- Security issues (general term, covered by specific points but good to keep if desired for emphasis)
- Spam or abuse (general term, covered by specific points but good to keep if desired for emphasis)

While everyone should be free to submit and host repositories, safeguards are essential to identify and respond to malicious or negligent behavior.

## Required Reporting Features

Each Node and Aggregator must implement easily accessible reporting features:

- **Nodes:** Must provide features visible within the WordPress admin interface:
    - "Report Plugin/Theme"
    - "Report Node"
- **Aggregators:** Must include additional reporting features:
    - "Report Node"
    - "Report Aggregator"

These reporting tools must be available from both listing and detail views for plugins, themes, Nodes, and Aggregators.

## Reporting Controls (Eligibility and Safeguards)

To prevent abuse of the reporting system, only users with meaningful recent interaction are eligible to submit valid reports. Specifically:

- **For plugins and themes:** The user must have installed the item on the same site from which they are submitting the report.
- **For Aggregator and Node-level reports:** The user must have downloaded at least one item from that Node within a recent, defined window.

Additional safeguards include:

- Reports from users who downloaded but never activated a plugin (as determined by `wp_options` data) will be automatically rejected, with an optional message explaining why.
- Users who attempt to report a Node or Aggregator without any recorded downloads from that source will also be prohibited from reporting.

These requirements ensure that only credible reports based on real experience are considered.

## Threshold-Based Escalation System

Valid reports contribute toward a threshold system that escalates actions based on community response levels. This ensures proportional, consistent handling of potential issues. Threshold percentages are based on the number of active users for the plugin, theme, or Node in question.

### Reporting Actions by Threshold

- **25%:**
    - Automated warning recorded and shown in system logs.
- **50%:**
    - Warning displayed on all relevant listings.
    - Reports forwarded to directory aggregators.
    - “Community Notice” badge shown.
- **60%:**
    - “Community Notice” escalates to a visible Warning.
    - FAIR working group is alerted for manual review.
- **75%:**
    - Automated temporary suspension from Node and Aggregators, pending FAIR decision.

Note on Implementation: These threshold-triggered actions, such as warnings, notices, and suspensions, are implemented and propagated across the decentralized network as "labels." These labels are applied to the relevant Node, Aggregator, plugin, or theme. For a detailed explanation of how this labeling system works, including its basis on systems like Ozone, please see the [Ozone Labeling System documentation](../ozone-labeling-system.md).

## FAIR Oversight

A FAIR working group will serve as the oversight body responsible for upholding federation-wide standards, fairness, and integrity. There will be one parent group and, optionally sub-groups for Nodes, Aggregators, and packages.

Upon escalation, the appropriate FAIR working groups will:

- Investigate the reported item using community input, logs, and technical evaluation.
- Contact Node operators or maintainers for context and possible remediation.
- Decide whether to delist, suspend, or reinstate content, Nodes, or Aggregators based on findings.

This system balances openness with accountability, enabling community-led moderation without reverting to centralized control or bottlenecks.

---

See: [Reporting Integrity](./integrity.md)

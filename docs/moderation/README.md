# Moderation in the FAIR Ecosystem

| <!-- --> | <!-- -->   |
|----------|------------|
| Status   | Proposal   |
| Date     | 2025-07-22 |

Decentralization brings power, resilience, and freedom — but it can also bring complexity, fragmentation, and new risks. In a system like FAIR, where anyone can run a Repository or Aggregator and distribute themes, plugins, or metadata across the ecosystem, the absence of centralized control means that trust must be built and maintained collaboratively.

This section outlines FAIR's approach to moderation, detailing the philosophy, tools, and processes designed to foster a healthy and trustworthy decentralized network.

**A note about terminology:** As used herein, "FAIR" refers to the FAIR Package Manager Project, or contextually, its specifications, policies, or working groups. When used with normal capitalization, "Fair" and "fair" should be understood as normal use of the word.

## Key Challenges in Decentralized Moderation

The FAIR moderation framework is designed to address inherent challenges in decentralized systems, including:

- **No single gatekeeper:** The absence of a central authority to approve or reject content.
- **Risk of malicious actors:** The ease with which rogue Repositories can be created or known-vulnerable packages can be re-hosted.
- **Inconsistent practices:** Potential for varied moderation standards and enforcement between independent Repositories and aggregators.
- **Lack of universal methods:** The need for standardized ways to flag, label, or address problematic content across the federation.

In centralized systems, abuse reports and content reviews flow to a single authority. However, in federated systems like FAIR, that model doesn’t scale nor does it align with the values of openness and autonomy. Instead, FAIR requires composable, verifiable, and decentralized moderation infrastructure.

## Our Philosophy: Moderation as Infrastructure, Not Censorship

The goal of moderation within FAIR is not to limit expression but to build trust. We aim to create an ecosystem where users, developers, and directory operators can act independently yet responsibly. Our moderation tools and systems are intended to provide federation participants with the ability to:

- Flag known malicious or harmful content.
- Label Repositories, packages or other content, and aggregators with meaningful trust signals (e.g., “verified,” “deprecated,” “security-risk”).
- Enable Aggregators to apply transparent and consistent filtering based on community-defined criteria.
- Offer users control over the moderation standards they subscribe to and follow.

Ultimately, moderation tools in FAIR are about enabling trust in a decentralized network, not about gatekeeping.

## Services Offered by FAIR

FAIR will run the following:

1. A Discovery Service
2. A WordPress.org Mirror Aggregator
3. A Moderation Service (to apply labeling)

FAIR may, in the future, opt to host a basic Aggregator where people can submit their Packages to be hosted.

## Exploring Moderation Topics

This directory contains detailed information on various aspects of moderation within the FAIR protocol:

- **[Discovery](./discovery.md):** How moderation signals impact the discoverability of Repositories and packages.
- **[Submissions](./submissions/README.md):** Processes and checks for submitting content to Repositories and Repositories to aggregators, including initial technical and manual reviews.
- **[Governance](./governance/README.md):** The framework of rules, responsibilities, and policies that underpin moderation and participation in the FAIR ecosystem. This includes vetting, reporting, integrity, and defederation policies.
- **[Ozone Labeling System](./ozone-labeling-system.md):** The technical foundation for how FAIR implements a shared, open label system for content and services.
- **[Contact and Privacy](./governance/contact-and-privacy.md):** Requirements for contactability and data privacy for Repository and aggregator operators, which is essential for accountability in moderation.

By providing these tools and guidelines, FAIR aims to support a robust, transparent, and flexible moderation layer that empowers all participants to collaborate on safety and quality without sacrificing the core principles of a decentralized web.

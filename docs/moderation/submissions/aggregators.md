# Submitting Aggregators to a Discovery Service

A Discovery Service is a higher-level directory that lists and indexes multiple Aggregators into a unified, federated search experience. It allows ecosystem stakeholders—like hosting companies, CMS vendors, or large developer communities to curate and serve content from multiple trusted sources grouped into a single interface, API, or feed.

## Example Use Case

Let’s say **Hosting Company A** partners with **Dev Company 1** and **Dev Company 2.** Each of the dev companies runs their own Aggregator, listing packages from various Repositories they trust. Hosting Company A can build a Discovery Service that combines both Aggregators into a single interface or API, allowing end users to search across all included packages from both Aggregators at once. Hosting Company A may also add its own custom plugins or themes by maintaining a Repository and Aggregator of its own, either public or private.

This model enables the federation to scale **horizontally**, with many organizations creating trusted views of the ecosystem based on their needs and priorities while still aligning with FAIR’s shared standards and moderation labels.

## Automated Checks

Before an Aggregator is accepted to a Discovery Service, it must pass the following compliance checks:

* **API compliance:** The Aggregator must fully implement the FAIR’s standardized API, including endpoints for search, metadata, and download resolution.
* **Moderation compliance:** The Aggregator must implement the FAIR moderation guidelines, including reporting mechanisms.
* **Security headers:** The Aggregator must be served over HTTPS and must include all required security headers (e.g., `Content-Security-Policy`, `X-Content-Type-Options`).
* **Repository integrity:** The Aggregator must only include Repositories that are compliant with FAIR guidelines. Aggregators found to be listing defederated or non-compliant Repositories may be rejected or flagged.
* **Rate limits and uptime:** The Aggregator must meet baseline performance standards for uptime and responsiveness, and implement reasonable rate-limiting or caching strategies to avoid abuse.

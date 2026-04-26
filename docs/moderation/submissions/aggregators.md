# Submitting Aggregators to a Discovery Service

| <!-- --> | <!-- -->   |
|----------|------------|
| Status   | Proposal   |
| Date     | 2025-07-22 |

A Discovery Service is a higher-level directory that aggregates multiple Aggregators into a unified, federated search experience. It allows ecosystem stakeholders—like hosting companies, CMS vendors, or large developer communities—to curate and serve content from multiple trusted sources under one roof.

## Example Use Case

Let’s say **Hosting Company A** partners with **Dev Company 1** and **Dev Company 2.** Each of the dev companies runs their own Aggregator, listing packages from various Repositories they trust. Hosting Company A can build a Discovery Service that combines both Aggregators into a single interface or API, allowing end users to search across all included packages. Hosting Company A may also add its own custom plugins or themes by maintaining a Repository and Aggregator of its own.

This model enables the federation to scale **horizontally**, with many organizations creating trusted views of the ecosystem based on their needs and priorities—while still aligning with FAIR’s shared standards.

## Automated Checks

Before an Aggregator is accepted into a Discovery Service, it must pass the following automated compliance checks:

* **API compliance:** The Aggregator must fully implement the federation’s standardized API, including endpoints for search, metadata, and download resolution.
* **Security headers:** The Aggregator must be served over HTTPS and must include all required security headers (e.g., `Content-Security-Policy`, `X-Content-Type-Options`).
* **Repository integrity:** The Aggregator must only include Repositories that are compliant with FAIR federation guidelines. Aggregators found to be listing defederated or non-compliant Repositories may be rejected or flagged.
* **Rate limits and uptime:** The Aggregator must meet baseline performance standards for uptime and responsiveness, and implement reasonable rate-limiting or caching strategies to avoid abuse.

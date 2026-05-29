# Registry

This document is a registry for the known extensions to the FAIR Package Management Protocol, along with defined package and artifact types.

## Extensions

| Name                                         | Contact            |
| -------------------------------------------- | ------------------ |
| [FAIR Authentication Methods](./ext-auth.md) | FAIR Working Group |
| [FAIR for WordPress Packages](./ext-wp.md)   | FAIR Working Group |
| [FAIR for TYPO3 Packages](./ext-typo3.md)    | FAIR Working Group |


## Package Types

| Type              | Extension                                  | Contact            |
| ----------------- | ------------------------------------------ | ------------------ |
| `wp-core`         | [FAIR for WordPress Packages](./ext-wp.md) | FAIR Working Group |
| `wp-plugin`       | [FAIR for WordPress Packages](./ext-wp.md) | FAIR Working Group |
| `wp-theme`        | [FAIR for WordPress Packages](./ext-wp.md) | FAIR Working Group |
| `typo3-core`      | Reserved for future use.                   | FAIR Working Group |
| `typo3-extension` | [FAIR for TYPO3 Packages](./ext-typo3.md)  | FAIR Working Group |
| `typo3-theme`     | Reserved for future use.                   | FAIR Working Group |

## Authentication Methods

| Method   | Extension                                    | Contact            |
| -------- | -------------------------------------------- | ------------------ |
| `bearer` | [FAIR Authentication Methods](./ext-auth.md) | FAIR Working Group |
| `basic`  | [FAIR Authentication Methods](./ext-auth.md) | FAIR Working Group |
| `oauth2` | [FAIR Authentication Methods](./ext-auth.md) | FAIR Working Group |


## Entitlement Types

The "Typical proof lifetime" column is non-normative guidance for vendors choosing the JWT `exp` claim on [entitlement proofs](./specification.md#entitlement-proof). Vendors MAY use any lifetime appropriate to their entitlement model; the spec does not impose a maximum.

| Type                | Description                                             | Typical proof lifetime                          |
| ------------------- | ------------------------------------------------------- | ----------------------------------------------- |
| `subscription`      | Active subscription required to access the package.     | Days to one billing cycle (e.g., 1–30 days)     |
| `purchase`          | One-time purchase required to access the package.       | Long-lived (months); refresh on revocation only |
| `license-key`       | Valid license key required to access the package.       | Up to the licence's own expiry                  |
| `free-registration` | Free to use, but requires registration with the vendor. | Long-lived (weeks to a year)                    |

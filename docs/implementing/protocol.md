## FAIR Protocol Overview

The FAIR (Federated and Independent Repositories) Package Management Protocol is a system for distributing installable software (like plugins or themes) in a decentralized, secure, and portable way. It is designed to allow anyone to publish, discover, and install packages, without relying on a single central repository.

The [full specification](../../specification.md) and [WordPress-specific extension](../../ext-wp.md) is available.

The following is an overview of the protocol.

### Key Concepts

- **DID (Decentralized ID):** Every package has a unique, globally resolvable identifier (DID), which points to its metadata and repository.
- **Repository:** A server that hosts packages and their metadata.
- **Aggregator:** A service that collects and indexes package data from multiple repositories (e.g., for search or moderation).
- **Client:** The tool or application that installs and manages packages for users.
- **Vendor:** The publisher of a package.

### Main Flows

1. **Discovery:** Users search for packages using aggregators.
2. **Installation:** Clients resolve a package’s DID, fetch its metadata from the repository, select a release, download the package, and verify its signature.
3. **Updating:** Clients check for new releases by resolving the DID and comparing available versions.

### DID Resolution

- Packages are identified by DIDs (using the `plc` or `web` methods).
- The DID Document specifies the repository URL and valid signing keys.
- Clients must revalidate DID Documents at least every 24 hours.

### Metadata Document

- Each package has a Metadata Document (JSON-LD) with:
  - `id`: The package’s DID.
  - `type`: The package type (e.g., plugin, theme).
  - `license`: SPDX license or "proprietary".
  - `authors`: List of authors.
  - `security`: Security contacts.
  - `releases`: List of available releases.
  - Optional: `slug`, `name`, `description`, `keywords`, `sections`.

### Release Document

- Each release describes:
  - `version`: The release version (uses Semantic Versioning).
  - `artifacts`: Files/assets for the release (e.g., zip files, images).
  - Optional: `provides`, `require`, `suggest`, `auth`.

#### Artifacts

- Each artifact can specify:
  - `id`, `content-type`, `requires-auth`, `url`, `signature`, `checksum`.
- The main artifact is usually the installable package file.

#### Dependencies

- `requires`: Other packages or environment requirements needed.
- `suggest`: Recommended additional packages.

#### Authentication

- Some packages or artifacts may require authentication (e.g., for paid plugins).
- The `auth` property specifies the method and user-facing hints.

### Security

- Package signatures are verified using keys from the DID Document.
- Only packages signed by valid keys are accepted.


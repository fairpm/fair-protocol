# FAIR Package Management Protocol

FAIR (Federated and Independent Repositories) Package Management Protocol is a system for distributing installable software.

This specification defines the core FAIR protocol ("FAIR Core"). Ecosystem-specific extensions are implemented as extensions to this specification, as defined in the [extension registry](./registry.md).


## Definitions

Full definitions and usage conventions for terms used in this specification are in [terminology.md](./terminology.md). Key terms include [Aggregator](./terminology.md#def-aggregator), [Client](./terminology.md#def-client), [DID](./terminology.md#def-did), [Package](./terminology.md#def-package), [Publisher](./terminology.md#def-publisher), [Repository](./terminology.md#def-repository), and [User](./terminology.md#def-user).

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in [RFC 2119](https://www.rfc-editor.org/rfc/rfc2119).

The term *vendor* is retired. Read *[Publisher](./terminology.md#def-publisher)* in its place wherever it appears in this documentation.


## Introduction

In a traditional package management system, a package manager client contacts a central repository to query which packages are available, to get information on each package and check for updates, and to download the package binaries themselves.

For large ecosystems, this central repository may host packages from many independent Publishers.

This system has several problems and limitations:

* Trust in packages derives from trust in the central repository, not independently in packages.
* If trust erodes in the central repository, Publishers have little recourse to select alternatives (data portability).
* Even when alternatives can be created (such as by altering the package management system), packages hosted on any alternative repository are difficult for users to find.

The FAIR Protocol addresses these issues by separating package identifiers, package repositories, and other services into a decentralized system.

Each package in the FAIR system is uniquely identified by a [Decentralized Identifier (DID)][did]. The DID is used to identify the package, deduplicate any information about it, and to fetch the DID Document which contains information such as the repository location and cryptographic signing keys. The DID acts as a permanent, globally-unique, host-independent identifier which Publishers control.

Publishers may choose any repository, including running their own or using a repository provider they trust. They may change repositories by pointing the DID to a different repository, giving them data portability.

Each repository may operate fully independently, and clients may interact exclusively with the repository (and DID resolution mechanisms) - the "small web view". However, by itself this can present a bootstrapping problem: how do clients learn about new packages and repositories?

To bring this ecosystem back together (the "big web view"), "aggregators" collect package data from many repositories together, such as discovery services and caching.

As each package is uniquely identified by DID, decentralized "overlay" services may provide additional data about packages, such as moderation services and review systems.


### Protocol Flow

The FAIR system focuses on three key flows:

* **Discovery** - A user wants to find a package which fulfills their need, without knowing a specific package.
* **Installation** - A client wants to install a package identified by DID.
* **Updating** - A client wants to check for and install updates for a package identified by DID.

[did]: https://www.w3.org/TR/did-1.0/


#### Discovery

...


#### Installation

```
                     Client resolves DID to DID Document
                                      |
                                      V
 Client requests metadata from the repository specified by the DID Document
                                      |
                                      V
               Client selects which package release to install
                                      |
                                      V
                       Client downloads package binary
                                      |
                                      V
        Client verifies package binary signature matches signing key
```

The Installation flow has five discrete steps:

1. The client resolves the specified DID to a DID Document. The Document contains information on which repository is valid for the DID.

2. The client requests metadata about the package from the repository specified in the DID Document. This metadata includes information about the available package releases.

3. The client selects one of the available package releases to download and install. This may be presented as a choice to the user, or the client may select this automatically (for example, the latest release).

4. The client downloads the package binary or binaries for the selected release.

5. The client verifies the signature for the downloaded binary file(s) against the valid signing keys specified in the DID Document.

Once these steps have been completed, the client can treat the package as verified and perform additional client-specific steps such as installation.

For package binaries, clients may use a local (caching) mirror for any signed assets.


#### Updating

```
                     Client resolves DID to DID Document
                                      |
                                      V
 Client requests metadata from the repository specified by the DID Document
                                      |
                                      V
          Client compares available releases with current release
                                      |
                       (If new version is available)
                                      |
                                      V
               Client selects which package release to install
                                      |
                                      V
                       Client downloads package binary
                                      |
                                      V
        Client verifies package binary signature matches signing key
```


### Common Elements

The FAIR Protocol is built on top of [HTTP][http], and the use of any other protocol is out of scope. Unless otherwise specified, all HTTP connections MUST use Transport Layer Security (TLS).

Documents in the FAIR Protocol use [JSON-LD][json-ld] to provide context on the data within each document, allowing clients to identify the document type they are working on.

Links within JSON-LD documents use [Hypertext Application Language (HAL)][hal] to link to related resources.

[hal]: https://datatracker.ietf.org/doc/html/draft-kelly-json-hal-11
[http]: https://www.rfc-editor.org/rfc/rfc9110 "HTTP Semantics (RFC 9110), or later versions"
[json-ld]: https://www.w3.org/TR/json-ld11/


## Resolving DIDs

Packages are uniquely identified by a [Decentralized Identifier (DID)][did].

The following [DID methods][did-methods] MUST be supported as package IDs by compliant clients:

* [plc](https://github.com/did-method-plc/did-method-plc)
* [web](https://w3c-ccg.github.io/did-method-web/)

Additionally, clients MUST support the [key method](https://w3c-ccg.github.io/did-key-spec/) for cryptographic signatures.

Clients MUST resolve DIDs to a DID Document following the method-specific resolution rules.

Clients MAY cache a mapping of DID to DID Document for up to 24 hours. Clients MUST revalidate this mapping after 24 hours, to ensure that key revocation or repository changes are propagated within this time.

Publishers SHOULD use DID methods that are future-proof for data portability, and which avoid encoding trademarks or potentially-ephemeral names or domains.

[did-methods]: https://www.w3.org/TR/did-extensions-methods/


## DID Document

DID Documents contain information for use by FAIR clients. "Valid" DID Documents are those which conform to this specification's rules for DID Documents.

Valid documents MUST contain a service of type `FairPackageManagementRepo` with a valid URL (the "repo URL"). Documents without this type of service or without a valid URL MUST be considered invalid, and clients SHOULD cease further processing.

The repo URL SHOULD point to a valid [Metadata Document](#metadata-document) available via the HTTP protocol. Clients SHOULD ensure they have robust error handling if this URL is invalid, such as if the server is unavailable.

Valid documents MAY contain multiple services of the `FairPackageManagementRepo` type. Each service MUST have a unique `id` value. Clients MAY select any available service from the list. Clients SHOULD attempt an alternative service if the selected one is unavailable or returns an invalid response.

Services of types other than `FairPackageManagementRepo` SHOULD NOT be present unless specified by an extension to this specification.

Repository-Trust DID documents MUST contain one or more verification methods in the `verificationMethod` property. For Publisher-Trust DID documents where `capabilityDelegation` is present (see [Trust Tiers](#trust-tiers)), the verification method is provided by the Publisher's DID document and the `verificationMethod` property MAY be omitted from the Repository's Package DID document. Valid verification methods MUST have the type `Multikey`, and MUST use an ID where the non-fragment parts of the URI match the DID, and where the fragment part starts with `fair_`.

For example, the following document is considered a valid DID document:

```json
{
  "@context": [
    "https://www.w3.org/ns/did/v1",
    "https://w3id.org/security/multikey/v1",
    "https://w3id.org/security/suites/secp256k1-2019/v1"
  ],
  "alsoKnownAs": [],
  "id": "did:plc:ia6vk5krwkcka2nwuzs6l6lq",
  "service": [
    {
      "id": "#fairpm_repo",
      "serviceEndpoint": "https://example.fair.pm/packages/1234",
      "type": "FairPackageManagementRepo"
    }
  ],
  "verificationMethod": [
    {
      "controller": "did:plc:ia6vk5krwkcka2nwuzs6l6lq",
      "id": "did:plc:ia6vk5krwkcka2nwuzs6l6lq#fair_example",
      "publicKeyMultibase": "zQ3shwa7usQaHQqiUMCRweiWD2Njb8sZBynkqxD3VXMSzSorc",
      "type": "Multikey"
    }
  ]
}
```

A Repository MAY host any number of Packages. Each Package MUST have a distinct Package DID, and each DID MUST resolve to a separate DID Document with its own `FairPackageManagementRepo` service endpoint. Clients resolve and process each Package DID independently; the presence of multiple Package DIDs under the same domain requires no special handling.


## Trust Tiers

Two distinct trust tiers are defined in the FAIR Trust Model. Clients determine which tier applies from the Package's DID document structure alone.

### Repository-Trust

The DID document lists verification methods (signing keys) directly. The Package is signed by the Repository, so trust in the artifact flows from trust in the Repository. This is the trust baseline, and applies to:

- Packages redistributed by a Repository with no involvement in DID creation or signing from the original Publisher; and
- Packages for which the Publisher chooses to delegate signing entirely to the Repository.

### Publisher-Trust

A Publisher signing Packages directly and providing a valid DID document with a `FairPackageManagementRepo` service endpoint establishes Publisher-Trust directly. The Repository does not need to serve a separate DID document for the Package.

If the Repository does serve a DID document for a Package, the Trust Tier can be upgraded to Publisher-Trust using entries in the two DID documents. A Repository's DID document MAY contain a `capabilityDelegation` entry transferring signing functions to the Publisher's DID. The Package is signed by the Publisher using their own keys, so trust in the artifact flows directly from the Publisher's DID.

The format for `capabilityDelegation` is the DID to which authority is delegated with the capability appended — in this case `#fair_signing`.

This model requires two DID resolutions:

1. Resolve the Repository's Package DID → obtain the DID document → find the `capabilityDelegation` reference to the Publisher's DID and the `FairPackageManagementRepo` service endpoint(s).
2. Resolve the Publisher's DID → obtain current verification methods → use those keys to verify the artifact signature.

Clients MUST perform both resolutions when `capabilityDelegation` is present. Clients MUST NOT accept a signature as Publisher-verified if only the Package DID has been resolved.

Example Repository DID document for a Publisher-Trust Package:

```json
{
  "@context": [
    "https://www.w3.org/ns/did/v1",
    "https://w3id.org/security/multikey/v1"
  ],
  "id": "did:web:repo.example.com:Packages:my-plugin",
  "alsoKnownAs": [
    "did:plc:Publisher123abc..."
  ],
  "service": [
    {
      "id": "#fairpm_repo",
      "type": "FairPackageManagementRepo",
      "serviceEndpoint": "https://repo.example.com/Packages/my-plugin"
    }
  ],
  "capabilityDelegation": [
    "did:plc:Publisher123abc...#fair_signing"
  ]
}
```

Example of the corresponding Publisher's DID document:

```json
{
  "@context": [
    "https://www.w3.org/ns/did/v1",
    "https://w3id.org/security/multikey/v1"
  ],
  "id": "did:plc:Publisher123abc...",
  "alsoKnownAs": [
    "did:web:repo.example.com:Packages:my-plugin"
  ],
  "service": [
    {
      "id": "#fairpm_repo",
      "type": "FairPackageManagementRepo",
      "serviceEndpoint": "https://repo.example.com/Packages/my-plugin"
    }
  ],
  "verificationMethod": [
    {
      "id": "did:plc:Publisher123abc...#fair_signing",
      "type": "Multikey",
      "controller": "did:plc:Publisher123abc...",
      "publicKeyMultibase": "zQ3shwa7usQaHQqiUMCRweiWD2Njb8sZBynkqxD3VXMSzSorc"
    }
  ],
  "assertionMethod": [
    "did:plc:Publisher123abc...#fair_signing"
  ]
}
```

### Publisher DID takes precedence

The Publisher DID is the higher Trust Tier and is the authoritative source for Repository location. When a Package DID document contains `capabilityDelegation` referencing a Publisher DID, and the Publisher DID has a `FairPackageManagementRepo` service endpoint, Clients MUST prefer the Publisher DID's service endpoint(s) over any endpoint listed in the Repository's Package DID document.

Precedence is determined by DID Holder, not DID method. Any DID method supported by the FAIR protocol is valid.

### Client presentation of Trust Tier

To enable end-user discretion concerning Trust Tiers, Clients MUST surface the applicable Trust Tier to users when displaying Package details:

- **Repository-Trust** indicates that the Package is signed by the Repository, attesting that it contains a true bit-for-bit copy of the original Package. Trust flows from the Repository.
- **Publisher-Trust** indicates that the Package is signed directly by the Publisher. Trust flows from the Publisher.

### Trust Tier change notification

If a Client detects that the Trust Tier of an installed Package has changed since the last install or update, or detects that `capabilityDelegation` references a different Publisher DID, the Client MUST notify the user before installing any update. The update MUST NOT proceed silently.


## Alias Acknowledgment with `alsoKnownAs`

The `alsoKnownAs` property in the DID document declares a mutual acknowledgment that two identifiers refer to the same subject. It does not convey authorization of any type.

For Publisher-Trust Packages, the Publisher's DID SHOULD include `alsoKnownAs` entries referencing the Repository-Issued DID(s) for the Package. The Package's DID SHOULD include `alsoKnownAs` referencing the Publisher's DID. Bidirectional confirmation indicates an active, mutually acknowledged relationship between a Package hosted by a Repository and a Publisher.

Clients MUST verify that `alsoKnownAs` entries confirm the relationship bidirectionally before following any `capabilityDelegation` directive. When `capabilityDelegation` is present in a DID document, Clients MUST determine the applicable trust source as follows:

**Case 1 — confirmation broken, Publisher DID has a `FairPackageManagementRepo` service endpoint:** The Publisher has moved on from the Repository, either by initiating migration (removing the Repository-Issued DID from their own `alsoKnownAs`) or because the Repository has removed its `alsoKnownAs` reference to the Publisher DID to disavow the relationship. In both cases, Clients MUST follow the Publisher DID's service endpoint and MUST NOT fall back to the Repository's Package DID document. This applies for both Publisher-initiated and Repository-initiated separation. The Publisher's DID MUST remain authoritative.

**Case 2 — confirmation broken, Publisher DID has no `FairPackageManagementRepo` service endpoint:** The delegation cannot be confirmed and there is no authoritative Publisher endpoint to follow. Clients MUST NOT install or update the Package and MUST surface a warning to the user. Clients MUST NOT fall back to Repository-Trust. The presence of an unconfirmed `capabilityDelegation` is a signal that the trust model for this Package is in an indeterminate state.

**Case 3 — no `capabilityDelegation` present:** Repository-Trust baseline applies. The Package has not entered the Publisher-Trust model from the standpoint of this DID document.

Falling back to Repository-Trust MUST only occur in Case 3. A `capabilityDelegation` that exists but is unconfirmed is not equivalent to the absence of `capabilityDelegation`. This distinction is required to ensure Package portability is directed solely by the Publisher.


## Multiple Repositories for a Package

### Multiple `alsoKnownAs` entries as multiple Repositories

In the Publisher-Trust model, the Publisher's DID MAY list multiple DIDs in `alsoKnownAs` entries. Each DID MAY point to a different Repository to support configurations for redundancy, geographic distribution, and phased release strategies at the Publisher's discretion. Clients and Aggregators MUST NOT assume release parity across Repositories.

Clients MAY use any criteria to select among Repositories, including availability, latency, or locally configured preference.

### Aggregator behaviour for multi-Repository Packages

Aggregators resolve the Publisher's DID to obtain the list of valid Repositories. The Aggregator MAY use any criteria to select which Repository to index. Aggregators MUST NOT merge release lists across Repositories.

### Sync failure handling

If a Client fetches a release artifact and the checksum does not match the value in the release record, the Client MUST treat this as a transient failure and MUST NOT install the Package. The Client SHOULD attempt an alternative Repository if one is available. A checksum failure against a single Repository MUST NOT permanently invalidate other Repository DIDs for the same Package. The Client SHOULD surface a warning to the user.


## Package Portability and Repository Migration

Publishers and Repositories control their own DIDs, and portability is derived from this separation.

### Publisher-initiated Repository migration

**To migrate to a new Repository:**

1. The Publisher adds a `FairPackageManagementRepo` service endpoint to their DID pointing to the new Repository.
2. The Publisher removes the old Repository DID from `alsoKnownAs` in their DID, or adds the new Repository DID alongside it for a transition period.
3. The old Repository retains its DID document unchanged.

**Client behaviour after migration:**

A Client resolving the old Repository-Issued DID follows the `capabilityDelegation` entry to resolve the Publisher's DID and determines that the Repository-Issued DID is no longer listed in `alsoKnownAs`. The bidirectional confirmation check fails, and the Client follows the Publisher DID's `FairPackageManagementRepo` service endpoint to the new Repository.

The old Repository MAY continue to serve its last copy of any release.

The Publisher MAY retain the old Repository DID in `alsoKnownAs` indefinitely for failover if they continue to update that Repository's releases, or remove it at their discretion.

### Install by Publisher DID

Clients MUST support resolution beginning from a Publisher DID. This is a first-class resolution path and not a fallback. The resolution path is:

1. Resolve Publisher DID → check for `FairPackageManagementRepo` service endpoint(s) directly; if present, these take precedence over `alsoKnownAs` entries per the Publisher DID precedence rule. If no direct service endpoint is present, find `alsoKnownAs` entries referencing Repository-Issued DIDs.
2. Resolve any Repository-Issued DID found and obtain the Metadata Document from the Repository.
3. Proceed with normal installation for the selected Package.

When resolution begins from a Publisher DID, the `id` check against the Metadata Document (see [id](#id)) MUST be performed against the Package DID obtained from the Publisher DID's `alsoKnownAs` entries, not against the Publisher DID used to initiate resolution. A mismatch between the Metadata Document's `id` and the Publisher DID is not a validation failure, provided the `id` matches the expected Package DID from `alsoKnownAs`.


## Package Claiming Process (Repository-Trust → Publisher-Trust)

This process transfers a Package from Repository-Trust to Publisher-Trust. Publishers of Packages being redistributed without prior engagement may claim ownership and take control of signing functions to establish provenance at the Publisher-Trust level.

### Cryptographic mechanism

1. The claimant Publisher creates or designates a DID they control as the Publisher DID.
2. The claimant adds the Package's Repository-Issued DID to `alsoKnownAs` in their Publisher DID. This step is the claimant's half of the handshake and can be performed without the Repository's involvement.
3. The Repository verifies the claimant's identity by out-of-band means.
4. The Repository updates its Package DID document to add `alsoKnownAs` referencing the claimant's Publisher DID, completing the bidirectional `alsoKnownAs` acknowledgment.
5. The Repository updates its Package DID document to add a `capabilityDelegation` entry pointing to the claimant's Publisher DID for the `fair_signing` capability.
6. Bidirectional confirmation and delegation of package signing are established, achieving Publisher-Trust for the Package.
7. Future releases MUST be signed with the Publisher's keys. Existing releases signed with Repository keys remain valid.

The claimant's `alsoKnownAs` step MUST precede the Repository's first DID update (step 4). This ensures the claimant has acknowledged the Package identity before the Repository asserts a trust relationship with them. A Repository MUST NOT update the DID document to add `capabilityDelegation` before the claimant's `alsoKnownAs` entry is confirmed.

### Out-of-band identity verification

Verification of the claimant's identity is the Repository's responsibility and is outside the scope of this Protocol. The Protocol guarantees a valid cryptographic chain, but guaranteeing that the claiming party is the legitimate Publisher is a policy claim governed by the Repository hosting the Package. Repositories SHOULD document their identity verification process for claimants.

### Aggregator notification

Repositories MUST emit a `Package.trust-transferred` event to Aggregators on completion of a claiming process so downstream services are aware the Trust Model has changed. Based on their own policies, downstream services MAY apply additional scrutiny. Aggregators MUST surface this event in the Package history.


## Key Revocation for Installed Packages

For Packages installed prior to a key rotation, Clients MUST re-verify installed Packages against the current signing keys in the applicable DID document at the next update check. If an installed Package's artifact cannot be verified against any current signing key, the Client MUST surface a warning to the user and MUST NOT install updates until verification succeeds. Since uninstallation is an explicit user action, Clients MUST NOT automatically uninstall a Package solely because its historical signature cannot be verified against current keys.


## Metadata Document

A Metadata Document is a JSON document provided by a repository which provides information about a specific package. The Metadata Document is specified for a given package by the `FairPackageManagementRepo` service in the [DID Document](#did-document). "Valid" metadata documents are those which conform to this specification's rules for Metadata Documents.

Valid metadata documents MUST conform to the JSON-LD specification. When presented as a standalone document, the metadata document MUST include a `@context` entry. The `@context` entry MUST be either the JSON String `https://fair.pm/ns/metadata/v1` or a JSON Array where the first item is the JSON String `https://fair.pm/ns/metadata/v1`.

The following properties are defined for the metadata document:

| Property     | Required? | Constraints                                                         |
| ------------ | --------- | ------------------------------------------------------------------- |
| id           | yes       | A valid DID.                                                        |
| type         | yes       | A string that conforms to the rules of [type](#property-type).      |
| license      | yes       | A string that conforms to the rules of [license](#property-license) |
| authors      | yes       | A list that conforms to the rules of [authors](#property-authors)   |
| security     | yes       | A list that conforms to the rules of [security](#property-security) |
| releases     | yes       | A list of [Releases](#release-document)                             |
| slug         | no        | A string that conforms to the rules of [slug](#property-slug)       |
| name         | no        | A string.                                                           |
| description  | no        | A string.                                                           |
| keywords     | no        | A list of strings.                                                  |
| sections     | no        | A map that conforms to the rules of [sections](#property-sections)  |
| last_updated | no        | A string.                                                           |
| _links       | no        | [HAL links][hal], with [defined relationships](#links-metadata)     |

The properties of the metadata document have the following semantic meanings and constraints.


### id

The `id` property specifies the package ID. This property MUST be specified.

This property MUST be a valid DID.

Clients SHOULD verify this ID against the DID used to look up the metadata document. If the ID specified in the Metadata Document does not match the expected ID, clients MUST stop processing the document and MUST NOT treat the document as valid for the expected ID.

When resolution begins from a Publisher DID (see [Install by Publisher DID](#install-by-publisher-did)), the `id` check MUST be performed against the Package DID obtained from the Publisher DID's `alsoKnownAs` entries, not against the Publisher DID itself. A mismatch between the Metadata Document's `id` and the Publisher DID is not a validation failure, provided the `id` matches the expected Package DID from `alsoKnownAs`.


### type

<a name="property-type"></a>

The `type` property specifies the package type. This property MUST be specified.

This property MUST be a valid string. The property SHOULD use a type defined in the [type registry][type-registry].

Custom or non-standard types SHOULD be prefixed with `x-` to indicate they are non-standard.

Clients MUST NOT install packages with a `type` they do not have a semantic understanding of. When installation of a Package with an unknown `type` is attempted, clients MUST surface an error message.

Example:

> Could not install: unsupported package ecosystem.

[type-registry]: ./registry.md#package-types


### license

<a name="property-license"></a>

The `license` property specifies the license of the package. This property MUST be specified.

This property MUST be a valid [SPDX License Expression][spdx-expr], or the string "proprietary".

Clients SHOULD refuse to install packages which do not have a valid license.

[spdx-expr]: https://spdx.github.io/spdx-spec/v3.0.1/annexes/spdx-license-expressions/


### authors

<a name="property-authors"></a>

The `authors` property specifies the authors of the package. This property MUST be specified.

This property MUST be a valid list, represented as a JSON Array. The list MUST have at least one object.

The items of the list MUST be objects, with the following properties:

* `name` (required) - A string. Human-readable author name.
* `url` (optional) - A URL string. Used to link users to the author's site or a HTML page describing the author.
* `email` (optional) - An email address string. Used to link users to contact the author.

Publishers SHOULD specify at least one of `url` or `email` per author.

Clients MAY refuse to install packages without at least one valid author.

Clients SHOULD present all authors to users when displaying metadata.


### security

<a name="property-security"></a>

The `security` property specifies the security contacts for the package. This property MUST be specified.

This property MUST be a valid list, represented as a JSON Array. The list MUST have at least one object.

The items of the list MUST be objects, with the following properties:

* `url` (optional) - A URL string. Used to link users to a security contact form or information about the security of the package.
* `email` (optional) - An email address string. Used to link users to contact a security notification email.

Publishers SHOULD specify at least one of `url` or `email` per security contact.

Clients SHOULD refuse to install packages without at least one valid security contact.

Clients SHOULD present all security contacts to users when displaying metadata.


### releases

The `releases` property specifies releases available for the package. This property MUST be specified.

This property MUST be a valid list, represented as a JSON Array.

The items of the list MUST be objects, conforming to the [Release Document](#release-document) specification.


### slug

<a name="property-slug"></a>

The `slug` property specifies the desired "slug" for the package, which the client may use for filenames or directory names when installing the package.

The slug MUST be a string containing only alphanumeric characters, dashes, or underscores. The slug MUST start with an alphabetic character.

```
slug  = ALPHA *(ALPHA / DIGIT / "-" / "_")
```

Clients SHOULD validate the slug against these rules. If a slug does not validate, clients MAY strip invalid characters to form a valid slug, or ignore the slug entirely.

Clients SHOULD use the slug for file or directory names used during installation of the package, unless doing so would conflict with a different package. Clients MAY deduplicate packages with matching slugs (but differing IDs) in any way they see fit, including appending an incrementing counter to the slug or using the ID as part of the slug. Publishers SHOULD indicate a globally-unique slug if possible, such as a product name.


### name

The `name` property specifies a human-readable name for the package, which the client may display in index or list pages.

The name MUST be a string.


### description

The `description` property specifies a short description of the package, which the client may display in index or list pages.

The description MUST be a string.

The description SHOULD be written in plain text, and clients MUST escape any special characters for the applicable formatting context (such as HTML). The description SHOULD NOT exceed 140 characters. Clients MAY truncate the description if it exceeds this limit.


### keywords

The `keywords` property specifies keywords to assist users in searching for packages.

Keywords MUST be a list, represented as a JSON Array. The list SHOULD NOT contain more than 5 items. Clients MAY truncate the list to 5 items.

Each item of the array MUST be a string.


### sections

<a name="property-sections"></a>

The `sections` property specifies human-readable sections of text to display to users to provide them with information about the package.

Sections MUST be a map, represented as a JSON Object.

The following keys and their semantic meaning are specified:

* `changelog` - A list of changes to the package.
* `description` - The primary description and information for the package.
* `security` - Information about the security of the package and how to report vulnerabilities.

Other keys MAY be specified, and their meaning MAY be defined within extensions to this specification.

Clients SHOULD ignore any section which does not have an explicit semantic meaning specified.


### last_updated

The `last_updated` property specifies the date on which the package was last updated.

The last_updated MUST be a string.


### _links

<a name="links-metadata"></a>

Metadata Documents may have links to other resources, using the [HAL specification][hal], as provided in the `_links` property.

Metadata Documents SHOULD have a `https://fair.pm/rel/repo` link to the Repository Document for the Package they describe.

Metadata Documents MAY have a `https://fair.pm/rel/releases` link to a collection of Releases. This relationship may be used to indicate an endpoint which provides an exhaustive list of Releases, allowing the `releases` property to be used only for "active" releases.

If present, a `collection` link indicates an endpoint which lists packages available from the Repository; in other words, the collection the package belongs to. Clients MAY use this to discover other packages available from the repository.


## Release Document

A Release Document is a JSON document provided by a repository which provides information about a release for a package. "Valid" release documents are those which conform to this specification's rules for Release documents.

Release documents may be available as standalone documents or embedded within other documents, such as in the `releases` property of a [Metadata Document](#metadata-document).

When presented as a standalone document, the release document MUST include a `@context` entry. The `@context` entry MUST be either the JSON String `https://fair.pm/ns/release/v1` or a JSON Array where the first item is the JSON String `https://fair.pm/ns/release/v1`. The `@context` entry MAY be omitted where the release document is embedded within another document.

The following properties are defined for the release document:

| Property    | Required? | Constraints                                                          |
| ----------- | --------- | -------------------------------------------------------------------- |
| version     | yes       | A string that conforms to the rules of [version](#property-version)  |
| artifacts   | yes       | A map that conforms to the rules of [artifacts](#property-artifacts) |
| provides    | no        | A map that conforms to the rules of [provides](#property-provides)   |
| requires    | no        | A map that conforms to the rules of [requires](#property-requires)   |
| suggests    | no        | A map that conforms to the rules of [suggests](#property-suggests)   |
| auth        | no        | A map that conforms to the rules of [auth](#property-auth)           |
| _links      | no        | [HAL links][hal], with [defined relationships](#links-release)       |

The properties of the release document have the following semantic meanings and constraints.


### version

<a name="property-version"></a>

The `version` property specifies the version for this release.

This property MUST be a string, consisting of up to 3 groups of numbers, separated by a period.

A pre-release version MAY be denoted by appending a hyphen and a series of dot-separated identifiers.

Build metadata MAY be denoted by appending a plus sign and a series of dot-separated identifiers following the patch or pre-release version.

```
alphahyphen = ALPHA / DIGIT / "-"
prerelease  = 1*(alphahyphen) *("." 1*(alphahyphen))
metadata    = 1*(alphahyphen) *("." 1*(alphahyphen))
version     = 1*DIGIT *2("." 1*DIGIT) ["-" prerelease] ["+" metadata]
```

This property SHOULD be a valid version number conforming to the [Semantic Versioning Specification (SemVer)][semver], with the semantic meaning as described in that specification. Clients SHOULD parse the version number according to SemVer, and SHOULD use the version comparison rules specified in SemVer.

The build metadata MUST be ignored when determining version precedence.

[semver]: https://semver.org/

#### Version immutability

A repository MUST NOT modify or replace the artifacts or metadata of a published release for a given version. The first release record created for a version under a given package DID is the canonical record.

Clients MUST retain the `checksum` value of installed releases. On update checks, if a repository serves a release for a previously-installed version with a different `checksum`, clients MUST reject the response and MUST alert the user.

Aggregators that index release records MUST ignore any record for a version that has already been indexed for the same package DID. The earlier record is canonical; the later record is invalid and MUST be treated as if it were not present.

### artifacts

<a name="property-artifacts"></a>

The `artifacts` property specifies the artifacts for the release. This property MUST be specified.

This property MUST be a valid map, represented as a JSON Object. The map MUST have at least one entry.

The properties of the map represent the artifact type, as applicable to the [package type](#property-type).

Custom or non-standard types SHOULD be prefixed with `x-` to indicate they are non-standard.

The values of the map MUST be objects or lists of objects, with the following common properties:

| Property        | Required? | Description                                                |
|-----------------|-----------|------------------------------------------------------------|
| `id`            |   no      | A unique ID for the artifact within its type group.        |
| `content-type`  |   no      | The MIME type of the artifact.                             |
| `requires-auth` |   no      | Boolean: whether authentication is required to access.     |
| `release-asset` |   no      | Boolean: whether the artifact is a platform release asset. |
| `url`           |   no      | URL where the artifact can be downloaded.                  |
| `signature`     |   no      | Cryptographic signature of the artifact.                   |
| `checksum`      |   no      | Cryptographic checksum of the artifact.                    |

Extensions MAY specify additional properties which are type-specific.

A common `package` artifact type is defined as the "primary" artifact representing the installable binary, as applicable to the specified package type. The `package` type MUST specify the `url` property, and SHOULD specify the `signature` and `checksum` properties.

The properties of these objects have the following semantic meanings and constraints.


#### id

The `id` property specifies a unique asset ID, which can be used to distinguish between multiple assets of the same type.

When specified, the `id` MUST be unique in the list of assets for the same type. The `id` MAY be the same as assets of a different type, and no special semantic meaning is defined if they are the same.


#### content-type

The `content-type` property specifies the MIME type of the artifact.

The `content-type` property MUST conform to [RFC6838][rfc6838].

Clients MAY choose to select the most appropriate artifact for download based on the MIME type.

[rfc6838]: https://datatracker.ietf.org/doc/html/rfc6838


#### requires-auth

The `requires-auth` property specifies whether the artifact requires authentication to access.

The `requires-auth` property MUST be a boolean.

If the `requires-auth` property is true, clients SHOULD perform authentication prior to accessing the URL, according to the [auth](#property-auth) property of the release.


#### release-asset

The `release-asset` property indicates that the artifact URL points to a platform release asset rather than a directly-served file.

The `release-asset` property MUST be a boolean. If omitted, clients MUST treat the value as `false`.

When `release-asset` is `true`, the artifact URL points to a binary file served by a platform API. Clients MUST send an `Accept: application/octet-stream` header when downloading the artifact, in addition to any headers required by the `requires-auth` property. Clients MUST NOT follow a redirect that changes the host to one not associated with the original URL without re-validating the target.

When `release-asset` is `false` or omitted, Clients MAY use their default download behavior.

The following example shows a release with one release-asset artifact and one directly-served artifact:

```json
{
  "version": "2.1.0",
  "artifacts": {
    "package": [
      {
        "url": "https://api.github.com/repos/acme/plugin/releases/assets/98765432",
        "content-type": "application/octet-stream",
        "release-asset": true,
        "signature": "z...",
        "checksum": "sha384:abc123..."
      }
    ],
    "icon": [
      {
        "url": "https://example.com/assets/plugin-icon.png",
        "content-type": "image/png"
      }
    ]
  }
}
```

Clients SHOULD verify the checksum and signature of `release-asset` artifacts using the same procedure as other artifacts. The `release-asset` flag affects only how the artifact is downloaded, not how it is verified.


#### url

The `url` property specifies the URL where a client can access an asset.

Clients MAY embed assets from URLs directly; for example, images may be displayed inline rather than downloaded.


#### signature

The `signature` property specifies the cryptographic signature of the asset.

Signatures MUST be generated using the appropriate signature method for one of the valid signing keys specified by the [DID Document](#did-document). If the signature is not valid for any of the signing keys, clients MUST reject the artifact and MUST NOT process the artifact further.


#### checksum

The `checksum` property specifies a checksum used to validate the data integrity of the artifact.

Checksums MUST be specified as a string, as defined in [checksum](#checksum).

Extensions MAY specify additional valid checksum algorithms. Custom or non-standard types SHOULD be prefixed with `x-` to indicate they are non-standard.


### provides

<a name="property-provides"></a>

The `provides` property specifies capabilities that the package provides, as applicable to the [package type](#property-type).

This property MUST be a valid map, represented as a JSON Object.

The properties of the map represent the capability type, as applicable to the [package type](#property-type). Custom or non-standard types SHOULD be prefixed with `x-` to indicate they are non-standard.

The values of the map MUST be strings or lists of strings.


### requires

<a name="property-requires"></a>

The `requires` property specifies dependencies that the package requires in order to be usable.

This property MUST be a valid map, represented as a JSON Object.

The keys of the object MUST be strings. The keys MUST be either a package DID or an environment requirement prefixed with `env:`. Package DID keys MUST conform to the DID specification and SHOULD refer to valid package IDs.

The values of the object MUST be strings. The values are version constraints specifying which releases for the package are valid to fulfill the requirement.

Clients SHOULD resolve the requirements of the package before completing installation, and SHOULD NOT install the package if the requirements cannot be resolved.

Environment requirements prefixed with `env:` are type-specific, and are specified by extensions to this specification. If a client does not recognise an environment requirement, it SHOULD treat the requirement as being unfulfilled, and SHOULD NOT install the package.


### suggests

<a name="property-suggests"></a>

The `suggests` property specifies packages that can be installed alongside the package being installed.

This property matches the format of the [`requires` property](#property-requires).


### auth

<a name="property-auth"></a>

The `auth` property specifies authentication requirements to access the release's artifacts.

This property MUST be a valid object, conforming to the authentication method being used. The `type` property of this object indicates the authentication method being used. The authentication method SHOULD be a method defined in the [authentication registry][auth-registry].

Custom or non-standard methods SHOULD be prefixed with `x-` to indicate they are non-standard.

Common properties of the object are defined as:

* `type` (required) - The authentication method being used.
* `hint` (optional) - A human-readable hint to the authentication method.
* `hint_url` (optional) - A URL for more information about the required authentication.

Extensions MAY specify additional properties which are type-specific.

Clients which do not recognise the method being used SHOULD display the `hint` and `hint_url` to the user. Repositories SHOULD include the `hint` and `hint_url` properties.

Authentication may be used for limited-access packages, such as those requiring purchase, and clients SHOULD display the `hint` and `hint_url` to the user to ensure they understand why access is limited.

Access to individual artifacts may be limited on a per-artifact basis using the `requires-auth` property on the artifact. The presence of this flag indicates clients MUST authenticate in order to access the artifact.

The properties of this object have the following semantic meanings and constraints.

[auth-registry]: ./registry.md#authentication-methods

#### type

The `type` property specifies the authentication method being used.

This property MUST be a string. This property SHOULD be a method defined in the [authentication registry][auth-registry].

Custom or non-standard methods SHOULD be prefixed with `x-` to indicate they are non-standard.


#### hint

The `hint` property specifies a hint to display to the user to indicate how they can authenticate and why it is required.

This property MUST be a string.

Clients SHOULD display the hint to the user, even if the method is not recognised.

The hint SHOULD be written in plain text, and clients MUST escape any special characters for the applicable formatting context (such as HTML). The hint SHOULD NOT exceed 140 characters. Clients MAY truncate the hint if it exceeds this limit.


#### hint_url

The `hint_url` property specifies a URL which provides more information about the authentication requirements for the package.

This property MUST be a string with a valid URL to a HTTP document.

Clients SHOULD display the hint URL to the user, even if the method is not recognised. Clients which support hyperlinks SHOULD use an interactive hyperlink to allow the user to easily view the linked document.


### sbom

<a name="property-sbom"></a>

Publishers MAY include an entry for the `sbom` property to specify a machine-readable software bill of materials for this release.

This property MUST be a valid object with the following properties:

* `format` (optional) — The SBOM format. MUST be one of `"cyclonedx"` or `"spdx"`.
* `url` (optional) — A URL string where the SBOM document can be fetched.
* `checksum` (optional) — A checksum of the SBOM document, in the same format as artifact checksums (see [checksum](#checksum)). This allows the SBOM document to be verified using the same trust chain as the release artifact.

Publishers SHOULD include `sbom` references for releases distributed commercially in jurisdictions that require software bill of materials disclosure.

Clients SHOULD surface SBOM presence or absence to users when displaying release details, and SHOULD provide access to the SBOM URL for inspection. Clients MUST NOT refuse to install a release solely because `sbom` is absent.

Aggregators and Labellers MAY use SBOM presence and content as a trust signal.


### _links

<a name="links-release"></a>

Release Documents may have links to other resources, using the [HAL specification][hal], as provided in the `_links` property.

If a Release Document is embedded within another resource, such as a Metadata Document, links which are the same as the parent document SHOULD be omitted.

Release Documents SHOULD have a `https://fair.pm/rel/repo` link to the Repository Document for the Repository hosting the release.

Release Documents SHOULD have a `https://fair.pm/rel/package` link to the Metadata Document for the package they belong to.


## Repository Document

A Repository Document is a JSON document provided by a repository which provides information about the repository itself.

The Repository Document informs users about the people or organizations running the repository, as well as policies for the repository.

Valid repository documents MUST conform to the JSON-LD specification. When presented as a standalone document, the repository document MUST include a `@context` entry. The `@context` entry MUST be either the JSON String `https://fair.pm/ns/repository/v1` or a JSON Array where the first item is the JSON String `https://fair.pm/ns/repository/v1`.

The following properties are defined for the repository document:

| Property    | Required? | Constraints                                                                    |
| ----------- | --------- | ------------------------------------------------------------------------------ |
| name        | yes       | A string.                                                                      |
| maintainers | yes       | A list that conforms to the rules of [maintainers](#property-repo-maintainers) |
| security    | yes       | A list that conforms to the rules of [security](#property-repo-security)       |
| privacy     | yes       | A URL string.                                                                  |
| _links      | no        | [HAL links][hal], with [defined relationships](#links-repo)                    |

The properties of the repository document have the following semantic meanings and constraints.


### name

The `name` property specifies a human-readable name for the repository, which the client may display in index or list pages.

The name MUST be a string.


### maintainers

<a name="property-repo-maintainers"></a>

The `maintainers` property specifies the maintainers of the repository. This property MUST be specified.

This property MUST be a valid list, represented as a JSON Array. The list MUST have at least one object.

The items of the list MUST be objects, with the following properties:

* `name` (required) - A string. Human-readable maintainer name.
* `url` (optional) - A URL string. Used to link users to the maintainer's site or a HTML page describing the maintainer.
* `email` (optional) - An email address string. Used to link users to contact the maintainer.

Repositories SHOULD specify at least one of `url` or `email` per maintainer.

Clients SHOULD present all maintainers to users when displaying repository data.


### security

<a name="property-repo-security"></a>

The `security` property specifies the security contacts for the repository. This property MUST be specified.

This property MUST be a valid list, represented as a JSON Array. The list MUST have at least one object.

The items of the list MUST be objects, with the following properties:

* `url` (optional) - A URL string. Used to link users to a security contact form or information about the security of the package.
* `email` (optional) - An email address string. Used to link users to contact a security notification email.

Repositories SHOULD specify at least one of `url` or `email` per security contact.

If the `security` property is not specified, clients SHOULD block installation of packages from the repository, and SHOULD display a warning to the user.

Clients SHOULD present all security contacts to users when displaying repository data.


### privacy

The `privacy` property specifies the location of the privacy policy for the repository. This property MUST be specified.

If the `privacy` property is not specified, clients SHOULD block installation of packages from the repository, and SHOULD display a warning to the user.


### _links

<a name="links-repo"></a>

Repository Documents may have links to other resources, using the [HAL specification][hal], as provided in the `_links` property.


## Caching

Clients MAY choose to use an external cache of package data instead of fetching it directly from the repository. In particular, external caches may be used for artifacts such as the main installable package, to reduce bandwidth costs and latency.

External caches SHOULD only cache signed artifacts that can be independently-verified to contain data valid for the package.

Clients SHOULD only use trusted external caches, such as those provided by the same infrastructure provider as the client or on the same machine.

Clients MUST NOT use an external cache for [Resolving DIDs](#resolving-dids), but MAY use an internal cache for this data. DID resolution MUST NOT be cached for more than 24 hours.


## Deletion & Tombstone Semantics

Publishers may remove Packages or releases from their Repositories. This section defines the expected behavior of Clients and Aggregators when this occurs.

### Package deletion

When a Repository no longer serves a previously-indexed Package, the Package is considered deleted.

Repositories SHOULD retain an internal tombstone record for the Package DID. This tombstone MUST NOT be served in search results and the deleted Package MUST NOT be installable. Direct lookups by DID SHOULD return an explicit `deleted` response (HTTP `410 Gone`) rather than `404 Not Found`.

Since removal from a site is an explicit user action, Package deletion MUST NOT cause uninstallation by the Client.

### Release deletion

When a specific release record is removed from a Repository, the release is considered deleted.

Repositories MUST exclude deleted releases from release lists. The latest-release selection algorithm MUST skip deleted releases when determining the current version, as deleted releases MUST NOT be installable.

Repositories that mirror artifacts SHOULD remove the mirrored artifact bytes for deleted releases from their object stores. The tombstone record SHOULD be retained.

Release deletion MUST NOT cause uninstallation by the Client.

### Deletion is distinct from version immutability

Deletion removes a release from distribution. A Publisher removing a release is explicitly permitted; a Publisher releasing a new artifact in place of an existing version is not (see [Version immutability](#version-immutability)). A deleted release MUST NOT be republished under the same version number, for which a tombstone record is retained.


## JSON-LD Contexts

The following JSON-LD contexts are registered by this specification.

| Context                            | Document                                    |
| ---------------------------------- | ------------------------------------------- |
| `https://fair.pm/ns/metadata/v1`   | [Metadata Document](#metadata-document)     |
| `https://fair.pm/ns/release/v1`    | [Release Document](#release-document)       |
| `https://fair.pm/ns/repository/v1` | [Repository Document](#repository-document) |


## Schema Evolution

As the FAIR Protocol specification and its extensions evolve, clients need predictable guarantees about backward compatibility. The following rules govern how document schemas may change.

### Additive-optional fields only.

New properties MAY be added to any document type at any time, provided they are optional. Clients MUST ignore properties they do not recognize and continue to process the document normally.

### No narrowing of existing fields.

An existing property:

* MUST NOT be made required if it was previously optional.
* MUST NOT have its type changed.
* MUST NOT have its validation rules tightened.
* MUST NOT be renamed.

Each of these is considered a breaking change.

### Breaking changes require a new context URL.

If a genuinely incompatible shape is needed for a document type, a new JSON-LD context URL MUST be introduced. The old context URL and its associated document shape MUST remain valid for all documents that reference it.

### Extensions follow the same rules.

Extension authors MUST treat extension-defined document shapes as subject to these constraints once the extension is deployed and indexed by Aggregators. An extension update that would break deployed clients requires a new extension identifier.


## Link Relationships

The following link relationships are defined, such as for links specified by [HAL links][hal] (in the `_links` property of a document).

| Relation                       | Description                                                  |
| ------------------------------ | ------------------------------------------------------------ |
| `https://fair.pm/rel/repo`     | Link to [Repository Document](#repository-document)          |
| `https://fair.pm/rel/package`  | Link to [Metadata Document](#metadata-document)              |
| `https://fair.pm/rel/releases` | Link to collection of [Release Documents](#release-document) |

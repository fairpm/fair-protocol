# FAIR Package Management Protocol

FAIR (Federated and Independent Repositories) Package Management Protocol is a system for distributing installable software.

This specification outlines the core FAIR protocol specification ("FAIR Core"). Ecosystem-specific extensions are implemented as extensions to this specification, as defined in the [extension registry](./registry.md).


## Definitions

- *aggregator* - Any server which aggregates or collects Package data together.
- *client* - An entity which requests Packages.
- *DID* - Decentralized ID, a universally-unique identifier specified by [the W3C specification](https://www.w3.org/TR/did-1.0/).
- *package* - Any installable software, consisting of an ID, metadata, and associated assets.
- *package binary* - An asset such as a zip file containing the package's binary executable code.
- *repository* - Any server which offers packages, following the Repository APIs.
- *user* - An end-user directing a Client to operate.
- *vendor* - An entity which publishes packages through a Repository.


## Introduction

In a traditional Package management system, a Package manager Client contacts a central Repository to query which Packages are available, to get information on each Package and check for updates, and to download the Package binaries themselves.

For large ecosystems, this central Repository may host Packages from many independent vendors.

This system has several problems and limitations:

* Trust in Packages derives from trust in the central Repository, not independently in Packages.
* If trust erodes in the central Repository, vendors have little recourse to select alternatives (data portability).
* Even when alternatives can be created (such as by altering the Package management system), Packages hosted on any alternative Repository are difficult for users to find.

The FAIR Protocol addresses these issues by separating Package identifiers, Package Repositories, and other services into a decentralized system.

Each Package in the FAIR system is uniquely identified by a [Decentralized Identifier (DID)][did]. The DID is used to identify the Package, deduplicate any information about it, and to fetch the DID Document which contains information such as the Repository location and cryptographic signing keys. The DID acts as a permanent, globally-unique, host-independent identifier which vendors control.

Package vendors may choose any Repository, including running their own or using a Repository provider they trust. They may change Repositories by pointing the DID to a different Repository, giving them data portability.

Each Repository may operate fully independently, and Clients may interact exclusively with the Repository (and DID resolution mechanisms) - the "small web view". However, by itself this can present a bootstrapping problem: how do Clients learn about new Packages and Repositories?

To bring this ecosystem back together (the "big web view"), "aggregators" collect Package data from many Repositories together, such as discovery services and caching.

As each Package is uniquely identified by DID, decentralized "overlay" services may provide additional data about Packages, such as moderation services and review systems.


### Protocol Flow

The FAIR system focusses on three key flows:

* **Discovery** - A user wants to find a Package which fulfills their need, without knowing a specific Package.
* **Installation** - A Client wants to install a Package identified by DID.
* **Updating** - A Client wants to check for and install updates for a Package identified by DID.

[did]: https://www.w3.org/TR/did-1.0/


#### Discovery

...


#### Installation

```
                     Client resolves DID to DID Document
                                      |
                                      V
 Client requests metadata from the Repository specified by the DID Document
                                      |
                                      V
               Client selects which Package release to install
                                      |
                                      V
                       Client downloads Package binary
                                      |
                                      V
        Client verifies Package binary signature matches signing key
```

The Installation flow has five discrete steps:

1. The Client resolves the specified DID to a DID Document. The Document contains information on which Repository is valid for the DID.

2. The Client requests metadata about the Package from the Repository specified in the DID Document. This metadata includes information about the available Package releases.

3. The Client selects one of the available Package releases to download and install. This may be presented as a choice to the user, or the Client may select this automatically (for example, the latest release).

4. The Client downloads the Package binary or binaries for the selected release.

5. The Client verifies the signature for the downloaded binary file(s) against the valid signing keys specified in the DID Document.

Once these steps have been completed, the Client can treat the Package as verified and perform additional Client-specific steps such as installation.

For Package binaries, Clients may use a local (caching) mirror for any signed assets.


#### Updating

```
                     Client resolves DID to DID Document
                                      |
                                      V
 Client requests metadata from the Repository specified by the DID Document
                                      |
                                      V
          Client compares available releases with current release
                                      |
                       (If new version is available)
                                      |
                                      V
               Client selects which Package release to install
                                      |
                                      V
                       Client downloads Package binary
                                      |
                                      V
        Client verifies Package binary signature matches signing key
```


### Common Elements

The FAIR Protocol is built on top of [HTTP][http], and the use of any other protocol is out of scope. Unless otherwise specified, all HTTP protocols MUST use Transport Layer Security (TLS).

Documents in the FAIR Protocol use [JSON-LD][json-ld] to provide context on the data within each document, allowing Clients to identify the document type they are working on.

Links within JSON-LD documents use [Hypertext Application Language (HAL)][hal] to link to related resources.

[hal]: https://datatracker.ietf.org/doc/html/draft-kelly-json-hal-11
[http]: https://datatracker.ietf.org/doc/html/rfc7230
[json-ld]: https://www.w3.org/TR/json-ld11/


## Resolving DIDs

Packages are uniquely identified by a [Decentralized Identifier (DID)][did].

The following [DID methods][did-methods] MUST be supported as Package IDs by compliant Clients:

* [plc](https://github.com/did-method-plc/did-method-plc)
* [web](https://w3c-ccg.github.io/did-method-web/)

Additionally, Clients must support the [key method](https://w3c-ccg.github.io/did-key-spec/) for cryptographic signatures.

Clients MUST resolve DIDs to a DID Document following the method-specific resolution rules.

Clients MAY cache a mapping of DID to DID Document for up to 24 hours. Clients MUST revalidate this mapping after 24 hours, to ensure that key revocation or Repository changes are propagated within this time.

Vendors SHOULD use DID methods that are future-proof for data portability, and which avoid encoding trademarks or potentially-ephemeral names or domains.

[did-methods]: https://www.w3.org/TR/did-extensions-methods/


## DID Document

DID Documents contain information for use by FAIR Clients. "Valid" DID Documents are those which conform to this specification's rules for DID Documents.

Valid documents MUST contain a service of type `FairPackageManagementRepo` with a valid URL (the "repo URL"). Documents without this type of service or without a valid URL MUST be considered invalid, and Clients SHOULD cease further processing.

The repo URL SHOULD point to a valid [Metadata Document](#metadata-document) available via the HTTP protocol. Clients SHOULD ensure they have robust error handling if this URL is invalid, such as if the server is unavailable.

Valid documents SHOULD NOT contain multiple services without the `FairPackageManagementRepo` type unless specified by an extension to this specification. Clients which assume a single Repository MUST use the first service with the matching type in the [set][ordered-set].

Valid documents MUST contain one or more verification methods in the `verificationMethod` property. Valid verification methods MUST have the type `Multikey`, and MUST use an ID where the non-fragment parts of the URL match the DID, and where the fragment part starts with `fair_`.

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

[ordered-set]: https://infra.spec.whatwg.org/#ordered-set


## Metadata Document

A Metadata Document is a JSON document provided by a Repository which provides information about a specific Package. The Metadata Document is specified for a given Package by the `FairPackageManagementRepo` service in the [DID Document](#did-document). "Valid" metadata documents are those which conform to this specification's rules for Metadata Documents.

Valid metadata documents MUST conform to the JSON-LD specification. When presented as a standalone document, the metadata document MUST include a `@context` entry. The `@context` entry MUST be either the JSON String `https://fair.pm/ns/metadata/v1` or a JSON Array where the first item is the JSON String `https://fair.pm/ns/metadata/v1`.

The following properties are defined for the metadata document:

| Property     | Required? | Constraints                                                          |
| ------------ | --------- | -------------------------------------------------------------------- |
| id           | yes       | A valid DID.                                                         |
| type         | yes       | A string that conforms to the rules of [type](#property-type).       |
| license      | yes       | A string that conforms to the rules of [license](#property-license)  |
| authors      | yes       | A list that conforms to the rules of [authors](#property-authors)    |
| security     | yes       | A list that conforms to the rules of [security](#property-security)  |
| releases     | yes       | A list of [Releases](#release-document)                              |
| slug         | no        | A string that conforms to the rules of [slug](#property-slug)        |
| name         | no        | A string.                                                            |
| description  | no        | A string.                                                            |
| keywords     | no        | A list of strings.                                                   |
| sections     | no        | A map that conforms to the rules of [sections](#property-sections)   |
| last_updated | no        | A string.                                                            |
| latest-security-release | no | A string conforming to the rules of [version](#property-version) |
| _links       | no        | [HAL links][hal], with [defined relationships](#links-metadata)      |

The properties of the metadata document have the following semantic meanings and constraints.


### id

The `id` property specifies the Package ID. This property MUST be specified.

This property MUST be a valid DID.

Clients SHOULD verify this ID against the DID used to look up the metadata document. If the ID specified in the Metadata Document does not match the expected ID, Clients MUST stop processing the document and MUST NOT treat the document as valid for the expected ID.


### type

<a name="property-type"></a>

The `type` property specifies the Package type. This property MUST be specified.

This property MUST be a valid string. The property SHOULD use a type defined in the [type registry][type-registry].

Custom or non-standard types SHOULD be prefixed with `x-` to indicate they are non-standard.

Clients MUST NOT install Packages with a `type` they do not have a semantic understanding of. When installation of a Package with an unknown `type` is attempted, Clients MUST surface an error message.

Example:

> Could not install: unsupported Package ecosystem.

[type-registry]: ./registry.md#package-types


### license

<a name="property-license"></a>

The `license` property specifies the license of the Package. This property MUST be specified.

This property MUST be a valid [SPDX License Expression][spdx-expr], or the string "proprietary".

Clients SHOULD refuse to install Packages which do not have a valid license.

[spdx-expr]: https://spdx.github.io/spdx-spec/v3.0.1/annexes/spdx-license-expressions/


### authors

<a name="property-authors"></a>

The `authors` property specifies the authors of the Package. This property MUST be specified.

This property MUST be a valid list, represented as a JSON Array. The list MUST have at least one object.

The items of the list MUST be objects, with the following properties:

* `name` (required) - A string. Human-readable author name.
* `url` (optional) - A URL string. Used to link users to the author's site or a HTML page describing the author.
* `email` (optional) - An email address string. Used to link users to contact the author.

Vendors SHOULD specify at least one of `url` or `email` per author.

Clients MAY refuse to install Packages without at least one valid author.

Clients SHOULD present all authors to users when displaying metadata.


### security

<a name="property-security"></a>

The `security` property specifies the security contacts for the Package. This property MUST be specified.

This property MUST be a valid list, represented as a JSON Array. The list MUST have at least one object.

The items of the list MUST be objects, with the following properties:

* `url` (optional) - A URL string. Used to link users to a security contact form or information about the security of the Package.
* `email` (optional) - An email address string. Used to link users to contact a security notification email.

Vendors SHOULD specify at least one of `url` or `email` per security contact.

Clients SHOULD refuse to install Packages without at least one valid security contact.

Clients SHOULD present all security contacts to users when displaying metadata.


### releases

The `releases` property specifies releases available for the Package. This property MUST be specified.

This property MUST be a valid list, represented as a JSON Array.

The items of the list MUST be objects, conforming to the [Release Document](#release-document) specification.


### slug

<a name="property-slug"></a>

The `slug` property specifies the desired "slug" for the Package, which the Client may use for filenames or directory names when installing the Package.

The slug MUST be a string containing only alphanumeric characters, dashes, or underscores. The slug MUST start with an alphabetic character.

```
slug  = ALPHA *(ALPHA / DIGIT / "-" / "_")
```

Clients SHOULD validate the slug against these rules. If a slug does not validate, Clients MAY strip invalid characters to form a valid slug, or ignore the slug entirely.

Clients SHOULD use the slug for file or directory names used during installation of the Package, unless doing so would conflict with a different Package. Clients MAY deduplicate Packages with matching slugs (but differing IDs) in any way they see fit, including appending an incrementing counter to the slug or using the ID as part of the slug. Vendors SHOULD indicate a globally-unique slug if possible, such as a product name.


### name

The `name` property specifies a human-readable name for the Package, which the Client may display in index or list pages.

The name MUST be a string.


### description

The `description` property specifies a short description of the Package, which the Client may display in index or list pages.

The description MUST be a string.

The description SHOULD be written in plain text, and Clients MUST escape any special characters for the applicable formatting context (such as HTML). The description SHOULD NOT exceed 140 characters. Clients MAY truncate the description if it exceeds this limit.


### keywords

The `keywords` property specifies keywords to assist users in searching for Packages.

Keywords MUST be a list, represented as a JSON Array. The list SHOULD NOT contain more than 5 items. Clients MAY truncate the list to 5 items.

Each item of the array MUST be a string.


### sections

<a name="property-sections"></a>

The `sections` property specifies human-readable sections of text to display to users to provide them with information about the Package.

Sections MUST be a map, represented as a JSON Object.

The following keys and their semantic meaning are specified:

* `changelog` - A list of changes to the Package.
* `description` - The primary description and information for the Package.
* `security` - Information about the security of the Package and how to report vulnerabilities.

Other keys MAY be specified, and their meaning MAY be defined within extensions to this specification.

Clients SHOULD ignore any section which does not have an explicit semantic meaning specified.


### last_updated

The `last_updated` property specifies the date string the current Package was last updated.

The last_updated MUST be a string.

### latest-security-release

<a name="property-latest-security-release"></a>

The `latest-security-release` property specifies the version string of the most recent release for this Package that carries an `advisory` field.

This property MUST be a string conforming to the rules of [`version`](#property-version).

When present, Clients SHOULD compare this value against the currently installed version. If the installed version is lower than `latest-security-release`, Clients SHOULD notify the User that a security update is available.

```json
{
  "id": "did:plc:abc123...",
  "type": "wordpress-plugin",
  "latest-security-release": "2.1.1",
  "releases": [
    { "version": "2.1.1", "advisory": { "severity": "high", "summary": "..." }, "artifacts": { "..." : "..." } },
    { "version": "2.1.0", "artifacts": { "..." : "..." } },
    { "version": "2.0.0", "artifacts": { "..." : "..." } }
  ]
}
```

Repositories MUST update this field when a release carrying an `advisory` is published, if the new release version is greater than the current value. Repositories MUST NOT remove or reduce this field once set; it records the most recent security release ever published for the Package, not the current installable version. If a security release is subsequently deleted, `latest-security-release` MUST retain the deleted version's value.

Aggregators MUST surface this field when present and MAY use it as a signal for prioritized notifications to Users.

Clients MUST NOT rely on the presence of this field to conclude that no security releases exist. Repositories that have not yet implemented this field will not include it even when security releases are available.

### _links

<a name="links-metadata"></a>

Metadata Documents may have links to other resources, using the [HAL specification][hal], as provided in the `_links` property.

Metadata Documents SHOULD have a `https://fair.pm/rel/repo` link to the Repository Document for the release they belong to.

Metadata Documents MAY have a `https://fair.pm/rel/releases` link to a collection of Releases. This relationship may be used to indicate an endpoint which provides an exhaustive list of Releases, allowing the `releases` property to be used only for "active" releases.

If present, a `collection` link indicates an endpoint which lists Packages available from the Repository; in other words, the collection the Package belongs to. Clients MAY use this to discover other Packages available from the Repository.


## Release Document

A Release Document is a JSON document provided by a Repository which provides information about a release for a Package. "Valid" release documents are those which conform to this specification's rules for Release documents.

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
| sbom        | no        | Conforms to the rules of [sbom](#property-sbom)                      |
| advisory    | no        | Conforms to the rules of [advisory](#property-advisory)              |
| _links      | no        | [HAL links][hal], with [defined relationships](#links-release)       |

The properties of the release document have the following semantic meanings and constraints.


### version

<a name="property-version"></a>

The `version` property specifies the version for this release.

This property MUST be a string, consisting of up to 3 groups of numbers, separated by a period.

A pre-release version MAY be denoted by appending a hyphen and a series of dot-separated identifiers

Build metadata MAY be denoted by appending a plus sign and a series of dot separated-identifiers following the patch or pre-release version.

```
alphahyphen = ALPHA / DIGIT / "-"
prerelease  = 1*(alphahyphen) *("." 1*(alphahyphen))
metadata    = 1*(alphahyphen) *("." 1*(alphahyphen))
version     = 1*DIGIT *2("." 1*DIGIT) ["-" prerelease] ["+" metadata]
```

This property SHOULD be a valid version number conforming to the [Semantic Versioning Specification (SemVer)][semver], with the semantic meaning as described in that specification. Clients SHOULD parse the version number according to SemVer, and SHOULD use the version comparison rules specified in SemVer.

The build metadata MUST be ignored when determining version precedence.

#### Version immutability

A Repository MUST NOT modify or replace the artifacts or metadata of a published release for a given version. The first release record created for a version under a given Package DID is the canonical record.

Clients MUST retain the `checksum` value of installed releases. On update checks, if a Repository serves a release for a previously-installed version with a different `checksum`, Clients MUST reject the response and MUST alert the user.

Aggregators that index release records MUST ignore any record for a version that has already been indexed for the same Package DID. The earlier record is canonical; the later record is invalid and MUST be treated as if it were not present.

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

A common `package` artifact type is defined as the "primary" artifact representing the installable binary, as applicable to the specified Package type. The `package` type MUST specify the `url` property, and SHOULD specify the `signature`, and `checksum` properties.

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

If the `requires-auth` property is true, Clients SHOULD perform authentication prior to accessing the URL, according to the [auth](#property-auth) property of the release.


### release-asset

The `release-asset` property indicates that the artifact URL points to a platform release asset rather than a directly-served file.

The `release-asset` property MUST be a boolean. If omitted, Clients MUST treat the value as `false`.

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

The `url` property specifies the URL where a Client can access an asset.

Clients MAY embed assets from URLs directly; for example, images may be embedded directly into a Client without downloading them directly.


#### signature

The `signature` property specifies the cryptographic signature of the asset.

Signatures MUST be generated using the appropriate signature method for one of the valid signing keys specified by the [DID Document](#did-document). If the signature is not valid for any of the signing keys, Clients MUST reject the artifact and MUST NOT process the artifact further.


#### checksum

The `checksum` property specifies a checksum used to validate the data integrity of the artifact.

Checksums MUST be specified as a string, as defined in [checksum][#checksum].

Extensions MAY specify additional valid checksum algorithms. Custom or non-standard types SHOULD be prefixed with `x-` to indicate they are non-standard.


### provides

<a name="property-provides"></a>

The `provides` property specifies capabilities that the Package provides, as applicable to the [package type](#property-type).

This property MUST be a valid map, represented as a JSON Object.

The properties of the map represent the capability type, as applicable to the [package type](#property-type). Custom or non-standard types SHOULD be prefixed with `x-` to indicate they are non-standard.

The values of the map MUST be strings or lists of strings.


### requires

<a name="property-requires"></a>

The `requires` property specifies dependencies that the Package requires in order to be usable.

This property MUST be a valid map, represented as a JSON Object.

The keys of the object MUST be strings. The keys MUST be either a Package DID or an environment requirement prefixed with `env:`. Package DID keys MUST conform to the DID specification and SHOULD refer to valid Package IDs.

The values of the object MUST be strings. The values are version constraints specifying which releases for the Package are valid to fulfill the requirement.

Clients SHOULD resolve the requirements of the Package before completing installation, and SHOULD NOT install the Package if the requirements cannot be resolved.

Environment requirements prefixed with `env:` are type-specific, and are specified by extensions to this specification. If a Client does not recognise an environment requirement, it SHOULD treat the requirement as being unfulfilled, and SHOULD NOT install the Package.


### suggests

<a name="property-suggests"></a>

The `suggests` property specifies Packages that can be installed alongside the Package being installed.

This property matches the format of the [`requires` property](#property-requires).

### auth

<a name="property-auth"></a>

The `auth` property specifies authentication requirements to access the Package.

This property MUST be a valid object, conforming to the authentication method being used. The `type` property of this object indicates the authentication method being used. The authentication method SHOULD be a method defined in the [authentication registry][auth-registry].

Custom or non-standard methods SHOULD be prefixed with `x-` to indicate they are non-standard.

Common properties of the object are defined as:

* `type` (required) - The authentication method being used.
* `hint` (optional) - A human-readable hint to the authentication method.
* `hint_url` (optional) - A URL for more information about the required authentication.

Extensions MAY specify additional properties which are type-specific.

Clients which do not recognise the method being used SHOULD display the `hint` and `hint_url` to the user. Repositories SHOULD include the `hint` and `hint_url` properties.

Authentication may be used for limited-access Packages, such as those requiring purchase, and Clients SHOULD display the `hint` and `hint_url` to the user to ensure they understand why access is limited.

Access to individual artifacts may be limited on a per-artifact basis using the `requires-auth` property on the artifact. The presence of this flag indicates Clients must authenticate in order to access the artifact.

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

The hint SHOULD be written in plain text, and Clients MUST escape any special characters for the applicable formatting context (such as HTML). The hint SHOULD NOT exceed 140 characters. Clients MAY truncate the hint if it exceeds this limit.


#### hint_url

The `hint_url` property specifies a URL which provides more information about the authentication requirements for the Package.

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

### advisory

<a name="property-advisory"></a>

The `advisory` property indicates that this release addresses one or more security vulnerabilities.

This property MAY be a single advisory object or a list of advisory objects. Clients MUST handle both forms. When the release addresses a single vulnerability, a single object MAY be used. When the release addresses multiple distinct vulnerabilities, a list MUST be used.

An advisory object is a JSON Object with the following properties:

* `severity` (required) — A string indicating the severity of the vulnerability. MUST be one of `low`, `medium`, `high`, or `critical`. Severity levels correspond to CVSS v3 base score ranges: `low` (0.1–3.9), `medium` (4.0–6.9), `high` (7.0–8.9), `critical` (9.0–10.0).
* `summary` (required) — A string providing a brief human-readable description of the vulnerability. SHOULD NOT exceed 200 characters. Clients MAY truncate the summary if it exceeds this limit. The summary SHOULD be written in plain text; Clients MUST escape any special characters for the applicable formatting context.
* `identifiers` (optional) — A list of objects identifying the vulnerability in external databases. Each object MUST have a `type` string (such as `CVE`, `GHSA`, or `WP-VULN`) and a `value` string containing the identifier value. Clients SHOULD link to the relevant database entry where possible.
* `affected-versions` (optional) — A string specifying the version range affected by the vulnerability, using the same semver constraint syntax as the `requires` property. Clients MAY use this to determine whether an installed version is affected.
* `url` (optional) — A URL string pointing to a full advisory document. Clients SHOULD display this to users when surfacing advisory information.

```json
{
  "version": "2.1.1",
  "advisory": {
    "severity": "high",
    "summary": "Unauthenticated SQL injection via the search parameter.",
    "identifiers": [
      { "type": "CVE", "value": "CVE-2026-12345" },
      { "type": "GHSA", "value": "GHSA-xxxx-xxxx-xxxx" }
    ],
    "affected-versions": ">=2.0.0 <2.1.1",
    "url": "https://example.com/security/advisories/2026-001"
  },
  "artifacts": {
    "package": [
      {
        "url": "https://example.com/releases/my-plugin-2.1.1.zip",
        "checksum": "sha256:abc123...",
        "signature": "z..."
      }
    ]
  }
}
```

A release that does not address a security vulnerability MUST NOT include the `advisory` property. Clients MUST NOT infer that the absence of an `advisory` field means the release is free of security issues.

When a release addresses multiple distinct vulnerabilities:

```json
{
  "version": "2.1.1",
  "advisory": [
    {
      "severity": "critical",
      "summary": "Remote code execution via crafted file upload.",
      "identifiers": [{ "type": "CVE", "value": "CVE-2026-11111" }],
      "affected-versions": ">=1.0.0 <2.1.1"
    },
    {
      "severity": "medium",
      "summary": "Stored XSS in the admin settings panel.",
      "identifiers": [{ "type": "CVE", "value": "CVE-2026-22222" }],
      "affected-versions": ">=2.0.0 <2.1.1"
    }
  ],
  "artifacts": { "package": [ { ... } ] }
}
```

Clients SHOULD surface advisory information to users during installation or update operations. When multiple advisories are present, Clients SHOULD present the highest severity level prominently.

Clients that do not implement advisory handling MUST ignore this property and MUST continue to process the release document normally.

Aggregators MUST index the `advisory` field when present and MUST expose it in any API responses that include release data.

### _links

<a name="links-release"></a>

Release Documents may have links to other resources, using the [HAL specification][hal], as provided in the `_links` property.

If a Release Document is embedded within another resource, such as a Metadata Document, links which are the same as the parent document SHOULD be omitted.

Release Documents SHOULD have a `https://fair.pm/rel/repo` link to the Repository Document for the release they belong to.

Release Documents SHOULD have a `https://fair.pm/rel/package` link to the Metadata Document for the Package they belong to.


## Repository Document

A Repository Document is a JSON document provided by a Repository which provides information about the Repository itself.

The Repository Document informs users about the people or organizations running the Repository, as well as policies for the Repository.

Valid Repository documents MUST conform to the JSON-LD specification. When presented as a standalone document, the Repository document MUST include a `@context` entry. The `@context` entry MUST be either the JSON String `https://fair.pm/ns/repository/v1` or a JSON Array where the first item is the JSON String `https://fair.pm/ns/repository/v1`.

The following properties are defined for the Repository document:

| Property    | Required? | Constraints                                                                    |
| ----------- | --------- | ------------------------------------------------------------------------------ |
| name        | yes       | A string.                                                                      |
| maintainers | yes       | A list that conforms to the rules of [maintainers](#property-repo-maintainers) |
| security    | yes       | A list that conforms to the rules of [security](#property-repo-security)       |
| privacy     | yes       | A URL string.                                                                  |
| _links      | no        | [HAL links][hal], with [defined relationships](#links-repo)                    |

The properties of the Repository document have the following semantic meanings and constraints.


### name

The `name` property specifies a human-readable name for the Repository, which the Client may display in index or list pages.

The name MUST be a string.


### maintainers

<a name="property-repo-maintainers"></a>

The `maintainers` property specifies the maintainers of the Repository. This property MUST be specified.

This property MUST be a valid list, represented as a JSON Array. The list MUST have at least one object.

The items of the list MUST be objects, with the following properties:

* `name` (required) - A string. Human-readable maintainer name.
* `url` (optional) - A URL string. Used to link users to the maintainer's site or a HTML page describing the maintainer.
* `email` (optional) - An email address string. Used to link users to contact the maintainer.

Repositories SHOULD specify at least one of `url` or `email` per maintainer.

Clients SHOULD present all maintainers to users when displaying Repository data.


### security

<a name="property-repo-security"></a>

The `security` property specifies the security contacts for the Repository. This property MUST be specified.

This property MUST be a valid list, represented as a JSON Array. The list MUST have at least one object.

The items of the list MUST be objects, with the following properties:

* `url` (optional) - A URL string. Used to link users to a security contact form or information about the security of the Package.
* `email` (optional) - An email address string. Used to link users to contact a security notification email.

Vendors SHOULD specify at least one of `url` or `email` per security contact.

If the `security` property is not specified, Clients SHOULD block installation of Packages from the Repository, and SHOULD display a warning to the user.

Clients SHOULD present all security contacts to users when displaying Repository data.


### privacy

The `privacy` property specifies the location of the privacy policy for the Repository. This property MUST be specified.

If the `privacy` property is not specified, Clients SHOULD block installation of Packages from the Repository, and SHOULD display a warning to the user.


### _links

<a name="links-repo"></a>

Repository Documents may have links to other resources, using the [HAL specification][hal], as provided in the `_links` property.


## Caching

Clients MAY choose to use an external cache of Package data instead of fetching it directly from the Repository. In particular, external caches may be used for artifacts such as the main installable Package, to reduce bandwidth costs and latency.

External caches SHOULD only cache signed artifacts that can be independently-verified to contain data valid for the Package.

Clients SHOULD only use trusted external caches, such as those provided by the same infrastructure provider as the Client or on the same machine.

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

As the FAIR Protocol specification and its extensions evolve, Clients need predictable guarantees about backward compatibility. The following rules govern how document schemas may change.

### Additive-optional fields only.

New properties MAY be added to any document type at any time, provided they are optional. Clients MUST ignore properties they do not recognize and continue to process the document normally.

### No narrowing of existing fields.

An existing property:

* MUST NOT be made required if it was previously optional.
* MUST NOT have its type changed.
* MUST NOT have its validation rules tightened.
* MUST NOT be renamed.

Each of these are considered breaking changes.

### Breaking changes require a new context URL.

If a genuinely incompatible shape is needed for a document type, a new JSON-LD context URL MUST be introduced. The old context URL and its associated document shape MUST remain valid for all documents that reference it.

### Extensions follow the same rules.

Extension authors MUST treat extension-defined document shapes as subject to these constraints once the extension is deployed and indexed by Aggregators. An extension update that would break deployed Clients requires a new extension identifier.


## Link Relationships

The following link relationships are defined, such as for links specified by [HAL links][hal] (in the `_links`) property of a document).

| Relation                       | Description                                                  |
| ------------------------------ | ------------------------------------------------------------ |
| `https://fair.pm/rel/repo`     | Link to [Repository Document](#repository-document)          |
| `https://fair.pm/rel/package`  | Link to [Metadata Document](#metadata-document)              |
| `https://fair.pm/rel/releases` | Link to collection of [Release Documents](#release-document) |

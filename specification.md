# FAIR Package Management Protocol

FAIR (Federated and Independent Repositories) Package Management Protocol is a system for distributing installable software.

This specification outlines the core FAIR protocol specification ("FAIR Core"). Ecosystem-specific extensions are implemented as extensions to this specification, as defined in the [extension registry](./registry.md).


## Definitions

- *aggregator* - Any server which aggregates or collects package data together.
- *client* - An entity which requests packages.
- *DID* - Decentralized ID, a universally-unique identifier specified by the W3C specification.
- *package* - Any installable software, consisting of an ID, metadata, and associated assets.
- *package binary* - An asset such as a zip file containing the package's binary executable code.
- *repository* - Any server which offers packages, following the Repository APIs.
- *user* - An end-user directing a client to operate.
- *vendor* - An entity which publishes packages through a repository.


## Introduction

In a traditional package management system, a package manager client contacts a central repository to query which packages are available, to get information on each package and check for updates, and to download the package binaries themselves.

For large ecosystems, this central repository may host packages from many independent vendors.

This system has several problems and limitations:

* Trust in packages derives from trust in the central repository, not independently in packages.
* If trust erodes in the central repository, vendors have little recourse to select alternatives (data portability).
* Even when alternatives can be created (such as by altering the package management system), packages hosted on any alternative repository are difficult for users to find.

The FAIR Protocol addresses these issues by separating package identifiers, package repositories, and other services into a decentralized system.

Each package in the FAIR system is uniquely identified by a [Decentralized Identifier (DID)][did]. The DID is used to identify the package, deduplicate any information about it, and to fetch the DID Document which contains information such as the repository location and cryptographic signing keys. The DID acts as a permanent, globally-unique, host-independent identifier which vendors control.

Package vendors may choose any repository, including running their own or using a repository provider they trust. They may change repositories by pointing the DID to a different repository, giving them data portability.

Each repository may operate fully independently, and clients may interact exclusively with the repository (and DID resolution mechanisms) - the "small web view". However, by itself this can present a bootstrapping problem: how do clients learn about new packages and repositories?

To bring this ecosystem back together (the "big web view"), "aggregators" collect package data from many repositories together, such as discovery services and caching.

As each package is uniquely identified by DID, decentralized "overlay" services may provide additional data about packages, such as moderation services and review systems.


### Protocol Flow

The FAIR system focusses on three key flows:

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

The FAIR Protocol is built on top of [HTTP][http], and the use of any other protocol is out of scope. Unless otherwise specified, all HTTP protocols MUST use Transport Layer Security (TLS).

Documents in the FAIR Protocol use [JSON-LD][json-ld] to provide context on the data within each document, allowing clients to identify the document type they are working on.

Links within JSON-LD documents use [Hypertext Application Language (HAL)][hal] to link to related resources.

[hal]: https://datatracker.ietf.org/doc/html/draft-kelly-json-hal-11
[http]: https://datatracker.ietf.org/doc/html/rfc7230
[json-ld]: https://www.w3.org/TR/json-ld11/


## Resolving DIDs

Packages are uniquely identified by a [Decentralized Identifier (DID)][did].

The following [DID methods][did-methods] MUST be supported as package IDs by compliant clients:

* [plc](https://github.com/did-method-plc/did-method-plc)
* [web](https://w3c-ccg.github.io/did-method-web/)

Additionally, clients must support the [key method](https://w3c-ccg.github.io/did-key-spec/) for cryptographic signatures.

Clients MUST resolve DIDs to a DID Document following the method-specific resolution rules.

Clients MAY cache a mapping of DID to DID Document for up to 24 hours. Clients MUST revalidate this mapping after 24 hours, to ensure that key revocation or repository changes are propagated within this time.

Vendors SHOULD use DID methods that are future-proof for data portability, and which avoid encoding trademarks or potentially-ephemeral names or domains.

[did-methods]: https://www.w3.org/TR/did-extensions-methods/


## DID Document

DID Documents contain information for use by FAIR clients. "Valid" DID Documents are those which conform to this specification's rules for DID Documents.

Valid documents MUST contain a service of type `FairPackageManagementRepo` with a valid URL (the "repo URL"). Documents without this type of service or without a valid URL MUST be considered invalid, and clients SHOULD cease further processing.

The repo URL SHOULD point to a valid [Metadata Document](#metadata-document) available via the HTTP protocol. Clients SHOULD ensure they have robust error handling if this URL is invalid, such as if the server is unavailable.

Valid documents SHOULD NOT contain multiple services without the `FairPackageManagementRepo` type unless specified by an extension to this specification. Clients which assume a single repository MUST use the first service with the matching type in the [set][ordered-set].

Valid documents MUST contain one or more verification methods in the `verificationMethod` property. Valid verification methods MUST have the type `Multibase`, and MUST use an ID where the non-fragment parts of the URL match the DID, and where the fragment part starts with `fair_`.

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

A Metadata Document is a JSON document provided by a repository which provides information about a specific package. The Metadata Document is specified for a given package by the `FairPackageManagementRepo` service in the [DID Document](#did-document). "Valid" metadata documents are those which conform to this specification's rules for Metadata Documents.

Valid metadata documents MUST conform to the JSON-LD specification. When presented as a standalone document, the metadata document MUST include a `@context` entry. The `@context` entry MUST be either the JSON String `https://fair.pm/ns/metadata/v1` or a JSON Array where the first item is the JSON String `https://fair.pm/ns/metadata/v1`.

The following properties are defined for the metadata document:

| Property    | Required? | Constraints                                                         |
| ----------- | --------- | ------------------------------------------------------------------- |
| id          | yes       | A valid DID.                                                        |
| type        | yes       | A string that conforms to the rules of [type](#property-type).      |
| license     | yes       | A string that conforms to the rules of [license](#property-license) |
| authors     | yes       | A list that conforms to the rules of [authors](#property-authors)   |
| security    | yes       | A list that conforms to the rules of [security](#property-security) |
| releases    | yes       | A list of [Releases](#release-document)                             |
| slug        | no        | A string that conforms to the rules of [slug](#property-slug)       |
| name        | no        | A string.                                                           |
| description | no        | A string.                                                           |
| keywords    | no        | A list of strings.                                                  |
| sections    | no        | A map that conforms to the rules of [sections](#property-sections)  |
| _links      | no        | [HAL links][hal], with [defined relationships](#links-metadata)     |

The properties of the metadata document have the following semantic meanings and constraints.


### id

The `id` property specifies the package ID. This property MUST be specified.

This property MUST be a valid DID.

Clients SHOULD verify this ID against the DID used to look up the metadata document. If the ID specified in the Metadata Document does not match the expected ID, clients MUST stop processing the document and MUST NOT treat the document as valid for the expected ID.


### type

<a name="property-type"></a>

The `type` property specifies the package type. This property MUST be specified.

This property MUST be a valid string. The property SHOULD use a type defined in the [type registry][type-registry].

Custom or non-standard types SHOULD be prefixed with `x-` to indicate they are non-standard.

Clients SHOULD refuse to process types which they do not have a semantic understanding of.

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

Vendors SHOULD specify at least one of `url` or `email` per author.

Clients MAY refuse to install packages without at least one valid author.

Clients SHOULD present all authors to users when displaying metadata.


### security

<a name="property-security"></a>

The `security` property specifies the security contacts for the package. This property MUST be specified.

This property MUST be a valid list, represented as a JSON Array. The list MUST have at least one object.

The items of the list MUST be objects, with the following properties:

* `url` (optional) - A URL string. Used to link users to a security contact form or information about the security of the package.
* `email` (optional) - An email address string. Used to link users to contact a security notification email.

Vendors SHOULD specify at least one of `url` or `email` per security contact.

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

Clients SHOULD use the slug for file or directory names used during installation of the package, unless doing so would conflict with a different package. Clients MAY deduplicate packages with matching slugs (but differing IDs) in any way they see fit, including appending an incrementing counter to the slug or using the ID as part of the slug. Vendors SHOULD indicate a globally-unique slug if possible, such as a product name.


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


### _links

<a name="links-metadata"></a>

Metadata Documents may have links to other resources, using the [HAL specification][hal], as provided in the `_links` property.

Metadata Documents SHOULD have a `https://fair.pm/rel/repo` link to the Repository Document for the release they belong to.

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
| require     | no        | A map that conforms to the rules of [require](#property-require)     |
| suggest     | no        | A map that conforms to the rules of [suggest](#property-suggest)     |
| auth        | no        | A map that conforms to the rules of [auth](#property-auth)           |
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


### artifacts

<a name="property-artifacts"></a>

The `artifacts` property specifies the artifacts for the release. This property MUST be specified.

This property MUST be a valid map, represented as a JSON Object. The map MUST have at least one entry.

The properties of the map represent the artifact type, as applicable to the [package type](#property-type).

Custom or non-standard types SHOULD be prefixed with `x-` to indicate they are non-standard.

The values of the map MUST be objects or lists of objects, with the following common properties:

* `id` (optional) - A unique ID for the artifact.
* `content-type` (optional) - The MIME type of the artifact.
* `requires-auth` (optional) - A boolean indicating if the artifact needs authentication to access.
* `url` (optional) - A URL string. Used to download the artifact.
* `signature` (optional) - A cryptographic signature of the artifact.
* `checksum` (optional) - A cryptographic checksum of the artifact.

Extensions MAY specify additional properties which are type-specific.

A common `package` artifact type is defined as the "primary" artifact representing the installable binary, as applicable to the specified package type. The `package` type MUST specify the `url` property, and SHOULD specify the `signature`, and `checksum` properties.

The properties of these objects have the following semantic meanings and constraints.


#### id

The `id` property specifies a unique asset ID, which can be used to distinguish between multiple assets of the same type.

When specified, the `id` MUST be unique in the list of assets for the same type. The `id` MAY be the same as assets of a different type, and no special semantic meaning is defined if they are the same.


#### content-type

The `content-type` property specifies the MIME type of the artifact.

The `content-type` property MUST conform to [RFC6838][rfc6838].

Clients MAY choose to select the most appropriate artifact for download based on the MIME type.

[rfc6838]: https://datatracker.ietf.org/doc/html/rfc6838


#### auth

The `auth` property specifies whether the artifact requires authentication to access.

The `auth` property MUST be a boolean.

If the `auth` property is true, clients SHOULD perform authentication prior to accessing the URL, according to the [auth](#property-auth) property of the release.


#### url

The `url` property specifies the URL where a client can access an asset.

Clients MAY embed assets from URLs directly; for example, images may be embedded directly into a client without downloading them directly.


#### signature

The `signature` property specifies the cryptographic signature of the asset.

Signatures MUST be generated using the appropriate signature method for one of the valid signing keys specified by the [DID Document](#did-document). If the signature is not valid for any of the signing keys, clients MUST reject the artifact and MUST NOT process the artifact further.


#### checksum

The `checksum` property specifies a checksum used to validate the data integrity of the artifact.

Checksums MUST be specified as a string, with the checksum value prefixed with the checksum function and a colon character. The valid checksum algorithms are:

* `sha256`
* `sha384`

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


### suggest

<a name="property-suggest"></a>

The `suggest` property specifies packages that can be installed alongside the package being installed.

This property matches the format of the [`requires` property](#property-requires).


### auth

<a name="property-auth"></a>

The `auth` property specifies authentication requirements to access the package.

This property MUST be a valid object, conforming to the authentication method being used. The `type` property of this object indicates the authentication method being used. The authentication method SHOULD be a method defined in the [authentication registry][auth-registry].

Custom or non-standard methods SHOULD be prefixed with `x-` to indicate they are non-standard.

Common properties of the object are defined as:

* `type` (required) - The authentication method being used.
* `hint` (optional) - A human-readable hint to the authentication method.
* `hint_url` (optional) - A URL for more information about the required authentication.

Extensions MAY specify additional properties which are type-specific.

Clients which do not recognise the method being used SHOULD display the `hint` and `hint_url` to the user. Repositories SHOULD include the `hint` and `hint_url` properties.

Authentication may be used for limited-access packages, such as those requiring purchase, and clients SHOULD display the `hint` and `hint_url` to the user to ensure they understand why access is limited.

Access to individual artifacts may be limited on a per-artifact basis using the `requires-auth` property on the artifact. The presence of this flag indicates clients must authenticate in order to access the artifact.

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


### _links

<a name="links-release"></a>

Release Documents may have links to other resources, using the [HAL specification][hal], as provided in the `_links` property.

If a Release Document is embedded within another resource, such as a Metadata Document, links which are the same as the parent document SHOULD be omitted.

Release Documents SHOULD have a `https://fair.pm/rel/repo` link to the Repository Document for the release they belong to.

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

Vendors SHOULD specify at least one of `url` or `email` per security contact.

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


## JSON-LD Contexts

The following JSON-LD contexts are registered by this specification.

| Context                            | Document                                    |
| ---------------------------------- | ------------------------------------------- |
| `https://fair.pm/ns/metadata/v1`   | [Metadata Document](#metadata-document)     |
| `https://fair.pm/ns/release/v1`    | [Release Document](#release-document)       |
| `https://fair.pm/ns/repository/v1` | [Repository Document](#repository-document) |


## Link Relationships

The following link relationships are defined, such as for links specified by [HAL links][hal] (in the `_links`) property of a document).

| Relation                       | Description                                                  |
| ------------------------------ | ------------------------------------------------------------ |
| `https://fair.pm/rel/repo`     | Link to [Repository Document](#repository-document)          |
| `https://fair.pm/rel/package`  | Link to [Metadata Document](#metadata-document)              |
| `https://fair.pm/rel/releases` | Link to collection of [Release Documents](#release-document) |

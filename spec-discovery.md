# FAIR Package Management Protocol – Discovery

FAIR (Federated and Independent Repositories) Package Management Protocol is a system for distributing installable software.

This specification outlines the discovery aggregator protocol ("FAIR Discovery"). Definitions here are as in [FAIR Core][]. Ecosystem-specific extensions are implemented as extensions to this specification, as defined in the [extension registry](./registry.md).

[FAIR Core]: ./specification.md

## Definitions

- *aggregator* - Any server which aggregates or collects package data together.
- *client* - An entity which requests packages.
- *DID* - Decentralized ID, a universally-unique identifier specified by the W3C specification.
- *package* - Any installable software, consisting of an ID, metadata, and associated assets.
- *package binary* - An asset such as a zip file containing the package's binary executable code.
- *repository* - Any server which offers packages, following the Repository APIs as defined in [FAIR Core][].
- *user* - An end-user directing a client to operate.
- *vendor* - An entity which publishes packages through a repository.


## Introduction

In a traditional package management system, a package manager client contacts a central repository to query which packages are available, to get information on each package and check for updates, and to download the package binaries themselves.

The [FAIR Protocol][FAIR Core] addresses these issues by separating package identifiers, package repositories, and other services into a decentralized system.

Each repository may operate fully independently, and clients may interact exclusively with the repository (and DID resolution mechanisms) - the "small web view". However, by itself this can present a bootstrapping problem: how do clients learn about new packages and repositories?

To bring this ecosystem back together (the "big web view"), "aggregators" collect package data from many repositories together, such as discovery services and caching.


### Protocol Flow

The FAIR system focusses on three key flows:

* **Discovery** - A user wants to find a package which fulfills their need, without knowing a specific package.
* **Installation** - A client wants to install a package identified by DID.
* **Updating** - A client wants to check for and install updates for a package identified by DID.


[did]: https://www.w3.org/TR/did-1.0/


#### Discovery

...


## Discovery Aggregator Protocol

Discovery aggregators are services which index packages, and offer browsing, search, and other querying services across packages. They act effectively as search engines for the FAIR system.

The discovery protocol provides a set of common APIs to provide for interoperability between discovery aggregators.

Discovery aggregators are identified by their root URL (for example, `https://discovery.example/`). The root URL may be at the base of a domain (i.e. `/`) or at a subdirectory (e.g. `/discovery/`).


### Index Endpoint

The index endpoint for a discovery aggregator is available at the root URL. This endpoint is a read endpoint, accepting HTTP GET requests. The response format for the index endpoint is the Discovery Index Document.

The index endpoint indicates what operations the aggregator supports, such as extensions to this specification.

Valid index documents MUST conform to the JSON-LD specification. When presented as a standalone document, the index document MUST include a `@context` entry. The `@context` entry MUST be either the JSON String `https://fair.pm/ns/discovery/v1` or a JSON Array where the first item is the JSON String `https://fair.pm/ns/discovery/v1`.

The following properties are defined for the index document:

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


### Listing Endpoint

The listing endpoint for a discovery aggregator is available at `{root}/packages` (e.g. `https://discovery.example/packages`).

Aggregators MUST support an optional trailing slash on the URL, and responses to this URL SHOULD issue a HTTP redirect to the canonical URL.

The response format of the listing endpoint MUST be a JSON array, where each object in the array MUST be a Metadata Document.

The endpoint has the following query string parameters:

| Parameter   | Constraints                                                         |
| ----------- | ------------------------------------------------------------------- |
| page        | A number greater than or equal to 1.                                |

The endpoint has the following defined headers:

| Header Name       | Required? | Value Constraints                                            |
| ----------------- | --------- | ------------------------------------------------------------ |
| Link              | no        | [RFC8288 Section 3][rfc8288s3] Link header.                  |
| X-FAIR-Total      | yes       | A number, indicating the total number of available packages. |
| X-FAIR-TotalPages | yes       | A number, indicating the total number of available pages.    |

The Link header SHOULD contain `next` and `prev` links for each page of the collection.

[rfc8288s3]: https://datatracker.ietf.org/doc/html/rfc8288#section-3


### Single Package Endpoint

The single package endpoint for a discovery aggregator is available at `{root}/packages/:id`, where `:id` represents a package ID.

Aggregators MUST support an optional trailing slash on the URL, and responses to this URL SHOULD issue a HTTP redirect to the canonical URL.

The response format of the single package endpoint MUST be the Metadata Document for the requested package.

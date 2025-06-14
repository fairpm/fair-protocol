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

When a user does not know which specific package they want to install, they need to discover packages meeting their criteria.

Clients interact with discovery aggregators to find packages meeting user-provided criteria.

Once the user has selected a particular package, the package DID is used for the Installation flow described in [FAIR Core][].

Clients may offer users a choice of aggregator, allowing for user choice in which packages are available or how discovery takes place. The discovery protocol standardizes several APIs to permit this ability for clients to swap aggregators.


## Discovery Protocol

Discovery aggregators are services which index packages, and offer browsing, search, and other querying services across packages. They act effectively as search engines for the FAIR system.

The discovery protocol provides a set of common APIs to provide for interoperability between discovery aggregators. This allows clients to switch between discovery aggregators, providing user choice.

The discovery protocol is built on top of [HTTP][http], and the use of any other protocol is out of scope. Unless otherwise specified, all HTTP protocols MUST use Transport Layer Security (TLS). The discovery protocol follows [REST semantics][rfc9205] where possible.

Discovery aggregators are identified by their root URL (for example, `https://discovery.example/`). The root URL may be at the base of a domain (i.e. `/`) or at a subdirectory (e.g. `/discovery/`).

[rfc9205]: https://datatracker.ietf.org/doc/html/rfc9205


### Index Endpoint

The index endpoint for a discovery aggregator is available at the root URL. This endpoint is a read endpoint, accepting HTTP GET requests. The response format for the index endpoint is the Discovery Index Document.

The index endpoint indicates what operations the aggregator supports, such as extensions to this specification.

Valid index documents MUST conform to the JSON-LD specification. When presented as a standalone document, the index document MUST include a `@context` entry. The `@context` entry MUST be either the JSON String `https://fair.pm/ns/discovery/v1` or a JSON Array where the first item is the JSON String `https://fair.pm/ns/discovery/v1`.

The following properties are defined for the index document:

| Property    | Required? | Constraints                                                            |
| ----------- | --------- | ---------------------------------------------------------------------- |
| contacts    | yes       | An object that conforms to the rules of [contacts](#property-contacts) |
| policies    | yes       | An object that conforms to the rules of [policies](#property-policies) |
| name        | no        | A string.                                                              |
| _links      | no        | [HAL links][hal], with [defined relationships](#links-index)           |

The properties of the index document have the following semantic meanings and constraints.


### contacts

<a name="property-contacts"></a>

The `contacts` property specifies the contacts for the repository. This property MUST be specified.

This property MUST be a valid map, represented as a JSON Object.

The following keys and their semantic meaning are specified:

* `abuse` - An abuse contact. Used for abuse notifications.
* `security` - A security reporting contact. Used for security notifications.
* `technical` - A technical contact. Used for protocol update notifications or other technical issues.

Other keys MAY be specified, and their meaning MAY be defined within extensions to this specification.

The values of the map MUST be objects, with the following properties:

* `name` (optional) - A string. Human-readable name for the contact, such as a person or team name.
* `url` (optional) - A URL string. Must contain a contact form or similar mechanism to send information.
* `email` (optional) - An email address string.

Vendors MUST specify at least one of `url` or `email` per contact.

Clients SHOULD refuse to use an aggregator provided by a user without valid contacts. Clients SHOULD display links to the contacts to users.

Aggregators are expected to provide valid contacts. If valid contacts are not provided, or timely responses are not provided, clients and other ecosystem entities MAY refuse to accept federation and MAY block access to the aggregator entirely.


### policies

<a name="property-policies"></a>

The `policies` property specifies the policies for the repository. This property MUST be specified.

This property MUST be a valid map, represented as a JSON Object.

The following keys and their semantic meaning are specified:

* `abuse` - The abuse policy for the aggregator.
* `privacy` - The privacy policy for the aggregator.

The values of the map MUST be URL strings.

Clients SHOULD refuse to use an aggregator provided by a user without valid policies.

Clients SHOULD display links to the policy documents to users.

Aggregators are expected to provide valid policies. If valid policies are not provided, clients and other ecosystem entities MAY refuse to accept federation and MAY block access to the aggregator entirely.


### name

The `name` property specifies a human-readable name for the aggregator, which the client may display on an information screen.

The name MUST be a string.


### _links

<a name="links-index"></a>

The index endpoint may have links to other resources, using the [HAL specification][hal], as provided in the `_links` property.

If present, an `alternate` link with a content-type matching `text/html` indicates a human-readable HTML page for the aggregator.


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

# FAIR Labeling Protocol

FAIR (Federated and Independent Repositories) Package Management Protocol is a system for distributing installable software.

This specification outlines the labeling protocol, used to provide fixed metadata for packages and releases. It extends and refers to [FAIR Core](./specification.md).


## Introduction

In a traditional package management system, a package manager client contacts a central repository to query which packages are available, to get information on each package and check for updates, and to download the package binaries themselves.

The FAIR Protocol moves towards a decentralized system by separating package identifiers, package repositories, and other services.

This creates a potential issue: how can moderation be applied at scale across the decentralized web of repositories?

FAIR Labeling provides a decentralized way to solve this, based on the Stackable Moderation concepts pioneered by AT Protocol.


### Example

A labeling service hosted at `https://moderator.example` provides a label query endpoint at `https://moderator.example/query`.

A FAIR client sends a GET request to this endpoint, asking for labels for release 1.2.3 of a package with ID `did:plc:a1b2c3d4e5f6`. This release is identified by the URI `fairpm:did:plc:a1b2c3d4e5f6/releases/1.2.2`.

The labeler responds with one label for the release itself (which is negative), and one for the package (which is positive):

```
GET /query?ids=fairpm:did:plc:a1b2c3d4e5f6/releases/1.2.3

HTTP/1.1 200 OK
Content-Type: application/json

[
	{
		"source": "https://moderator.example",
		"subject": "fairpm:did:plc:a1b2c3d4e5f6/releases/1.2.3",
		"value": "vulnerable:high",
		"context": {
			"message": "Release contains known security vulnerabilities (CVE-2025-1234).",
			"url": "https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2025-1234"
		},
		"date": "2025-10-31T01:23:45Z",
		"sig": "..."
	},
	{
		"source": "https://moderator.example",
		"subject": "fairpm:did:plc:a1b2c3d4e5f6",
		"value": "verified",
		"context": {
			"message": "moderator.example has manually verified this package's authenticity.",
			"url": "https://packages.example.com/did:plc:a1b2c3d4e5f6/verification"
		},
		"date": "2025-10-31T23:45:12Z",
		"sig": "..."
	}
]
```

The client can also report issues with a package or release by sending a POST request to a reporting endpoint at `https://moderator.example/report`:

```
POST /report
Content-Type: application/json

{
	"uri": "fairpm:did:plc:a1b2c3d4e5f6"
}
```

### Overview

Labeling services ("labelers") are services which can be queried for labels about packages or releases. Clients ask ("query") labelers for the labels they have for a given package or release.

A "label" is a structured piece of metadata to attach to the package or release, provided by the labeler. The label has a "value" - a fixed string indicating the type of label, as well as a "subject" indicating which entity the label applies to.

Labels can include "context", which provides human- and machine-readable detail about the label, such as a human-readable message or a URL where users can find more detail about the label.

FAIR clients check for labels on packages and releases at three distinct times:

1. **Installation** - Prior to installing a package, the client checks for labels on the package and selected release.
2. **Updating** - Prior to updating to the latest release, the client checks for labels on the new release.
3. **Periodic** - The client periodically re-checks installed packages for any new labels.


## URIs

Entities in the FAIR ecosystem may be uniquely identified by URIs with the protocol `fairpm`. These URIs are defined for two types of entity, packages and releases.

The `fairpm` URI syntax consists of a hierarchical scheme of components referred to as the scheme, authority, and path. These are compatible with generic URI syntax, with specific meaning for the `fairpm` protocol.

The following are two example URIs and their component parts:

         fairpm:did:plc:a1b2c3d4e5f6/releases/1.2.3
         \____/ \_________|_________/\_____________/
           |              |                 |
        scheme        authority           path
          _|__   _________|_____________________________________
         /    \ /                                               \
         fairpm:did:web:repository.packages.example:package:12345

Package URIs are formed by creating a URI with the scheme `fairpm` and authority set to the package DID.

For example, for a package with DID `did:web:package.example`, the package URI would be `fairpm:did:web:package.example`.

Release URIs are formed by creating a URI with the scheme `fairpm`, authority set to the package DID, and path set to a concatenated string of `/releases/` followed by the `version` of the release (as per the FAIR Core Release Document).

For example, for release with version `123.4.5` from a package with DID `did:web:package.example`, the release URI would be `fairpm:did:web:package.example/releases/123.4.5`.

The URI path MUST NOT be set to other values or contain other prefixes, to avoid conflicts with future changes to this specification. The URI query and fragment MUST be empty, to avoid conflicts with future changes to this specification that may assign meaning to these components.


## Defined Label Values

Labelers publish labels under a fixed set of label values, which have defined meaning and behaviour. Labelers SHOULD NOT use custom label values not defined in this specification, to avoid conflicts with future changes to this specification.

Each label values has defined meaning as listed below, as well as a positive, neutral, or negative sentiment indicating the impact of the label. Additionally, some label values have special meaning and behaviour, indicated by a `!` prefix.

The following fixed labels are defined:

| Label               | Sentiment  |
| ------------------- | ---------- |
| !block              | Negative   |
| !hide               | Negative   |
| !warn               | Negative   |
| verified            | Positive   |
| vulnerable:critical | Negative   |
| vulnerable:high     | Negative   |
| vulnerable:medium   | Negative   |
| vulnerable:low      | Negative   |

Clients MAY decide how to interpret and present labels to users, including user preferences, but MUST interpret special labels in accordance with this specification.


### !block

The `!block` special label value indicates clients MUST block this package or release from being installed. It does not provide any information about why the package or release is blocked. This is a negative signal.

This label value is only intended to be used where a more specific label value cannot be used, such as for legal reasons. Labelers SHOULD use this label sparingly, and SHOULD use non-special labels where possible.

Where possible, labelers SHOULD include information about the special block within the label context.


### !hide

The `!hide` special label value indicates clients MUST NOT display this package or release to users, and MUST block this package or release from being installed. It does not provide any information about why the package or release is blocked. This is a negative signal.

This label value is only intended to be used where a more specific label value cannot be used, such as for legal reasons. Labelers SHOULD use this label sparingly, and SHOULD use non-special labels where possible.

Where possible, labelers SHOULD include information about the special block within the label context.


### !warn

The `!warn` special label value indicates clients MUST display the warning included in the context before a package is installed. It does not provide any information about why the package or release is blocked. This is a negative signal.

This label value is only intended to be used where a more specific label value cannot be used, such as for legal reasons. Labelers SHOULD use this label sparingly, and SHOULD use non-special labels where possible.

Labelers MUST include information about the special block within the label context.


### verified

The `verified` label value indicates the labeler has verified the package or release according to its own processes. This is a positive signal.

The meaning of "verified" is specific to each labeler. Labelers are encouraged to include information about the verification within the label's context as well as publish information about the verification process for users.


### vulnerable

The `vulnerable:*` label values indicate the labeler believes the package or release contains software vulnerabilities which may make pose a risk to the user. This is a family of values prefixed with `vulnerable:`, with `critical`, `high`, `medium`, and `low` suffixes indicating the severity of the vulnerability. This is a negative signal.

The meaning of the suffix MAY be specific to each labeler. Labelers SHOULD use industry-standard meaning for severities, such as NVD CVSS qualitative severity ratings.

Clients SHOULD display vulnerability warnings to users prior to installation, depending on user preference. Clients SHOULD consider blocking installation of packages or releases with `vulnerable:critical` or `vulnerable:high` labels by default.


## Query Endpoint

The query endpoint for a labeler is available at `{root}/query` (e.g. `https://moderator.example/query`).

Labelers MUST support an optional trailing slash on the URL, and responses to this URL SHOULD issue a HTTP redirect to the canonical URL.

The response format of the listing endpoint MUST be a JSON array, where each object in the array MUST be a Label Document.

The endpoint has the following query string parameters:

| Parameter | Constraints                                                                    |
| --------- | ------------------------------------------------------------------------------ |
| ids       | URI for the package or release to fetch labels for. May be repeated. Required. |
| lang      | Preferred language for human-readable text. May be repeated. Optional.         |

If the labeler does not have any labels for the ID, it MUST respond with an empty JSON array.

If the provided IDs are invalid and not understood by the labeler, the labeler MUST respond with a 400 Bad Request error.

Labelers MAY return labels for entities which do not exact-match the supplied IDs, such as to provide labels for related entities. For example, if a client requests labels for a release, the labeler MAY respond with labels for the package the release belongs to. Clients MAY provide both package and release IDs when querying to make this expectation explicit.


### lang

The `lang` parameter specifies the preferred language or languages for human-readable text in the response.

The `lang` parameter MUST be a [BCP 47 (RFC 5646) language tag](https://datatracker.ietf.org/doc/html/rfc5646).

Labelers SHOULD provide human-readable text in the preferred language as specified by this parameter if they are able to. Clients SHOULD indicate the preferred language of the user when making requests.

Clients MAY indicate multiple preferred languages by passing this parameter multiple times. Labelers MUST interpret multiple languages as an ordered list, with higher preference assigned to the first parameter value and so on.

Labelers MAY return labels in a default language instead of a preferred language.


## Label Document

A Label Document is a JSON document provided by a labeler which provides labels about an entity. "Valid" label documents are those which conform to this specification's rules for Label documents.

Label documents may be available as standalone documents or embedded within other documents, such as in responses from aggregators.

When presented as a standalone document, the label document MUST include a `@context` entry. The `@context` entry MUST be either the JSON String `https://fair.pm/ns/label/v1` or a JSON Array where the first item is the JSON String `https://fair.pm/ns/label/v1`. The `@context` entry MAY be omitted where the label document is embedded within another document.

The following properties are defined for the label document:

| Property    | Required? | Constraints                                                                 |
| ----------- | --------- | --------------------------------------------------------------------------- |
| source      | yes       | A URI indicating the labeler which generated this label.                    |
| subject     | yes       | A [fairpm URI](#uris) indicating which subject this label is attached to.   |
| value       | yes       | A string which is one of the [defined label values](#defined-label-values). |
| date        | yes       | A string containing an [RFC 3339][] date-time.                              |
| sig         | yes       | Reserved for future use.                                                    |
| context     | no        | A map that conforms to the rules of [context](#property-context).           |
| _links      | no        | [HAL links][hal].                                                           |

The properties of the release document have the following semantic meanings and constraints.

[RFC 3339]: https://datatracker.ietf.org/doc/html/rfc3339
[hal]: https://datatracker.ietf.org/doc/html/draft-kelly-json-hal-11


## context

<a name="property-context"></a>

The `context` property specifies additional context for the label.

This property MUST be a valid map, represented as a JSON Object.

The following keys and their semantic meaning are specified:

* `message` - A human-readable message explaining the label to the user.
* `url` - A URL to a HTML/HTTP page explaining the label to the user.

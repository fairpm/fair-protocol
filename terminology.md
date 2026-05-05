# Terminology used within FAIR

The following terms are used with specific meaning in the documentation for the FAIR Protocol.

## Conventions

### Clarifications

- <a id="def-author"></a>**Author / Contributor / Maintainer** — No normative assumptions should be made about these roles beyond what is defined in applicable third-party schemas or specifications.
  - **Author** — Typically the creator of a Package.
  - <a id="def-contributor"></a>**Contributor** — Roughly equivalent to an Author, with the stipulation that a Contributor is not the sole Author of a Package.
  - <a id="def-maintainer"></a>**Maintainer** — The entity that creates updates for a Package, and may or may not otherwise be an Author or Contributor.
  - The term _[Publisher](#def-publisher)_ is used in place of the foregoing to incorporate any of these roles generally. (See "[Publisher](#def-publisher)".) This avoids conflicts with external definitions or distinctions between these roles. A software firm employing an author would typically be the Publisher. In such cases, an author may or may not hold the copyright to the work, which may also be produced by a group of contributors with updates by various maintainers. These distinctions are outside the scope of FAIR's concerns, which focus on the Publisher.
- <a id="def-fair"></a>**FAIR** — Federated And Independent Repositories (FAIR). When capitalized as an acronym, the unqualified term may refer to the FAIR Protocol, the FAIR Project, or its working groups including its Technical Steering Committee, as context dictates. When used with normal grammatical capitalization ("Fair" or "fair"), the term should be understood in its ordinary sense.
- <a id="def-federation"></a>**Federation** — The process of a group of groups or individuals associating together for a common purpose. In the context of FAIR, Federation is for the purpose of distributing Packages. Anyone may connect to Federated sources to download Packages.
- <a id="def-node"></a>**Node** — In telecommunications, a Node is a communications endpoint. In networking, it includes the concept of repeaters, and this general definition carries into computing environments, so a Node in a distributed system refers to an endpoint represented by a client, a server, a repeater, or a redistribution point. Within the FAIR network architecture, it retains this nonspecific meaning, and includes Repositories, Aggregators, Clients, Labellers, and any other digital endpoint with an electronic connection to the federated network. "Node" is from the Latin _nodus_, or "knot" — Nodes tie everything together.

### External Definitions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in [RFC 2119](https://www.rfc-editor.org/rfc/rfc2119).

The meaning of undefined industry or technical terms (sometimes "jargon") should be understood as they are commonly used or defined in the industry. Specific terms applying to DIDs are [defined in the W3C DID Specification](https://www.w3.org/TR/did-1.1/#terminology). Other applicable specifications are referenced in context.

## Definitions

- <a id="def-aggregator"></a>**Aggregator** — A node in the package management network which collects package metadata and indexes it to serve to Clients via an API.
- <a id="def-attestation"></a>**Attestation** — A statement about a Package or collection of Packages which is certified as true by the Publisher, such as would be found in a Provenance Document.
- <a id="def-client"></a>**Client** — A node which requests metadata about Packages and displays it to users. Clients may also download the Package itself, and typically perform validation and installation of the Package.
- <a id="def-did"></a>**DID** — Decentralized Identifier, a universally-unique identifier as [specified by the W3C](https://www.w3.org/TR/did-1.1/): "A DID refers to any subject (e.g., a person, organization, thing, data model, abstract entity, etc.) as determined by the controller of the DID." DIDs do not have a centralized registry, and exist in many different implementations with different methods for how they function to deliver a DID document. In addition to [W3C DID terminology](https://www.w3.org/TR/did-1.1/#terminology), FAIR uses some specific descriptors.
  - <a id="def-aggregator-did"></a>**Aggregator DID** — A DID which does not identify a specific Package, but identifies an Aggregator, being the entity that operates the Aggregator.
  - <a id="def-did-holder"></a>**DID Holder** — An entity that controls a DID with its registrar. For some DID methods such as DID:web, the DID registrar and the DID Holder may be the same entity.
  - <a id="def-package-did"></a>**Package DID** — A DID which is used to identify a specific Package. This is the primary use of DIDs in the FAIR Protocol, and unless otherwise dictated by context, the unqualified term DID refers to a Package DID.
  - <a id="def-publisher-did"></a>**Publisher DID** — A DID which does not identify a specific Package, but identifies a Publisher, being the entity that publishes Packages.
  - <a id="def-publisher-issued-did"></a>**Publisher-Issued-DID** — A DID held by a Publisher to identify a specific Package for which it is the Publisher.
  - <a id="def-repository-did"></a>**Repository DID** — A DID which does not identify a specific Package, but identifies a Repository, being the entity that operates the Repository.
  - <a id="def-repository-issued-did"></a>**Repository-Issued-DID** — A DID held by a Repository on behalf of the Publisher to identify a specific Package. For some DID methods such as DID:web, the Repository may also be the resolver for the DID.
- <a id="def-entity"></a>**Entity** — An Entity refers to a Package, organization, system, or node within the FAIR network, and is an intentionally vague term.
- <a id="def-package"></a>**Package** — Any digital good served in a downloadable digital format, including installable software or other binary files and associated assets. A FAIR Package is identified by a DID and described in a metadata document. For practical purposes, a file referring to a Package such as a metadata document or DID document is not considered a Package.
- <a id="def-publisher"></a>**Publisher** — An Entity that publishes, uploads, or releases a Package for distribution. Publishers are accountable for their releases, and must hold the copyright, a valid license, or permission from the copyright holder to distribute the Package. A Publisher may or may not be the author or developer of the Package.
- <a id="def-repository"></a>**Repository** — A server which hosts and serves Package assets following the specification described in the FAIR Protocol. Repositories MAY resolve DIDs to serve DID documents for supported DID methods (_e.g._, DID:web), and MAY hold signing keys in the Repository-Trust model. Publishers MAY move Packages between Repositories.
- <a id="def-trust"></a>**Trust**
  - <a id="def-trust-label"></a>**Trust Label** — A user-facing indicator assigned by the FAIR Trust Labeller. These may be a numerical Trust Score or a string indicating a specific state.
  - <a id="def-trust-score"></a>**Trust Score** — A numerical representation of how much trust has been established for an Entity. The score is dynamic and subject to change at any time.
  - <a id="def-trust-signals"></a>**Trust Signals** — Various indicators used in FAIR's Trust Model to calculate a Trust Score for an Entity. Trust Signals include both "hard" and "soft" measures.
  - <a id="def-publisher-trust"></a>**Publisher-Trust** — Trust in an artifact flows directly from the Publisher when it is signed by the Publisher using their own keys.
  - <a id="def-repository-trust"></a>**Repository-Trust** — Trust in the artifact flows from trust in the Repository rather than the Publisher when the Package is signed by the Repository.
  - <a id="def-trust-tier"></a>**Trust Tier** — One of two specified trust types: Repository-Trust or Publisher-Trust. Publisher-Trust is the higher tier, as trust flows directly from the source of the Package.
- <a id="def-user"></a>**User** — An Entity accessing the FAIR network through a Client. Users may include developers, system administrators, or end users, and are presumed to have the necessary permissions to install, deploy, or otherwise use the Package.
- <a id="def-vendor"></a>**Vendor** — The term "vendor" implies remuneration and is retired from normative use. Read "[Publisher](#def-publisher)" in its place wherever it appears in the documentation.

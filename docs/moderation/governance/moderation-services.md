# Moderation Services and Labelers in FAIR

The FAIR ecosystem relies on a decentralized approach to moderation, where trust signals are primarily conveyed through a system of "labels." These labels are applied to Repositories, Aggregators, software packages or other content, or even developer identities by entities known as "Moderation Services" or "Labeler Services."

FAIR will operate its own official Labeler Service(s) to apply labels based on its established governance policies (such as those outlined in [Vetting and Reporting](./vetting-and-reporting.md) and the [Appeals Process](./appeals.md)), but the architecture is designed to be open. This allows for a plurality of voices and trusted sources within the federation, and the ability to opt in or out from public labeling services.

For a foundational understanding of the label-based system and the role of Ozone, please refer to the [Ozone Labeling System](../../ozone-labeling-system.md) document. This current document focuses on the operational concept of a Moderation Service/Labeler.

## What is a Moderation Service / Labeler?

In the context of FAIR and its use of Ozone-like principles, a Moderation Service (or Labeler Service) is an entity that:

1. **Defines a Set of Labels:** It determines the specific labels it will issue (e.g., `community:trusted`, `vendor:verified`, `theme:accessibility-reviewed`, `plugin:experimental`). These labels reflect the specific criteria or focus of the moderation service.
2. **Assigns Labels:** It applies these labels to specific entities within the FAIR network (Repositories, Aggregators, packages, etc.) based on its own evaluation processes, community input, or automated checks.
3. **Publishes Labels:** It makes these labels publicly discoverable, typically through an API or by publishing them to a shared data network like the AT Protocol graph. This allows other services (like Aggregators or client applications) to subscribe to these labels and apply them appropriately, such as by displaying them to users, filtering listings or search results, or delisting an entity.
4. **Operates Transparently (Ideally):** While not strictly enforceable by FAIR on independent services, best practice encourages labelers to be transparent about their labeling criteria, processes, and any affiliations. (Where labels are applied using algorithms or automated processes that are considered trade secrets, these need not be made public, but FAIR encourages disclosure of the principles governing the critera.)

Essentially, a Moderation Service acts as a trusted (or identifiable) source of commentary or judgment (whether objective or subjective) about other entities in the network, expressed through standardized labels.

## FAIR's Official Moderation Service(s)

FAIR will operate one or more official Labeler Services. These services will:

- Implement the labeling outcomes of FAIR's governance policies (e.g., applying `fair:threshold:warning25` based on report volumes).
- Issue labels based on reviews conducted by FAIR working groups (e.g., `fair:security-vetted`, `fair:violates-guidelines`).
- Use the technical infrastructure detailed in the [Ozone Labeling System](../../ozone-labeling-system.md) documentation.
- Serve as a baseline source of trust signals for the ecosystem.

Aggregators and end-users can choose to subscribe to labels issued by FAIR's official service(s) as a primary source of moderation data.

## Third-Party Moderation Services

The FAIR ecosystem is designed to support the operation of independent, third-party Moderation Services. This allows for:

- **Specialized Moderation:** Groups with specific expertise (e.g., security researchers, accessibility advocates, niche community moderators) can run labelers focused on their domain.
- **Localized Trust:** Regional communities or organizations might establish labelers relevant to their specific user base.
- **Diversity of Viewpoints:** Multiple labelers can offer different perspectives, allowing end-users and services to curate their experience based on a wider range of trust signals.
- **Extended Categorization:** Labelers may offer additional categorization or tagging of packages or other content beyond what is natively available from the meta associated with each package.

### How a Third Party Can Create a Moderation Service

A third party wishing to establish their own Moderation Service within the FAIR ecosystem would generally need to:

1. **Define Scope and Criteria:**
    * Determine the types of labels they will issue and the clear, consistent criteria for applying them.
    * Identify their target audience or the specific value their labels will provide.

2. **Set Up Technical Infrastructure:**
    * Implement or deploy a "labeler" application. This could involve:
        * Forking and customizing existing open-source Ozone components.
        * Developing a custom application that can interact with the AT Protocol or a similar decentralized identity and data framework used by FAIR.
        * The service must be able to sign and publish labels associated with DIDs in a way that is consumable by other FAIR participants.
    * Ensure the service has a stable, discoverable endpoint (API).

3. **Establish Identity:**
    * The Moderation Service should have its own clear identity within the network (e.g., its own DID). This allows consumers of its labels to know who is issuing them.

4. **Publish Labeling Policies:**
    * It is highly recommended (though not mandated by FAIR for independent services) to publicly document the service's labeling policies, criteria, and any dispute resolution mechanisms they offer for their own labels. This builds trust with potential consumers of their labels.

5. **Announce and Promote:**
    * Make the FAIR community aware of the new Moderation Service, its purpose, and how to subscribe to its labels.

### Interoperability Considerations

For third-party labels to be most effective within the FAIR ecosystem:

- **Standardized Identifiers:** Labels should refer to entities using their DIDs or other supported unique identifier.
- **Discoverable Schemas (Recommended):** While not strictly required for basic operation, defining and publishing schemas for the labels used (e.g., what `myorg:custom-label` actually means) can improve interoperability and understanding.
- **Respect for Autonomy:** FAIR will not dictate which third-party labelers other services or users must trust. Trusting, interpreting, and acting upon labels from any particular service rests with the individual Aggregator, client application, or end-user.

By enabling third-party Moderation Services, FAIR aims to foster a rich, resilient, and community-driven approach to trust and safety, moving beyond a single source of truth for moderation signals.

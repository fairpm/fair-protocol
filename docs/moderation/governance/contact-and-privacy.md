# Contact and Privacy Requirements

As part of federation governance, every participating Node and Aggregator must maintain valid contact information and follow strict data privacy practices. These requirements support transparency, accountability, and effective moderation across the FAIR ecosystem.

## Public Contact

Publicly visible contact information is required. This enables users and peers to evaluate trust and accountability. Public details may include:

- Name or pseudonym
- Affiliated Organization (if applicable)
- Website URL
- Public email address or social profile

Public contact details are visible in Aggregators and Node listings and must remain up-to-date.

## Private Contact

Node and Aggregator operators must also supply private contact information. This is only accessible to federation administrators (e.g. FAIR, Aggregator maintainers) and is used for:

- Abuse or moderation inquiries
- Technical communication
- Urgent policy escalations

Private contact methods may include:

- Administrative email address
- Secure access to a contact dashboard
- Verified identity (e.g., DID, OAuth provider)

This data must be accurate and monitored. Failure to respond to valid contact attempts may lead to delisting or defederation.

## Data Privacy Compliance

All submitted contact information must be handled in accordance with relevant data protection laws, including the General Data Protection Regulation (GDPR) and Cyber Resilience Act (CRA) where applicable.

All Nodes and Aggregators must:

- Collect only necessary personal data
- Publish a clear data usage policy
- Provide users with a method to update or delete stored contact data
- Ensure secure, access-controlled storage of private contact information

Violations of data privacy requirements may result in removal from federation listings.

## Integration with Moderation Services

To support cross-federation trust and incident response, all Nodes and Aggregators **must** integrate with the designated federation-wide moderation platform: **Ozone**

This includes:

- Providing contact information through an authenticated API to Ozone
- Authorizing Ozone to initiate moderation inquiries, escalations, or contact requests
- Receiving and responding to moderation alerts in a timely manner
- Participating in appeals and dispute resolution processes where applicable

Integration with Ozone enables real-time coordination between federation participants, allowing FAIR and other Aggregators to track abuse reports, verify identities, and ensure that moderation actions are visible and enforceable across the network.

Failure to implement or maintain this integration will be treated as a breach of federation protocol and may lead to delisting or defederation.


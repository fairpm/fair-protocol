# FAIR Approval and Governance Policies

| <!-- --> | <!-- -->   |
|----------|------------|
| Status   | Policy Document |
| Date     | 2025-01-27 |

## Executive Summary

This document consolidates FAIR's comprehensive policies for approving and denying federation partners, plugins, updates, and other ecosystem participants. It defines the governance structure, approval processes, and compliance requirements including CRA/GDPR obligations.

**At this time, this document is a PROPOSAL.**

## Governance Structure

Initially, we will be handling all new Repositories and Aggregators as _invite only_. Once we build out Repositories and Aggregators in the wild, we will take the oppertunity to refine this structure.

### FAIR Working Groups (Proposed)

FAIR operates through specialized working groups responsible for different aspects of ecosystem governance. These groups may include:

1. **Vetting Moderation Working Group**: Reviews and approves new Repositories, Aggregators, and packages
2. **Security Moderation Working Group**: Evaluates security compliance and vulnerability assessments
3. **Appeals Moderation Working Group**: Handles disputes and appeals of moderation decisions
4. **Compliance Moderation Working Group**: Ensures CRA/GDPR and other regulatory compliance

## Federation Partner Approval Process

In order to be a part of the FAIR Federation, Repositories and Aggregators must be added to the list of discoverable entities.

During Phase 1, Aggregators will be invited to be federated, based on the Repositories it connects with.

### New Repository Approval

A Repository is a server that hosts and distributes packages (themes, plugins, or other digital content) within the FAIR ecosystem. Repositories can be operated by individuals, organizations, or communities, and they serve as the primary distribution points for software and content packages. Each Repository maintains its own collection of packages and provides standardized APIs for discovery, download, and metadata access.

To be approved for Federation, Repositories must successfully pass all automated technical checks, meet all policy requirements, integrate with the Ozone moderation system, and provide valid public and private contact information for accountability and communication purposes.

Once a Repository passes technical validation, it is subject to a manual policy review by the Aggregator to ensure it adheres to federation-wide non-technical standards, such as copyright and trademark law, licensing, and more, for compliance with our guidelines.

#### Post-Approval

Once the Repository passes all checks, it is:

- Added to the Aggregator
- Indexed and made available through compatible discovery tools including browsers and package installers
- Monitored by FAIR for availability and compliance over time

### New Aggregator Approval

An Aggregator is a service that indexes and consolidates content from multiple Repositories, making packages discoverable across the broader FAIR ecosystem. Aggregators act as search and discovery hubs that users can query to find packages regardless of which specific Repository hosts them. They provide unified interfaces for package discovery, metadata aggregation, and cross-repository search functionality.

Aggregators can be operated by different organizations and may implement their own filtering, ranking, and moderation policies while maintaining compatibility with federation-wide standards.

To be approved for federation, Aggregators must demonstrate technical capability to index and serve repository data effectively while maintaining compliance with federation API standards. Integration with the Ozone labeling system is mandatory to ensure federation-wide moderation and trust management.

Aggregators must also maintain transparent moderation policies that clearly communicate their content standards and enforcement procedures. Finally, they must provide comprehensive contact information and implement accountability measures to ensure they can be reached for policy discussions, security incidents, and federation governance matters.

## Package (Plugins and Themes) Approval Process

FAIR itself does not host the code for packages. While individual Repositories handle the actual hosting and distribution, FAIR provides the governance framework, approval processes, and moderation systems that ensure ecosystem-wide quality and security standards.

### Package Approval Recommendations

We recommend that Repositories implement comprehensive validation processes. This should include automated checks for properly structured metadata and readme files, duplication detection against existing packages, content integrity validation, and license validation and compatibility verification. Automated security scanning for malware and vulnerabilities is strongly recommended, along with code quality checks for syntax errors and deprecated functions.

Repositories are expected to conduct manual policy reviews covering copyright compliance verification, licensing validation for intended use, content alignment with ethical standards, and third-party dependency license compatibility. These reviews help maintain ecosystem quality and trust while respecting Repository autonomy in package hosting decisions.

### Update Approval Recommendations

We recommend that Repositories implement automated validation processes for update submissions. These should include version compatibility validation to ensure updates work with existing installations, security vulnerability assessment to identify potential risks, dependency update verification to ensure compatibility, and breaking change identification to alert users about significant modifications.

Repositories may also conduct manual review for updates that include major version changes with breaking modifications, security-related updates that may affect user safety, changes to licensing terms or conditions, and significant functionality changes that could impact user experience. These reviews help maintain ecosystem stability and user trust while allowing Repositories to maintain control over their update approval processes.

For larger repositories such as WordPress.org, manual review of every update is simply not feasible. The volume of submissions and updates makes human review of each change impossible while maintaining reasonable response times for users. These large-scale repositories must rely heavily on automated validation systems, community reporting mechanisms, and post-publication monitoring to maintain quality standards. While manual review may be reserved for high-risk updates or community-reported issues, the primary quality assurance comes from robust automated testing, security scanning, and the ability to quickly respond to and remove problematic updates when they are identified.

## Compliance Requirements

All Repositories and Aggregators must comply with our CRA and GDPR requirements.

### GDPR Compliance

All Repositories and Aggregators must adhere to strict data collection principles that limit personal data collection to only what is necessary for their services to function. They must publish clear, accessible data usage policies that explain how collected information is used, stored, and shared. Participants must provide users with methods to update or delete their stored data, and implement secure storage systems with appropriate access controls to protect user information.

To ensure GDPR compliance, participants must implement data minimization practices that collect the least amount of personal information possible while maintaining service functionality. User consent mechanisms must be clear and easily revocable, with data portability options that allow users to export their information in a usable format. Participants must also establish breach notification procedures to promptly inform users and authorities of any data security incidents.

### CRA (Cyber Resilience Act) Compliance

To comply with CRA requirements, all Repositories and Aggregators must establish comprehensive vulnerability disclosure policies that clearly communicate how security issues are reported and addressed. They must implement security update mechanisms that can quickly deploy patches and fixes when vulnerabilities are identified. Incident response procedures must be documented and tested to ensure rapid response to security incidents. Additionally, participants must validate their supply chain security to ensure that dependencies and third-party components meet security standards.

CRA compliance requires regular security assessments to identify potential vulnerabilities and security gaps. Participants should implement automated vulnerability scanning systems to continuously monitor for new security threats. Security labeling and documentation must be maintained to provide transparency about security measures and compliance status. Finally, ongoing risk assessment and mitigation processes should be established to proactively address emerging security challenges and maintain robust security postures.

## Moderation and Enforcement

The Moderation System is built with the intent to automate as much labeling as possible. By providing information about the veracity of packages and services, we ensure site owners, web hosts, and developers make educated decisions.

### Threshold-Based Escalation

The threshold-based escalation system operates on community feedback percentages. When users report issues with packages, Repositories, or Aggregators, the network tracks the percentage of active users who have reported problems.

For example, at 25% reporting, the system automatically logs warnings and begins monitoring. At 50%, community notices are displayed and aggregators are alerted to potential issues. When reporting reaches 60%, warnings become prominently displayed and FAIR working groups are notified for manual review. At 75% reporting, the system automatically implements temporary suspension until FAIR working groups can make a final decision.

This ensures that community concerns are addressed proportionally while preventing abuse of the reporting system.

### Defederation Process

Defederation removes a participant from the FAIR discovery and recommendation systems and does the following:
- Prevents _new_ sites from discovering packages from defederated Repositories
- Removes defederated Aggregators from FAIR's discovery services
- Excludes defederated participants from federation-wide moderation and trust systems

Bear in mind that being defederated will _not_:
- Remove packages from individual sites that already have them installed
- Disable or shut down the defederated server
- Affect existing installations or functionality

**Some Reasons for Defederation:**
- Confirmed malware or malicious code
- Critical security vulnerabilities with active exploitation
- Copyright violations with valid takedown requests
- Illegal content as defined by applicable law
- Persistent failure to respond to security incidents
- Refusal to integrate with Ozone moderation system

In most cases, defederation is not immediate. FAIR follows a structured approach to removal that begins with investigation and evidence collection, followed by operator notification and technical assessment. The process typically starts with a formal warning period for first-time policy violations or technical issues. If violations persist or remediation fails, a suspension period is implemented. Only in cases of persistent non-compliance or serious security risks is permanent defederation considered.

All removal decisions require consensus among the appropriate Working Groups, with immediate implementation including removal from discovery services and public documentation of the decision and rationale.

Finally, all acts of defederation must be transparent. This means that every removal decision must be publicly documented with clear reasoning and supporting evidence, ensuring that the community understands why actions were taken. The appeal process must be readily available within a 60-day window, giving affected participants adequate time to challenge decisions. Clear communication of reinstatement requirements must be provided so participants understand exactly what they need to accomplish to regain federation access.

To maintain ongoing transparency, quarterly defederation reports are published detailing all actions taken, and annual policy effectiveness reviews assess whether the current approach is working as intended and identify areas for improvement.

### Reinstatement Process

For any Repository or Aggregator that is defederated by FAIR, we have an appeals process. To be eligible for reinstatement, participants must demonstrate they have remediated the issues that led to defederation, including passing a security audit and achieving full policy compliance. The reinstatement process begins with a formal application that includes evidence of compliance and remediation efforts.

This application undergoes a comprehensive review process, with technical aspects evaluated by the Security Working Group and policy compliance assessed by the Vetting Working Group. If approved, participants enter a trial period with enhanced monitoring to ensure sustained compliance before full reinstatement is granted.

Final reinstatement requires consensus among the relevant working groups that all requirements have been met.

For more information, see the "Appeals and Dispute Resolution" section.

### Repository Autonomy

Each Repository maintains full control over their hosted packages. They may operate as:

- Invite-only repositories
- Open submission repositories (like `wordpress.org` today)
- Private repositories
- Any combination of the above

FAIR will not intervene in Repository-specific decisions about package hosting or removal. If a Repository owner defederates a package creator, FAIR will not assist that creator in changing the Repository's decision and recommends finding a new Repository to host their code.

## Appeals and Dispute Resolution

FAIR takes full responsibility for all defederation decisions it makes regarding Repositories and Aggregators. When FAIR defederates a participant, we provide a transparent appeals process to ensure fairness and due process.

The scope of the appeals process covers:
- FAIR-initiated defederation decisions
- FAIR-applied moderation labels that result in widespread consequences
- Decisions made by FAIR working groups
- Policy enforcement actions taken by FAIR

**What Appeals Do Not Cover:**
- Repository-specific decisions about individual packages
- Aggregator-specific listing decisions
- Third-party service decisions
- General policy disagreements (these should go through community channels)

### Appeals Process

**Eligibility:**
Primary maintainers of affected repositories and aggregators, as well as developers of affected packages, are eligible to submit appeals. Appeals must be submitted within a reasonable window from the date of the original decision to be considered.

**Review Process:**
All appeals are reviewed by an independent Appeals Working Group that operates separately from the decision-making bodies to ensure impartiality. The working group aims to complete reviews within a reasonable timeline, though complex cases may require additional time. Each appeal results in a written decision that clearly explains the reasoning behind the outcome. The Appeals Working Group has final decision authority on all appeals, providing a definitive resolution to the dispute.

### Grounds for Appeal

Valid grounds for appeal include factual errors in the original decision-making process, such as incorrect information or incomplete evidence.

Appeals may also be based on misapplication of FAIR policies where the rules were not correctly applied to the specific case. New evidence that was not available during the initial review process may also constitute valid grounds for appeal. Procedural irregularities, including significant flaws in the decision-making process itself, can also be appealed. Finally, disproportionate actions where the punishment significantly exceeds the severity of the violation may be grounds for appeal.

Simply disagreeing with a decision is not adequate grounds - appellants must present new information or reasoning based on these specific criteria.

## Integration Requirements

All Repositories and Aggregators must use the Ozone system for federation-wide moderation and trust management. This mandatory integration requires participants to provide contact information through an authenticated API, authorize Ozone to initiate moderation inquiries and escalations, and participate in appeals and dispute resolution processes. Integration with Ozone enables real-time coordination between federation participants, allowing FAIR and other Aggregators to track abuse reports, verify identities, and ensure moderation actions are visible and enforceable across the network.

Failure to implement or maintain this integration is treated as a breach of federation protocol and may result in delisting or defederation. Regular compliance monitoring ensures that all participants maintain their Ozone integration and continue to meet federation-wide moderation standards.

## Monitoring and Accountability

### Ongoing Compliance

FAIR maintains ongoing compliance through periodic policy compliance audits that assess whether all federation participants are meeting their obligations. Regular security vulnerability assessments identify potential risks and ensure security measures remain effective. Contact information validation ensures that all participants can be reached when needed, and moderation system integration verification confirms that Ozone and other required systems are properly implemented and maintained.

To measure the effectiveness of our governance systems, FAIR tracks key performance indicators including response time to moderation requests, appeal resolution timelines, policy violation frequency, and community satisfaction measures. These metrics help identify areas where processes can be improved and ensure that the federation maintains high standards of responsiveness and effectiveness.

### Transparency Measures

All policy decisions are thoroughly documented and made publicly available to ensure transparency and accountability. Appeal outcomes are published with appropriate anonymization to protect privacy while maintaining transparency about how decisions are made. A comprehensive moderation action transparency ledger provides a complete record of all actions taken, and regular governance reports keep the community informed about federation operations and policy effectiveness.

## Implementation Timeline

This timeline is a loose idea of the directions to take:

**Phase 1 (Immediate):**
- Create robust documentation about the moderation system
- Determine if a started Working Group is needed
- Policy documentation and communication

**Phase 2 (3 months):**
- Working group formation and training
- Integration requirements enforcement

**Phase 3 (6 months):**
- Automated compliance monitoring
- Appeal process implementation
- Transparency reporting systems

**Phase 4 (9 months):**
- Performance metrics implementation
- Policy refinement based on experience
- Community feedback integration

---

*This document is a living policy that will be updated based on community feedback and evolving requirements. All changes are subject to public review and comment periods.*

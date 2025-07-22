# Moderation Labels

| <!-- --> | <!-- -->   |
|----------|------------|
| Status   | Proposal   |
| Date     | 2025-07-22 |

A moderation service is, in essence, a complex labeler.

## Proposed Labels

This section documents all proposed labels for the FAIR ecosystem, organized by category and source. Labels follow the format `namespace:label-type` or `namespace:category:subcategory`.

### FAIR Official Labels

#### Threshold-Based Labels
These labels are automatically applied by FAIR's official labeler based on community reporting thresholds:

- `fair:threshold:warning25` - Applied when 25% of active users report an issue
- `fair:threshold:notice50` - Applied when 50% of active users report an issue
- `fair:threshold:review60` - Applied when 60% of active users report an issue, triggers manual review
- `fair:threshold:suspended75` - Applied when 75% of active users report an issue, triggers suspension

#### FAIR Governance Labels
Labels applied by FAIR working groups based on policy decisions:

- `fair:verified` - Entity has been verified by FAIR
- `fair:security-vetted` - Entity has passed FAIR security review
- `fair:violates-guidelines` - Entity violates FAIR guidelines
- `fair:defederated` - Entity has been defederated from FAIR ecosystem

### Package-Level Labels

#### Security and Safety
- `package:malicious` - Package contains malicious code or behavior
- `package:vulnerability:active` - Package has active security vulnerabilities
- `package:unverified` - Package has not been verified for safety
- `package:deprecated` - Package is deprecated by its author

#### Content and Quality

- `package:experimental` - Package is experimental/alpha/beta
- `package:community-trusted` - Package is trusted by the community
- `package:deprecated` - Package is deprecated by its author
- `package:accessibility-reviewed` - Package has been reviewed for accessibility

### Repository-Level Labels

#### Compliance and Trust
- `repository:insecure` - Repository has security issues
- `repository:non-compliant` - Repository does not comply with FAIR standards

#### Operational Status
- `repository:verified` - Repository has been verified
- `repository:trusted` - Repository is trusted by the community

### Aggregator-Level Labels

#### Compliance and Trust
- `aggregator:compliant` - Aggregator complies with FAIR standards
- `aggregator:trusted` - Aggregator is trusted by the community

### Author/Developer Labels

#### Verification
- `author:verified` - Author/developer has been verified
- `author:trusted` - Author/developer is trusted by the community

### Third-Party Label Examples

The following are examples of labels that third-party moderation services might implement:

#### Security Focus
- `myorg:security:audited` - Package has been security audited by organization
- `myorg:security:reviewed` - Package has been reviewed for security

#### Accessibility Focus
- `community:focus-accessibility` - Package focuses on accessibility
- `wcag:2.2AA` - Package meets WCAG 2.2 AA standards

#### Vendor/Organization Labels
- `vendor:verified` - Vendor has been verified
- `vendor:official-partner` - Vendor is an official partner
- `myorg:custom-label` - Custom label from specific organization

#### Community Labels
- `community:trusted` - Trusted by the community

### Label Categories by Impact Level

#### Critical (Immediate Action Required)
- `fair:threshold:suspended75`
- `fair:defederated`
- `package:malicious`
- `repository:insecure`

#### High Risk (Warning Required)
- `fair:threshold:review60`
- `package:security-vulnerability:active`
- `repository:non-compliant`
- `node:non-compliant`

#### Medium Risk (Notice Required)
- `fair:threshold:notice50`
- `package:unverified`
- `package:deprecated`
- `theme:deprecated`

#### Low Risk (Information Only)
- `fair:threshold:warning25`
- `plugin:experimental`
- `plugin:community-trusted`
- `theme:accessibility-reviewed`

#### Positive Signals
- `fair:verified`
- `fair:security-vetted`
- `author:verified`
- `aggregator:compliant`
- `repository:verified`
- `community:trusted`
- `vendor:verified`

### Label Implementation Notes

1. **Namespace Consistency**: All FAIR official labels use the `fair:` namespace
2. **Threshold Labels**: Automatically applied based on community reporting percentages
3. **Manual Labels**: Applied by FAIR working groups or authorized labelers
4. **Third-Party Labels**: Can use any namespace but should be clearly documented
5. **Label Persistence**: Labels should be cryptographically signed and verifiable
6. **Label Discovery**: All labels should be discoverable via API endpoints

### Label Usage Guidelines

- **Aggregators** should subscribe to relevant labels and apply filtering based on their policies
- **Client applications** (like the FAIR WordPress Plugin) should display appropriate warnings and indicators
- **Repository operators** should monitor labels applied to their content and take appropriate action
- **End users** should be informed of relevant labels through their chosen client applications

### Future Label Considerations

Additional label categories that may be implemented:

- **License compliance** labels (e.g., `license:gplv2-compatible`)
- **Performance** labels (e.g., `performance:optimized`)
- **Compatibility** labels (e.g., `compatibility:wordpress-6.0+`)
- **Regional compliance** labels (e.g., `compliance:gdpr`, `compliance:ccpa`)
- **Quality assurance** labels (e.g., `qa:tested`, `qa:reviewed`)

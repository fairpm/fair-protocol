# Service Hierarchy

| <!-- --> | <!-- -->   |
|----------|------------|
| Status   | Proposal   |
| Date     | 2025-07-22 |

FAIR's discovery system operates on multiple levels:

## Repositories
- Host and distribute actual package files
- Primary content storage layer

## Aggregators
- Index and list Repositories and their packages
- Provide search and discovery interfaces
- Can list other Aggregators (recursive)

## Discovery Services
- Higher-level directories that aggregate multiple Aggregators
- Enable ecosystem stakeholders to create unified search experiences
- Examples: Hosting companies, CMS vendors, large developer communities
- Can combine multiple Aggregators into single interface/API

## Example Hierarchy

```markdown
Discovery Service (Hosting Company A)
├── Aggregator (Dev Company 1)
│   ├── Repository A
│   └── Repository B
├── Aggregator (Dev Company 2)
│   ├── Repository C
│   └── Repository D
└── Own Repository + Aggregator
```

This hierarchy enables horizontal scaling while maintaining FAIR's decentralized principles.

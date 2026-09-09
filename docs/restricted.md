# Restricted Plugins and Themes

FAIR builds the concept of "restricted" packages right into the protocol.

In the WP ecosystem, many types of restricted packages are available, including privately-published themes and premium plugins. FAIR builds support for these into the protocol using a two-layer system:

- **Entitlements** — The vendor controls who can access the package through their own entitlement service. This works regardless of which repository hosts the package.
- **Authentication** — The repository controls how credentials are presented when downloading artifacts.

This separation means your customers keep their entitlements even if you change repositories, and aggregators can enforce the same access controls.

For implementation details, see the [implementing restricted packages](./implementing/restricted.md) guide.

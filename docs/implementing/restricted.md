# Restricted Packages

FAIR builds the concept of "restricted" packages right into the protocol. These are packages which require some form of entitlement, such as a subscription, purchase, or license key.

In the WP ecosystem, many types of restricted packages are available, including privately-published plugins and premium plugins. FAIR builds support for these into the protocol.

FAIR separates two distinct concerns:

- **Authentication** (`auth` on releases) — How to present credentials to the repository's HTTP server. This is the mechanism (bearer token, basic auth, OAuth2).
- **Entitlements** (`entitlements` on metadata) — What a user needs to be allowed to access the package. This is the policy, controlled by the vendor.

This separation means that vendors control access to their packages regardless of which repository serves them, and users keep their entitlements when packages move between repositories.


## Setting up entitlements

### 1. Add an entitlement service to your DID Document

Register a `FairEntitlementService` in your DID Document pointing to your license/entitlement server:

```json
{
  "service": [
    {
      "id": "#fairpm_repo",
      "serviceEndpoint": "https://repo.example.com/packages/1234",
      "type": "FairPackageManagementRepo"
    },
    {
      "id": "#fairpm_entitlements",
      "serviceEndpoint": "https://licenses.example.com",
      "type": "FairEntitlementService"
    }
  ]
}
```

This is the trust anchor — because you control your DID, you control where entitlement checks go, even if you change repositories.


### 2. Add entitlements to your package metadata

In your package metadata, specify the `entitlements` property:

```json
{
  "entitlements": {
    "service": "https://licenses.example.com/verify",
    "type": "subscription",
    "hint": "Example Plugin requires an active Pro subscription.",
    "hint_url": "https://example.com/pricing"
  }
}
```

The `service` URL must be under the `FairEntitlementService` URL in your DID Document. Clients validate this to prevent rogue repositories from redirecting entitlement checks.

Available entitlement types:

| Type                | Use case                                           |
| ------------------- | -------------------------------------------------- |
| `subscription`      | Premium plugins/themes with recurring billing      |
| `purchase`          | One-time purchase plugins/themes                   |
| `license-key`       | Software with traditional license key activation   |
| `free-registration` | Free plugins that require vendor registration      |

#### When entitlements expire and how often clients re-check

The protocol is deliberately agnostic about how an entitlement expires. The vendor's entitlement service controls re-verification timing through the `exp` claim on the JWT proof it issues — not through fields in the metadata. This keeps the metadata stable across renewals, plan changes, and authentication-method changes.

In practice:

- For a **monthly subscription**, issue proofs valid for a few days to a billing cycle (e.g., 1–30 days). When the subscription renews out of band, the next refresh will simply succeed and the client keeps going.
- For a **one-time purchase**, issue long-lived proofs (months). Use the `401`/`403` revocation flow if a refund or chargeback occurs.
- For a **license-key** entitlement, set `exp` to the licence's own expiry. A 365-day licence becomes a proof with `exp = now + 365 days`.
- For **free-registration**, issue long-lived proofs (weeks to a year). Clients refresh on demand if the vendor revokes.
- For **high-security plugins** where you want a re-check at least every shift, issue short proofs (e.g., 8 hours).

Clients are required to cache proofs until `exp` and to refresh on `401`/`403`. This means you do **not** need to perform a fresh entitlement check on every page load — once a client has a valid cached proof, it reuses it until expiry or until the repository rejects it.

If you need to force clients to skip caching and re-verify on every install/update — for example, for strict per-seat licence enforcement — set `require-reauth: true` on the entitlements object:

```json
{
  "entitlements": {
    "service": "https://licenses.example.com/verify",
    "type": "license-key",
    "require-reauth": true,
    "hint": "Each install verifies your seat allocation in real time.",
    "hint_url": "https://example.com/seats"
  }
}
```

Use `require-reauth: true` sparingly: it disables proof caching and adds a verification round-trip to every protected action.


### 3. Set up repository authentication

On each release that has restricted artifacts, set `auth` to tell clients how to authenticate with the repository:

```json
{
  "auth": {
    "type": "bearer",
    "hint": "Your entitlement token will be used automatically.",
    "hint_url": "https://example.com/help/installation"
  }
}
```

When a package has both `entitlements` and `auth`, the client flow is:

1. Client verifies the user's entitlement with the vendor's service
2. The entitlement service returns a signed JWT (entitlement proof)
3. Client presents the JWT as a bearer token to the repository
4. Repository validates the JWT and serves the artifact

Mark individual artifacts as restricted using `requires-auth`:

```json
{
  "artifacts": {
    "package": {
      "url": "https://repo.example.com/packages/1234/download/2.1.0",
      "requires-auth": true,
      "signature": "...",
      "checksum": "sha256:..."
    },
    "banner": {
      "url": "https://repo.example.com/packages/1234/banner.png",
      "content-type": "image/png"
    }
  }
}
```

In this example, the package binary requires authentication (and therefore entitlement verification), but the banner image is publicly accessible.


## How it works end-to-end

When a user wants to install a restricted package:

1. **Client resolves the DID** and finds both `FairPackageManagementRepo` and `FairEntitlementService` services.

2. **Client fetches metadata** from the repository and sees the `entitlements` property. It validates that the entitlement service URL matches the DID Document.

3. **Client displays the requirement** to the user: "This package requires an active Pro subscription. [Learn more](https://example.com/pricing)"

4. **User provides credentials** (API key, license key, etc.).

5. **Client contacts the entitlement service** with the user's credentials and the package DID. The service verifies the entitlement and returns a signed JWT proof.

6. **Client downloads the artifact** from the repository, presenting the JWT as a bearer token. The repository validates the JWT signature and expiration.

7. **Client verifies the package signature** against the DID Document's signing keys, as with any package.


## Why this separation matters

Because entitlements are tied to the vendor's DID (not the repository), they survive repository changes. If a vendor moves from Repository A to Repository B:

- The `FairEntitlementService` in the DID Document stays the same
- The entitlement service URL in the metadata stays the same
- Users' entitlements continue to work — the JWT proofs are validated against the vendor's entitlement service, not the repository
- The new repository just needs to accept the same JWT proofs

This also means aggregators and caches can enforce the same access controls by validating the same JWTs.

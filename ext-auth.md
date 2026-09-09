# FAIR Authentication Methods

This extension defines the standard authentication methods for the FAIR Package Management Protocol.

Authentication methods specify **how** a client presents credentials to a repository when accessing artifacts that require authentication (as indicated by the `auth` property on a [Release Document](./specification.md#property-auth) or the `requires-auth` property on an artifact).

For access control and entitlement verification (determining **whether** a user is authorized), see [Entitlements](./specification.md#entitlements) and [Entitlement Verification](./specification.md#entitlement-verification) in the core specification.


## Methods


### bearer

The `bearer` method indicates that the client must present a bearer token in the `Authorization` header.

```
Authorization: Bearer <token>
```

The token may be an API key, an [entitlement proof](./specification.md#entitlement-proof) JWT, or any other opaque token accepted by the repository.

The `auth` object for this method uses only the common properties (`type`, `hint`, `hint_url`). No additional properties are defined.

Example:

```json
{
  "auth": {
    "type": "bearer",
    "hint": "Enter your repository API key to download this artifact.",
    "hint_url": "https://repo.example.com/account/api-keys"
  }
}
```


### basic

The `basic` method indicates that the client must present a username and password using HTTP Basic authentication.

```
Authorization: Basic <base64(username:password)>
```

The credentials MUST be encoded as specified in [RFC 7617][rfc7617].

The `auth` object for this method uses only the common properties (`type`, `hint`, `hint_url`). No additional properties are defined.

Example:

```json
{
  "auth": {
    "type": "basic",
    "hint": "Use your repository account credentials.",
    "hint_url": "https://repo.example.com/register"
  }
}
```

[rfc7617]: https://datatracker.ietf.org/doc/html/rfc7617


### oauth2

The `oauth2` method indicates that the client must authenticate using an [OAuth 2.0][rfc6749] authorization flow.

The `auth` object for this method defines the following additional properties:

* `authorization_url` (required) - A URL string. The OAuth 2.0 authorization endpoint.
* `token_url` (required) - A URL string. The OAuth 2.0 token endpoint.
* `scopes` (optional) - A list of strings. The OAuth 2.0 scopes required for access. If omitted, the client SHOULD request no specific scopes.

Clients SHOULD support the Authorization Code flow as defined in [RFC 6749, Section 4.1][rfc6749-s4.1]. Clients MAY support additional flows as appropriate.

Example:

```json
{
  "auth": {
    "type": "oauth2",
    "authorization_url": "https://repo.example.com/oauth/authorize",
    "token_url": "https://repo.example.com/oauth/token",
    "scopes": ["packages:read"],
    "hint": "Sign in with your repository account to download.",
    "hint_url": "https://repo.example.com/register"
  }
}
```

[rfc6749]: https://datatracker.ietf.org/doc/html/rfc6749
[rfc6749-s4.1]: https://datatracker.ietf.org/doc/html/rfc6749#section-4.1


## Combining Authentication with Entitlements

When a package has both `entitlements` (on the metadata) and `auth` (on a release), the two work together:

1. The client verifies the user's entitlement by contacting the vendor's entitlement service, as described in [Entitlement Verification](./specification.md#entitlement-verification).
2. The entitlement service returns an [entitlement proof](./specification.md#entitlement-proof) JWT.
3. The client presents the entitlement proof as a bearer token to the repository when downloading artifacts.

In this flow, the repository's `auth` type is typically `bearer`, and the token is the entitlement proof JWT. The repository validates the JWT signature and expiration before serving the artifact.

This separation allows:
- **Vendors** to control who can access their packages (via the entitlement service).
- **Repositories** to enforce access without needing their own authorization logic (by validating JWTs).
- **Aggregators and caches** to enforce the same access controls (by accepting the same JWTs).
- **Users** to move between repositories without losing their entitlements.

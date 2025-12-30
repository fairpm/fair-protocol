# Implementing Repositories

Repositories are sites that host packages for download. They can host anything from a single package up to millions.

This page summarizes how to create your own repository, but for most vendors we recommend using an existing repository, whether self-hosted or provided as a service.

The full details of how repositories work are available in the [FAIR specification](../../specification.md).


## Creating new packages

### Creating a PLC DID

The first step to creating a new package for your repository to offer is to create the DID for the package. (If a user is migrating an existing package from another repository, see below.)

We strongly recommend the use of PLC DIDs for all packages, as they provide data portability, require no infrastructure setup, and have built-in facilities to recover from problems.

The public-facing DID will contain the verification method, associated services, and other metadata. For PLC DIDs, other data including the rotation key will be stored in the audit log.


#### Key creation

Creating a PLC DID requires the creation of at least two cryptographic keys: a rotation key, and a verification key. The rotation key is used for managing the DID itself, and the verification key is used for package signing.

Repositories should generally control both of these keys, and allow a user to provide the public key for their own rotation key. In the PLC directory, "earlier" rotation keys can override "later" ones (i.e. those first in the list can override any key after it), so the user's rotation key should be placed first. This allows them to override any erroneous operations if needed.

Rotation keys must use ECDSA, with either a K-256 (secp256k1) or NIST P-256 (secp256r1/prime256v1) key. We recommend the use of K-256, as most implementations using the PLC directory use it.

Note that keys must use the low-S form of the key, and must be encoded in compact (IEEE-P1363) form. This ensures keys are stored in canonical form, and prevents key confusion attacks.


#### DID creation

PLC DIDs are created by building a genesis operation, signing this operation, encoding the signed operation, and then submitting it to the PLC directory for creation.

The specifics of PLC DID creation are documented [in the PLC specification](https://web.plc.directory/spec/v0.1/did-plc). We recommend using an existing implementation of the process, such as the FAIR-provided libraries, as the DAG-CBOR encoding and canonicalization process can be difficult to work with. Note also that the format of operations does not match the DID format directly.

When creating a new DID, we recommend creating it *without* specifying the FAIR service initially, to allow the use of the ID as your primary database identifier, and to allow it to be specified in the service URL.


#### Setting the DID's data

To be a valid FAIR package DID, your DID must contain one service with the type `FairPackageManagementRepo`. (The protocol does not currently permit multiple repositories, but might in the future to make migrations easier.)

This service must have a URL where clients can download the "metadata document" for the package - in other words, the details for this particular package. Typically, this means a single REST API endpoint for this package:

```json
{
	"service": [
		{
			"id": "#fairpm_repo",
			"type": "FairPackageManagementRepo",
			"endpoint": "https://my.repo.example/packages/did:plc:abced12345"
		}
	]
}
```


## Providing package metadata

The main API about a single package is called the "metadata document". This document gives information about the package, including the name of the package, contact information, and the latest releases.

For example, a metadata document might look like:

```json
{
	"@context": "https://fair.pm/ns/metadata/v1",
	"id": "did:plc:abced12345",
	"type": "plugin",
	"license": "MIT",
	"authors": [
		{
			"name": "Jane Doe",
			"url": "https://janedoe.dev",
			"email": "jane@janedoe.dev"
		}
	],
	"security": [
		{
			"email": "security@janedoe.dev"
		}
	],
	"slug": "example-plugin",
	"name": "Example Plugin",
	"description": "A simple example FAIR package plugin.",
	"keywords": ["example", "plugin", "fair"],
	"sections": {
		"changelog": "<ul><li>1.2.0: Added new feature.</li><li>1.1.0: Bug fixes.</li></ul>",
		"description": "This plugin demonstrates FAIR package metadata.",
		"security": "Report vulnerabilities to security@janedoe.dev."
	},
	"releases": [
		{
			"version": "1.2.0",
			"artifacts": {
				"package": {
					"url": "https://my.repo.example/packages/did:plc:abced12345/v1.2.0/plugin.zip",
					"content-type": "application/zip",
					"signature": "zQ3shwa7usQaHQqiUMCRweiWD2Njb8sZBynkqxD3VXMSzSorc",
					"checksum": "sha256:abcdef1234567890"
				}
			}
		}
	]
}
```

Some of this data is used when users are browsing for packages to install (called "discovery"), while other data is used for installing packages.

### Top-level data

The metadata document is a JSON document, using JSON-LD, and contains the following properties:

- `@context` (required, string or list) - Must be set to `https://fair.pm/ns/metadata/v1`
- `id` (required, string) - The package’s DID.
- `type` (required, string) - The package type; either `wp-plugin` or `wp-theme`
- `license` (required, string) - [SPDX license code](https://spdx.org/licenses/); typically "GPL-2.0-or-later"
- `authors` (required, list) - List of authors. Each author must have a `name`, and typically a `url` or `email`
- `security` (required, list) - List of security contacts. Each contact must have a `url` or `email`, and need at least one contact.
- `releases` (required, list) - List of available releases. See below.
- `slug` (optional, string) - Suggested slug for installation.
- `name` (optional, string) - Human-readable name of your package.
- `description` (optional, string) - Human-readable description of your package. Max 140 characters, text-only.
- `keywords` (optional, list) - List of keyword strings. Max 5 items.
- `sections` (optional, list) - Documentation sections to display to users. See below.

Note that a security contact is *required*, as many legal jurisdictions require software vendors to provide this.


#### Sections

Your package can display different "sections" of information to users who are looking to install it. The following sections are supported:

* `changelog` - A list of changes to the package.
* `description` - The primary description and information for the package.
* `installation` - Instructions to the user on how to install the package.
* `faq` - Frequently asked questions about the package.
* `other_notes` - Miscellaneous additional notes.
* `security` - Information about the security of the package and how to report vulnerabilities.
* `screenshots` - Preview images of the package's UI.

(Any other sections will be ignored.)

These sections are typically displayed to users in tabs, with the `description` section shown by default as the "main" section.

You can provide HTML here, but only specific tags are allowed:

* `a` with `href`, `title`, `rel` attributes
* `blockquote` with `cite` attribute
* `br`
* `p`
* `code`
* `pre`
* `em`
* `strong`
* `ul`
* `ol`
* `dl`
* `dt` with `id` attribute
* `dd`
* `li`
* `h3`
* `h4`


### Releases

The releases part of the package metadata specifies which versions of your package are available for installation, and how to install them.

Note: each release item is a Release Document in [the specification](../../specification.md). If your API provides a single endpoint for releases, include `"@context": "https://fair.pm/ns/release/v1"`. If it's just part of your package endpoint, omit it.

For example, a release document might look like:

```json
{
	"version": "1.2.0",
	"provides": {
		"feature": ["example-feature"]
	},
	"requires": {
		"did:plc:defabc1234": "*",
		"env:php": ">=8.2"
	},
	"suggest": {
		"did:plc:fedcba1234": "*"
	},
	"auth": {
		"type": "bearer",
		"hint": "Sign in to access premium features.",
		"hint_url": "https://my.repo.example/buy"
	},
	"artifacts": {
		"package": {
			"id": "main",
			"url": "https://my.repo.example/packages/did:plc:abced12345/v1.2.0/plugin.zip",
			"content-type": "application/zip",
			"signature": "zQ3shwa7usQaHQqiUMCRweiWD2Njb8sZBynkqxD3VXMSzSorc",
			"checksum": "sha256:abcdef1234567890"
		},
		"icon": {
			"url": "https://my.repo.example/packages/did:plc:abced12345/v1.2.0/icon.png",
			"content-type": "image/png"
		}
	}
}
```


### Top-level data

The metadata document is a JSON document, using JSON-LD, and contains the following properties:

- `@context` (required if standalone, string or list) - Must be set to `https://fair.pm/ns/release/v1`
- `version` (required, string) - The version string for this particular release. Should be in [semver format](https://semver.org/)
- `requires` (optional, object) - Dependencies for this package.
- `suggest` (optional, object) - Suggested packages to install with this package.
- `provides` (optional, object) - Capabilities provided by the package.
- `auth` (optional, object) - Authentication needed to install this package.
- `artifacts` (ooptional, object) - Artifacts for this release, see below.


### Version

The version of the release should follow the [semver format](https://semver.org/), and we encourage the use of semantic versioning.

Your version should be in the format `{major}.{minor}.{patch}`. For pre-releases, you can add a `-alpha`, `-beta`, `-rc` and optionally a number; eg `1.2.3-beta.4`

If you're publishing builds created automatically, you might want to add extra metadata - you can add this with a `+` prefix at the end. Clients will ignore this data completely when deciding what to install, but it can be useful to help track down where the version came from.


### Dependencies (requires/suggest)

Packages can either require or suggest other packages, using their IDs.

Currently, only the `*` version constraint is allowed for package requirements (in other words, allow any version), but this may change in the future.

Additionally, packages can require platform dependencies, namely PHP versions or PHP extensions. These can be specified as `env:php` for PHP itself, and `env:phpext-...` for extensions (e.g. `env:php-intl`). You can also require WordPress versions with `env:wp`.

You can't require packages of a different type, but you can suggest them - for example, a theme cannot depend on plugins, but it can suggest that they be installed.

Version constraints may use the `<=`, `<`, `>`, `>=`, and `!=` operators, and only one constraint is allowed - this is likely to change in the future to match similar tools.

For example, a `Requires at least: 6.2` header would map to `"env:wp": ">=6.2"`, and `Requires PHP: 8.2` would map to `"env:php": ">=8.2"`.


### Provides

The provides data gives a way to indicate "capabilities" provided by the plugin, such as features.

The only supported capability right now is `blocks`, which should be a list of block IDs that the package provides:

```json
{
	"provides": {
		"blocks": [
			"myplugin/navigation",
			"myplugin/table-of-contents"
		]
	}
}
```


### Authentication

Packages can require authentication - for example, packages which require a user to purchase them, or which are intended to be privately-published.

See [the restricted package documentation](./restricted.md) for more information.


### Artifacts

Artifacts are any types of asset attached to the release - this includes the zip for the package itself, icons, banners, and language packs.

Each artifact can contain a `signature` which is verified against the signing keys specified by the DID. If it doesn't match one of the valid keys, installation will be rejected.

It can also contain a `checksum`, which is used to verify that the package was downloaded correctly. This should be a `sha256` or `sha384` checksum, and the value should be prefixed with which function was used.

Each artifact can either be a single artifact or multiple in a list.


#### The main artifact (package)

The main zip containing your package itself should be available as the `package` artifact. This should always include a `signature` and a `checksum` to allow clients to verify the package when they install it.


#### Variants (types and languages)

Artifacts might have multiple variants, which you can specify with different properties.

If you want to provide multiple types of an artifact, such as a zip and tarball, these can be distinguished with `content-type`. For example:

```json
"package": [
	{
		"id": "main",
		"url": "https://example.fair.pm/packages/1234/v1.2.0/plugin.zip",
		"content-type": "application/zip",
		"signature": "zQ3shwa7usQaHQqiUMCRweiWD2Njb8sZBynkqxD3VXMSzSorc",
		"checksum": "sha256:abcdef1234567890"
	},
	{
		"id": "main",
		"url": "https://example.fair.pm/packages/1234/v1.2.0/plugin.tar.gz",
		"content-type": "application/gzip",
		"signature": "zwa7usQaHQqiUMCRweinkqxD3VXMSzSorcWD2Njb8sZBynQ3sh",
		"checksum": "sha256:abcdef1234567890"
	}
]
```

You can also provide different language variants with `lang` - this should be a language code matching the typical WP language codes. Clients will typically filter out any artifacts they can't handle or which don't match the user's preferences (such as their language).


#### Listing images (icons, banners and screenshots)

For plugins and themes, you can also specify `icon`, `banner` and `screenshot` types. These should be PNG, JPG, SVG, or GIFs. You should include the `content-type`, `height`, and `width` properties for these. If it contains text, consider providing multiple `lang` variants.

Icons should be square images, either 128x128 or 256x256.

Banners should be either 72x250 and 1544x500. Banners SHOULD NOT exceed 4MB.

Screenshots can be any size, but SHOULD NOT exceed 10MB.

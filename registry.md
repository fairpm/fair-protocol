# Registry

This document is a registry for the known extensions to the FAIR Package Management Protocol, along with defined package and artifact types.

## Extensions

| Name                                         | Contact            |
| -------------------------------------------- | ------------------ |
| [FAIR Authentication Methods](./ext-auth.md) | FAIR Working Group |
| [FAIR for WordPress Packages](./ext-wp.md)   | FAIR Working Group |
| [FAIR for TYPO3 Packages](./ext-typo3.md)    | FAIR Working Group |


## Package Types

| Type              | Extension                                  | Contact            |
| ----------------- | ------------------------------------------ | ------------------ |
| `wp-core`         | [FAIR for WordPress Packages](./ext-wp.md) | FAIR Working Group |
| `wp-plugin`       | [FAIR for WordPress Packages](./ext-wp.md) | FAIR Working Group |
| `wp-theme`        | [FAIR for WordPress Packages](./ext-wp.md) | FAIR Working Group |
| `typo3-core`      | Reserved for future use.                   | FAIR Working Group |
| `typo3-extension` | [FAIR for TYPO3 Packages](./ext-typo3.md)  | FAIR Working Group |
| `typo3-theme`     | Reserved for future use.                   | FAIR Working Group |

## Environment Keys

Environment keys appear in the `requires`, `suggests`, and `compatibility` maps of Release Documents, prefixed with `env:`. They represent runtime environment requirements that are not themselves FAIR packages.

| Key | Extension | Description | Value format |
| --- | --------- | ----------- | ------------ |
| `env:php` | FAIR for TYPO3, FAIR for WordPress | PHP interpreter version | semver range |
| `env:php-{name}` | FAIR for TYPO3, FAIR for WordPress | PHP extension presence. The suffix `{name}` is the PHP extension identifier (e.g. `env:php-json`, `env:php-mbstring`). | semver range, or `*` for any version |
| `env:typo3` | FAIR for TYPO3 | TYPO3 CMS version | semver range |
| `env:wp` | FAIR for WordPress | WordPress core version | semver range |

`env:php-{name}` is a pattern key matching any key of the form `env:php-` followed by a valid PHP extension name. The value `*` means presence is required but any version is acceptable. Clients that cannot determine the installed version of a PHP extension MAY treat a specific version constraint as unfulfilled.

For Composer integration: `env:php` maps to the `php` platform package; `env:php-{name}` maps to `ext-{name}`; `env:typo3` maps to `typo3/cms-core`; `env:wp` maps to `roots/wordpress`.


## Authentication Methods

| Method   | Extension                                    | Contact            |
| -------- | -------------------------------------------- | ------------------ |
| `bearer` | [FAIR Authentication Methods](./ext-auth.md) | FAIR Working Group |
| `basic`  | [FAIR Authentication Methods](./ext-auth.md) | FAIR Working Group |
| `oauth2` | [FAIR Authentication Methods](./ext-auth.md) | FAIR Working Group |

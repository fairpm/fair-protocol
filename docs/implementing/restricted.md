# Restricted Packages

FAIR builds the concept of "restricted" packages right into the protocol. These are packages which require some form of authentication, such as a token or a username and password.

In the WP ecosystem, many types of restricted packages are available, including privately-published plugins and premium plugins. FAIR builds support for these into the protocol.


## Indicating a restricted package

To indicate a restricted package, your package metadata can specify an `auth` property, indicating that the package is only available for authorized users.

In the FAIR plugin, two types of authentication are supported:

* `bearer` - This type indicates that a bearer token (such as an API key) is required.
* `basic` - This type indicates that a username and password is required.

The `hint` property can be provided to provide human-readable text indicating why authentication is required, and `hint_url` provides a way to link users to more information or a purchase page.

For example, a premium plugin could provide the following:

```json
{
	"auth": {
		"hint": "Example Plugin requires an active subscription. Visit the link to purchase it, or enter your token.",
		"hint_url": "https://plugin.example.com/buy",
		"type": "bearer"
	}
}
```

The FAIR plugin would then display the following UI:

...

# Publishing Your Package

So you're ready to publish your plugin or theme? Great!

The first decision you'll need to make is which repository to host from. You can always change your repository later, so don't stress too much. If this is your first time doing it, we recommend using our repository.

To publish, you'll need to get an ID that uniquely identifies your plugin. Your repository will create your Decentralized ID (DID) for you, as well as create encryption keys.


## Create your plugin

Using your selected repository, create your package. You'll receive back your unique DID, alongside a recovery key.

Add your DID to your plugin header as `Plugin ID`, alongside your Plugin Name and other headers:

```php
<?php
/**
 * Plugin Name: My Example Plugin
 * Plugin ID: did:plc:ia6vk5krwkcka2nwuzs6l6lq
 * Description: ...
```

**Save your recovery key, and treat it like a password.** Your recovery key can be used if your original repository ever has a problem.

(For themes, this should be added as `Theme ID` instead.)



## Advanced

### Web DIDs

By default, repositories will create a DID for you using the Public Ledger of Credentials (PLC). This DID type uses a public, open, auditable registry maintained for the public interest by Bluesky.

We use PLC DIDs as they're abstract identifiers which can change over time, allowing flexibility. However, FAIR also supports another type of DID, the Web DID.

Web DIDs don't use a central registry at all, and instead are based directly on a hostname and path. They are formed like a URL, using the hostname and a path (but, with `/` replaced with `:`). For example, `did:web:example.com:my-plugin` is the Web DID for `example.com/my-plugin`.

Web DIDs a severe limitation which means we do not recommend them: **Web DIDs cannot be changed if names change over time**. For example, if you use `did:web:foo.example` and later rename from `foo.example` to `bar.example`, you cannot change the DID, as this would break updates for users.

They also do not necessarily support the full auditability of PLC DIDs. The PLC registry publishes a full audit log for every PLC DID, allowing users to check that the package they're using hasn't been hijacked.

FAIR supports Web DIDs for anyone who does wish to use them in spite of the caveats, as they allow truly decentralized repositories.

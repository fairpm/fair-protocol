# How It Works

## IDs

In a traditional WP site, each plugin on your site is identified by the folder name of the plugin, which is called the "slug". For example, a plugin at `wp-content/plugins/query-monitor/` has the slug `query-monitor`.

This slug is used when searching directly for a plugin to install, when checking for updates, and when collecting statistics. No two plugins can share the same slug, and even if you create a private plugin only for your own use, the slug will still be sent as part of statistics collection and checked for updates. The slug can also never be changed, even if the plugin is renamed or another company takes over it.

In the FAIR system, plugins are instead identified by their unique ID, which always starts with `did:`. [DID stands for Decentralized ID](https://en.wikipedia.org/wiki/Decentralized_identifier), and is a W3C standard. They're also used in other decentralized systems, like Bluesky.

FAIR supports two types of DIDs by default, PLC DIDs (`did:plc:...`) and Web DIDs (`did:web:...`):

* PLC DIDs are IDs that are registered in a public ledger, operated as a free, open service by Bluesky. For example, [`did:plc:ia6vk5krwkcka2nwuzs6l6lq`](https://web.plc.directory/did/did:plc:ia6vk5krwkcka2nwuzs6l6lq)
* Web DIDs are IDs which refer to a domain name (and path, with `/` replaced by `:`). For example, `did:web:example.com:plugins:my-plugin`

When you install a new plugin or update one by its DID, your site looks up the DID to find out information about the ID. This information includes two key components:

* Which "repository server" you are using
* Which keys are valid for signatures

Generally, FAIR packages use PLC DIDs, as they are more powerful and more secure than Web DIDs.


## Repositories

A server that publishes plugins and themes is called a "repository".

In the traditional WP model, there is a single "official" repository at `wordpress.org` which has special capabilities. Plugins are assumed to be hosted on the official repository, update checks are performed using it automatically, and users search for new plugins using only this official repository.

Third-party plugins can bundle their own code to handle updates for themselves by overriding this behaviour, but the system isn't designed for this. They don't get the full capabilities that the "official" repository gets, and users can't easily install new plugins without manually uploading zips.

It's also difficult to move from the "official" repository to a new one, as there's no mechanism for pointing users to your new repository.

In the FAIR system, every repository is equal.

Information attached to each plugin's DID specifies which repository to use. Developers can switch repositories by updating their DID's information.

The FAIR plugin automatically detects plugins with a DID, and handles updates directly from the attached repository. It also lets users search for new plugins, no matter which repository they come from.


## Discovery Servers

In the decentralized world, one challenge is working out how to find plugins in the first place. While users could install a plugin directly just with the DID, many users will instead want to search for plugins which solve a problem they might have. "Discovery" servers solve this problem.

In the traditional WP model, the single "official" repository has search and category listings, such as featured plugins. Any plugin that is not on the "official" repository is not available when searching, and can't be installed through the regular user interface - only by downloading and uploading zips.

In the FAIR system, discovery servers find all plugins which have been published, and provide easy-to-use search and listings. Just like how search engines discover content on the web and act as the "front door" to the rest of the web, discovery servers discover packages and act as the front door to repositories.

Anyone can build a discovery server, but FAIR operates an open discovery server available for everyone to use.


## Analytics

In the traditional WP model, the single "official" repository collects analytics data, and makes only a small amount of this data available to package publishers through aggregate metrics. Detailed data is available only to people who operate the site, and there are no guarantees about conflicts-of-interest in the usage of this data.

In the FAIR system, FAIR operates an open analytics system which sites publish data to.

Each site pings statistics to the analytics system with what plugins and versions are in use, and this data is collected anonymously. Aggregate metrics are published on this analytics data, and are available to everyone.

No single actor has special access to this data, and the analytics system is operated by the FAIR Web Foundation for the benefit of all. Strict rules govern the use of and access to this data.

This data can be used by plugin maintainers to check data about their own plugins, by discovery servers to find which plugins exist, and for any other purpose such as research.

Because this analytics data naturally contains all DIDs for plugins from sites that are reporting, it allows discovery servers to find new plugins - although discovery servers can always choose whether to use this data or not.


## Moderation

In the traditional WP model, the single "official" repository is responsible for all moderation, such as marking releases as insecure.

Users and publishers cannot make choices about this moderation, and due to the opaque nature of the "official" repository, this system can be abused by bad actors.

On the flip side, because the "official" repository only knows about packages published through it, moderators who want to help protect the ecosystem cannot help to block known-bad packages like hacked plugins.

There is also no opportunity for others in the ecosystem to contribute to this, such as security companies being able to offer scanning. While efforts like Tide have tried to do this, they have to be built in to the "official" repository, making implementation difficult.

In the FAIR system, every plugin has a globally-unique ID, so anyone can build services that "layer on top" of the core functionality. This includes moderation services, which provide scoring - basically, a thumbs up or thumbs down on each package.

FAIR offers an official moderation service to help protect the ecosystem. This moderation service is used to indicate insecure packages which should never be installed, such as in the case of malware publication.

Anyone can offer their own moderation service which users can opt in to. For example, users might choose to only install packages which have been manually approved by a trustworthy source, or they may pay a security company to help them block less-secure packages. Hosts might also offer a moderation service to their customers which blocks incompatible plugins.

Users can choose their moderation services, including disabling the built-in, FAIR-provided moderation service.

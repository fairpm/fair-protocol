# What is FAIR?

FAIR is a distributed protocol for package management, guaranteeing security, data portability, and control, while providing a seamless user experience for finding, installing, and updating packages.

FAIR was built for the WordPress ecosystem to manage plugins and themes, removing reliance on centralized systems.


## What is the protocol?

FAIR replaces the concept of a single centralized repository for packages with a fully decentralized system, allowing vendors to host their packages anywhere - from self-hosted repositories to third-party services.

At the heart of the FAIR protocol is the Decentralized ID, or "DID". Each package gets a DID which uniquely identifies the package, and which allows looking up which repository the package uses. DIDs are also associated with cryptographic signing keys, building security into the heart of the protocol.

Packages are hosted on a repository which provides the metadata about the package (such as name, description, icons, and screenshots) as well as the package assets themselves, such as zips. Clients (like WordPress) connect to repositories to fetch this data, check for new versions, and download updates or assets to install.

Because the DID tells the client which repository to pull data from, no centralized service is necessary once a client knows which package DIDs it wants to install. This works just like the open web: in the same way that browsers interact directly with websites, clients interact directly with repositories.

But just like the open web, finding packages when you don't already know the ID requires that you have a database of them. Similar to a search engine, FAIR introduces a "discovery aggregator", which brings together data from across the web of repositories into one place. It builds off models pioneered by other decentralized technologies like Bluesky's AT Protocol, proven to solve these issues even at scale. With the aggregators acting independently, users have the choice to switch aggregators - such as using one provided by their web host.

With cryptography foundational to the protocol, every package is signed. This allows mirroring the data to caching servers, such as those inside a host's data center, reducing bandwidth usage and saving energy. Even with mirrors, signatures can still be easily verified, retaining user trust.

Since each package has a fully unique ID, services can be "layered on top" to provide additional functionality. A moderation service can block users from installing known-dangerous packages, or highlight recommended packages - or even integrate with commercial services like vulnerability scanners.


## How do I get started?

If you're a plugin vendor, check out the [documentation in this directory](./README.md) to learn about how FAIR can help you distribute plugins.

Interested in running your own repo? Our [Mini FAIR Repo plugin](https://github.com/fairpm/mini-fair-repo) is designed to allow you to turn your WordPress site into a repository to host your packages.

If you want to build your own repository implementation, our [implementation guide](./implementing/README.md) provides an overview, with the [specification documents](../specification.md) giving the full detailed run-down.

For more about the overall system design and where we're heading, our [initial design document](./initial-design.md) lays out the overall system in much more detail, including the roadmap for the next functionality we'll be working on.

We'll be providing more docs as we build out the system further - contribution and feedback from all is welcomed! [Start a discussion](https://github.com/fairpm/fair-protocol/discussions) or [open an issue](https://github.com/fairpm/fair-protocol/issues) to dive in.

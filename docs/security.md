# Security

Security is at the heart of the FAIR system, and is a fundamental design principle of the system.


## Security of DIDs

FAIR is designed to protect against a package being hijacked by anyone else. This is incorporated into the core design of the system, with the use of Decentralized IDs that cannot be controlled by any one entity.

For PLC DIDs, these IDs are published to the PLC registry, and a full audit log is available for each. Changes to DIDs can only be made by actors with access to the encryption keys used to control the DID - called "registration keys".

The default repository implementation is designed to give you control over your DID. When the repository creates your DID for you, it provides the "recovery key". This key is the *primary* registration key, it belongs solely to you, and your repository does not keep a copy of it.

The repository also controls your DID with its own registration key, which is the secondary registration key. It controls this in order to manage the service information in your DID.

Because the repository's key is secondary, your recovery key can override the secondary key and remove it. The PLC directory also provides a grace window of 48 hours where your recovery key can remove a prior operation - so if the repository ever "goes rogue", there's a built in way to recover your DID.

Since you control the primary key, you can also move to a different repository - such as one that you trust more, or even one that you run yourself.


## Security of packages

Each DID contains a list of keys which are valid to sign packages, integrating a package signing system directly with the DID.

Since the signing keys are part of the DID, there is a hard link directly between your DID and valid packages. No other entity can publish packages on your behalf.

Your repository can manage your DID on your behalf, so it also has the ability to update your verification keys, and could add a malicious key. This would allow it to issue its own packages under your DID.

This is not considered a major issue within the threat model, as in most cases your repository is already packaging and signing your packages, so must be trustworthy already. There are also cases where this may be beneficial, such as the repository's security team issuing an update on your behalf.

However, situations can change, and repositories may become untrustworthy in the future. While we recommend using repositories that you trust, you can override changes to your DID by using your recovery key to revert this change within 48 hours. This limits the "blast radius" of problems that could occur.

For publishers who are concerned about this vector, we recommend running your own repository to maintain full control of your DID and package systems. Note that this may be complex to run, and you also potentially have higher risks as there is no ability for others to help you update plugins or recover your DID.


## Security of FAIR-controlled data

Due to the nature of the FAIR system, very little data is centrally controlled by FAIR.

There are four components run by FAIR for the benefit of the ecosystem:

* The "main" repository, for publishers who don't want to run their own
* A discovery aggregator
* The central analytics service
* The main moderation service

These services are hosted on servers provided by GoDaddy, who are a well-reputed host who have XXX compliance standards. The FAIR team includes experienced staff familiar with data privacy laws and secure architecture.


### Main Repository

The main repository is run by FAIR to provide a "default" repository publishers can use for their packages. We provide this so that publishers can easily get their packages out, without needing to worry about setting up their own infrastructure.

This system contains the private keys used to manage DIDs for users, as well as signing keys for each package. As a result, it requires the highest level of security.

{Add further detail about security here.}


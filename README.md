# xrootd-scitokens

Collection of basic examples for scitoken usage. Most cases are currently
focused on authentication/authorization for XRootD access.

## Table of Contents

1. [Using provided container](#using-provided-container)
2. [How to get a token](#how-to-get-a-token)
3. [Inspect token contents](#inspect-token-contents)
4. [XRootD copy](#xrootd-copy)

## Using provided container

The provided container will allow you to run tests without needing to install
any token software on your host. It's also aimed at documenting the packages
required for an EL-flavored OS, as well as document some use cases.

Examples of running the container:

```sh
docker run -it wmoore28/xrootd-scitokens:latest bash
apptainer exec docker://wmoore28/xrootd-scitokens:latest bash
singularity exec docker://wmoore28/xrootd-scitokens:latest bash
```

Once the container is running, you'll find the token examples are installed
into the container's `/usr/local/bin/`. Proceed to the next sections for things
to test.

## How to get a token

It's important to note the _issuer_ and _role_ will be different depending on
which project you are associated with. While the below snippets are examples,
you'll need to know those specifics for the commands to work correctly.
Referencing the scripts in `/usr/local/bin/` may clarifiy which you should use.

```sh
# Usage: htgettoken -a <vaultserver> -i <issuername> -r <rolename>
$ htgettoken -a htvault.jlab.org -i jlab -r gluex
Attempting OIDC authentication with https://htvault.jlab.org:8200

Complete the authentication at:
    https://cilogon.org/device/?user_code=<redacted>
Running 'xdg-open' on the URL
Couldn't open web browser with 'xdg-open', please open URL manually
Waiting for response in web browser
```

Go to the URL provided, select your identity provider and log in. After
returning to the terminal, you should see something like:

```sh
Storing vault token in /tmp/vt_u0
Saving credkey to /root/.config/htgettoken/credkey-jlab-gluex
Saving refresh token ... done
Attempting to get token from https://htvault.jlab.org:8200 ... succeeded
Storing bearer token in /tmp/bt_u0
```

## Inspect token contents

Contents will be different depending on the specific token you request. But to
get some idea, it should be similar to:

```json
httokendecode -H
{
  "sub": "http://cilogon.org/serverA/users/[REDACTED]",
  "aud": "ANY",
  "ver": "scitoken:2.0",
  "nbf": "Fri Feb 24 18:04:12 UTC 2023",
  "scope": "read:/gluex/ write:/gluex/",
  "iss": "https://cilogon.org/jlab",
  "exp": "Fri Feb 24 21:04:17 UTC 2023",
  "iat": "Fri Feb 24 18:04:17 UTC 2023",
  "jti": "https://cilogon.org/oauth2/[REDACTED]?type=accessToken&ts=1677261857623&version=v2.0&lifetime=10800000",
  "group": "gluex"
}
```

### Token Lifetime

The difference in _issued at (iat)_ and _expiration time (exp)_ will tell you
the token lifetime. If your process will outlive this lifetime, you'll need
to refresh the token. In the most simple case, that can be done by calling
`htgettoken` again.

## XRootD copy

We found setting the `$BEARER_TOKEN_FILE` environment variable to be a clean way
to use `xrdcp`. Note: the _data transfer node (dtn)_ and file path on the jlab-side
will be specific to your project and this is for example purposes.

```sh
htgettoken -a htvault.jlab.org -i eic
export BEARER_TOKEN_FILE=/tmp/bt_u${UID}

hostname > xrdcp-test
date >> xrdcp-test
xrdcp -f xrdcp-test roots://dtn2201.jlab.org//eic/eic2/transfer/
```

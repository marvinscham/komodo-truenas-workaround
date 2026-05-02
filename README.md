# Komodo TrueNAS Docker CLI Workaround

This repository builds a small wrapper image around `ghcr.io/moghtech/komodo-periphery:2` for TrueNAS SCALE and similar environments where Komodo Periphery runs in a container against an older Docker Engine on the host.

It exists as a temporary workaround for [moghtech/komodo#1249](https://github.com/moghtech/komodo/issues/1249), where stack actions such as restart, stop, destroy, and deploy can fail with errors like:

```text
ParseAddr("fd75:922a:3856:9::1/64"): unexpected character, want colon (at "/64")
```

## What It Does

The upstream Komodo Periphery v2 image may include newer Docker CLI and Docker Compose plugin versions than the Docker Engine provided by the host. In the issue discussion, the failure appears to be triggered by newer Docker client tooling parsing IPv6 gateway values returned by older Docker Engine versions, especially when the address includes a CIDR suffix such as `/64`.

This image keeps the Komodo Periphery v2 base image, but pins the Docker client tools inside the container to older versions that have been reported to avoid the issue.

## When To Use This

Use this image if all of these apply:

- You run Komodo Periphery v2 in a container.
- The container talks to the host Docker socket.
- Your host Docker Engine is older than the Docker CLI / Compose versions bundled in the upstream Periphery image.
- Komodo stack actions fail with `ParseAddr(... /64)` errors, or `docker network ls` fails from inside the Periphery container.
- You are running TrueNAS SCALE, Unraid, or another platform where upgrading the host Docker Engine is difficult or unsupported.

## Usage

Use the published image anywhere you would normally use `ghcr.io/moghtech/komodo-periphery:2`.

For example, in a Compose file:

```yaml
services:
  periphery:
    image: ghcr.io/marvinscham/komodo-truenas-workaround:latest
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
```

Keep the rest of your Komodo Periphery configuration the same as your existing deployment.

## Caveats

This is not an upstream fix. It only changes the Docker client tooling available inside the Periphery container.

- Komodo may eventually require newer Docker CLI or Compose features.
- Future upstream Periphery images may change their package setup.
- The root issue may be fixed in Docker, Docker Compose, or Komodo, making this image unnecessary.

Track the upstream issue for current status: [moghtech/komodo#1249](https://github.com/moghtech/komodo/issues/1249).

# Docker Infrastructure

This directory contains the Docker build contexts and configuration for the `hotssi` ecosystem's custom infrastructure images.

> [!NOTE]
> **Migration Notice**:
> This directory and its contents were migrated from the deprecated `hotssi/docker-images` repository.
> All future updates to Docker images and build configurations should be made here.

## Directory Structure

| Directory           | Description                                                                                 |
| :------------------ | :------------------------------------------------------------------------------------------ |
| `n8n-custom`        | Custom n8n image with OCI CLI and additional tools installed. Used for workflow automation. |
| `woodpecker-agent`  | Custom Woodpecker CI agent image.                                                           |
| `woodpecker-server` | Custom Woodpecker CI server image.                                                          |
| `scripts`           | Helper scripts for maintenance (e.g., version checking).                                    |
| `_templates`        | Templates for new Docker projects.                                                          |

## Build Workflows

The GitHub Actions workflows responsible for building and pushing these images are located in the repository root:

- **n8n**: [`../../.github/workflows/build-n8n.yml`](../../.github/workflows/build-n8n.yml)
- **Woodpecker Agent**: [`../../.github/workflows/build-woodpecker-agent.yml`](../../.github/workflows/build-woodpecker-agent.yml)
- **Woodpecker Server**: [`../../.github/workflows/build-woodpecker-server.yml`](../../.github/workflows/build-woodpecker-server.yml)

## Maintenance

To check for upstream version updates, you can run the version check script:

```bash
./scripts/check-versions.sh
```

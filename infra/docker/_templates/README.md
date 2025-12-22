# [Image Name]

Brief description of this custom image.

## Features

- Feature 1
- Feature 2
- Feature 3

## Build

```bash
# From project root
./scripts/build.sh [image-name] [version]

# Or from this directory
docker build --build-arg VERSION=latest -t mindulle/[image-name]:latest .
```

## Usage

```bash
docker run -d \
  --name [container-name] \
  -p [host-port]:[container-port] \
  -v [volume-name]:/path/in/container \
  mindulle/[image-name]:latest
```

## Environment Variables

- `VAR_NAME`: Description (default: value)

## Configuration

Describe any configuration files or setup needed.

## Examples

### Example 1: Basic Usage

```bash
docker run mindulle/[image-name]:latest
```

### Example 2: With Custom Config

```bash
docker run -v ./config:/etc/app mindulle/[image-name]:latest
```

## References

- [Upstream Project](https://example.com)
- [Documentation](https://docs.example.com)

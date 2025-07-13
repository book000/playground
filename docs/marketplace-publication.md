# Publishing to GitHub Marketplace

This document provides instructions for publishing the WireGuard SSH Action to the GitHub Marketplace.

## Preparation Steps

### 1. Repository Requirements

- [x] `action.yml` file at repository root
- [x] Proper action metadata (name, description, author, branding)
- [x] Comprehensive README.md with usage examples
- [x] All inputs properly documented

### 2. Action Metadata Validation

The `action.yml` file includes:

- ✅ **name**: Clear, descriptive action name
- ✅ **description**: Concise explanation of functionality  
- ✅ **author**: Action author information
- ✅ **branding**: Icon and color for marketplace display
- ✅ **inputs**: All required and optional inputs with descriptions
- ✅ **runs**: Composite action implementation

### 3. Testing

Before publishing, test the action:

1. **Local Testing**: Use the example workflows in `.github/workflows/`
2. **Integration Testing**: Test with actual WireGuard server setup
3. **Edge Cases**: Test with various input combinations

## Publication Process

### 1. Create Release

1. Navigate to the repository on GitHub
2. Click "Releases" → "Create a new release"
3. Create a new tag (e.g., `v1.0.0`)
4. Set release title: "WireGuard SSH Action v1.0.0"
5. Add release notes describing features and usage

### 2. Publish to Marketplace

1. In the release form, check "Publish this Action to the GitHub Marketplace"
2. Select the primary category: **"Deployment"**
3. Add relevant tags:
   - `wireguard`
   - `ssh`
   - `vpn`
   - `networking`
   - `security`
   - `deployment`

### 3. Marketplace Requirements

- ✅ Repository must be public
- ✅ Repository must have a unique action name
- ✅ Action metadata must be valid
- ✅ Must include proper README documentation
- ✅ Must follow GitHub's marketplace guidelines

## Action Versioning

### Semantic Versioning

- **Major (v1.0.0)**: Breaking changes to inputs/outputs
- **Minor (v1.1.0)**: New features, backward compatible
- **Patch (v1.0.1)**: Bug fixes, backward compatible

### Branch Strategy

- `main`: Latest stable version
- `v1`: Major version branch (automatically updated)
- Tags: Specific versions (`v1.0.0`, `v1.0.1`, etc.)

## Usage in Other Repositories

Once published, users can reference the action:

```yaml
# Latest major version (recommended)
uses: book000/playground@v1

# Specific version (most secure)
uses: book000/playground@v1.0.0

# Main branch (not recommended for production)
uses: book000/playground@main
```

## Marketplace Guidelines Compliance

### Required Files
- [x] `action.yml` - Action metadata
- [x] `README.md` - Documentation and examples
- [x] `LICENSE` - License information (if applicable)

### Content Guidelines
- [x] Clear, descriptive action name
- [x] Helpful description and documentation
- [x] Proper input/output documentation
- [x] Usage examples
- [x] Security considerations documented

### Technical Requirements
- [x] Valid `action.yml` syntax
- [x] Proper shell scripting practices
- [x] Error handling and cleanup
- [x] Security best practices (no hardcoded secrets)

## Security Considerations for Publication

1. **No Hardcoded Secrets**: All sensitive data passed via inputs
2. **Input Validation**: Action validates all inputs appropriately
3. **Cleanup**: Temporary files and connections are cleaned up
4. **Least Privilege**: SSH user should have minimal permissions
5. **Documentation**: Security setup clearly documented

## Post-Publication Maintenance

1. **Monitor Issues**: Respond to user-reported issues
2. **Security Updates**: Keep WireGuard and SSH practices current
3. **Feature Requests**: Consider backwards-compatible enhancements
4. **Version Updates**: Regular updates for security and features

## Testing with the Published Action

After publication, test the action in a separate repository:

```yaml
name: Test Published Action
on: workflow_dispatch

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: book000/playground@v1
        with:
          command: 'echo "Testing published action"'
          # ... other required inputs
```

This ensures the action works correctly when consumed from the marketplace.
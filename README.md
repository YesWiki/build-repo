# yeswiki-build-repo

Build script to package [YesWiki] **extensions** and **themes**.

## Install

Pre-requisite : `php@7.3` with `composer`, `jq`.

```bash
composer install
```

## Usage

```bash
sh entrypoint.sh <yeswiki-extension-path> <output-dir> <extension-name?> <extension-version?>
```

For example:

```bash
# with minimal arguments
sh entrypoint.sh path/to/extension ./dist

# with explicit name and version
sh entrypoint.sh path/to/extension ./dist yeswiki-extension-publication 2020-09-27-1
```

See [Docker Setup](#docker-setup) to run it from everywhere, [including a GitHub Action](#use-it-in-a-github-action) and a [GitLab CI Runner](#use-it-in-a-gitlab-ci-runner).

## Use it in a GitHub Action

```yaml
# .github/workflows/main.yml
on: [push]

jobs:
  package:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2

    - name: Test and package the extension
      id: package
      uses: yeswiki/yeswiki-build-repo@v1

    - name: Create a release
      uses: actions/create-release@v1
      # ...

    - name: Upload zip file
      uses: actions/upload-release-asset@v1
      # ...

    - name: Upload md5 file
      uses: actions/upload-release-asset@v1
      # ...
```

See it in action in [yeswiki/yeswiki-extension-publication](https://github.com/yeswiki/yeswiki-extension-publication).

## Use it in a GitLab CI Runner

Soon.

<!-- See it in action in [oncletom/yeswiki-extension-test](https://gitlab.com/oncletom/yeswiki-extension-test). -->

## Docker setup

```bash
docker build -t yeswiki/yeswiki-build-repo .
```

```bash
docker run --rm -v $(pwd)/yeswiki-extension-test:/yeswiki-extension-test yeswiki/yeswiki-build-repo /yeswiki-extension-test /tmp/output
```
## Roadmap

- [x] Make it work with GitHub Actions
- [ ] Make it work with GitLab CI
- [ ] Infer extension name from `composer.json`, and make it optional too
- [ ] Notify YesWiki extension registry
- [ ] YesWiki extension pulls updated artifacts

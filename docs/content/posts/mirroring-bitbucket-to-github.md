+++
title = 'Mirroring Bitbucket to Github'
date = 2023-11-21T09:48:25Z
draft = true
summary = 'Setting up a pipeline to automatically mirror a git repository from Bitbucket to Github'
+++
> Only works for public source repo
{.note}

## Setting up keys
### Bitbucket
Repository Settings -> Pipelines -> SSH Keys
- Default bitbucket key not secure enough for GitHub, need to select 'Use my own keys'
    - If this option isn't available, you probably need to delete the existing key first
- run `ssh-keygen -t ecdsa -b 256` locally to generate private/public keys
    - Copy into the fields provided

### Github
Create a new empty repo
Settings -> Security -> Deploy Keys -> Add deploy key

- Copy public key generated above.
- Enable write access


### Create bitbucket-pipelines.yml file

```yaml
image: atlassian/default-image:2 # This is needed to avoid gnutls_handshake issues
clone:
  enabled: false # No point using default clone, we'll need to do it manually anyway
pipelines:
  default:
    - step:
        script:
          - git clone --mirror ${BITBUCKET_GIT_HTTP_ORIGIN} ./mirrored;
          - cd ./mirrored;
          - git push --mirror git@github.com:<github-org>/<github-repo>.git
```



Default clone target originating branch see --branch. Therefore need to reclone.
```bash
GIT_LFS_SKIP_SMUDGE=1 retry 6 git clone --branch="develop" \
  https://x-token-auth:$REPOSITORY_OAUTH_ACCESS_TOKEN@bitbucket.org/$BITBUCKET_REPO_FULL_NAME.git $BUILD_DIR

Cloning into '/opt/atlassian/pipelines/agent/build'...

```

## References
- https://blog.idrsolutions.com/how-to-sync-bitbucket-repo-to-github/
- https://medium.com/@dmitryshaposhnik/sync-bitbucket-repo-to-github-669458ea9a5e
- https://community.atlassian.com/t5/Bitbucket-questions/Cannot-use-Bitbucket-Pipelines-failed-Handshake-failed/qaq-p/1467066
- https://stackoverflow.com/a/73246676

## TODO
Resolve private repo syncing
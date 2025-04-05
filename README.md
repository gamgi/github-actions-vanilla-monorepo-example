# An example CI/CD setup for a monorepo using vanilla GitHub Actions

An example on how to use GitHub actions in a monorepo.

Designed for an organization with multiple cloud deployment environments, programming languages and collaborators.

## Documentation

This repo is the basis for a blog post.

☞ [Read the full blog post here](https://generalreasoning.com/blog/software/cicd/2025/03/22/github-actions-vanilla-monorepo.html).

## Features

* Vanilla GitHub Actions
  * No third-party actions (besides the ones by AWS and Docker)
  * No external build system (no Bazel, Pantsbuild, Turborepo, nx, etc.)
  * No hacks, such as the [paths-filter](https://github.com/dorny/paths-filter) and [alls-green](https://github.com/marketplace/actions/alls-green) actions
* Monorepo with multiple programming languages (Javascript, Python)
* Cloud native deployment to AWS using cloudformation or CDK (no Kubernetes)
* Development environment that shares tool versions with CI (devcontainers)
* Deployment to multiple environments (development, staging, production)

## Demo

* [PR](https://github.com/gamgi/github-actions-vanilla-monorepo-example/pull/3) demonstrating changes to a component
* [PR](https://github.com/gamgi/github-actions-vanilla-monorepo-example/pull/4) demonstrating changes to CI base image
* Open the repo in devcontainer or using GitHub Codespaces

## High level overview

The codebase is organized into components on the root level.
Each component can be deployed individually.

We split the GitHub Actions into a common deployment workflow, two additional supporting workflows, and individual component-specific workflows.

```
./
├── .devcontainer/
│   ├── node/
│   │   └── devcontainer.json
│   └── python/
│       └── devcontainer.json
│
├── .github/
│   └── workflows/
│       ├── common-deploy.yaml
│       ├── common-deploy-images.yaml
│       ├── common-deploy-skip.yaml
│       │
│       ├── component-a-trigger.yaml
│       ├── component-b-trigger.yaml
│       ├── component-c-trigger.yaml
│       │
│       ├── images-python-trigger.yaml
│       └── images-node-trigger.yaml
│
├── component-a/
│   ├── scripts/
│   ├── src/
│   └── package.json
│
├── component-b/
│   ├── scripts/
│   ├── src/
│   └── pyproject.toml
│
├── component-c/
│   ├── scripts/
│   ├── src/
│   └── pyproject.toml
│
└── images/
    ├── node.Dockerfile
    └── python.Dockerfile
```

The design has four main parts:

1. **The component specific workflows**, such as `component-a-trigger.yaml`, define the *paths and triggers* for the workflow.
These determine when a workflow should run.
2. **The common workflow**,  `common-deploy.yaml` defines *setup* steps, as well as *common* steps for all jobs.
It initializes environment variables, activates a GitHub environment (more on that below), logs in to AWS and runs the predefined set of shell scripts.
3. **The shell scripts for each job**, such as `component-a/scripts/lint.sh` perform the desired actions.
Each component defines its own set of shell scripts.
The contents of say, `lint.sh`, could be `npm run lint` or `pylint` depending on the component.
4. **A set of container images for the CI** ensure, that most components' workflows have the same tool versions.
They are also used as devcontainers.

Using shell scripts is contrary to what the GitHub Actions documentation suggests.
It's common to use pre-built actions and inline bash in the YAML files.
We found that using shell scripts is *crucial* for keeping the steps locally runnable.

The high-level relationships between the parts in this setup are seen in the following diagram:

![Component level diagram of GitHub Actions for a monorepo](https://generalreasoning.com/assets/posts/2025/2025-03-22-github-actions-for-monorepo-diagram.png)

# Git Subtree Setup Guide

A guide for sharing code between repositories using git subtrees.

## Prerequisites

1. Create a folder for the separate repo and add your files
2. Create an empty repository on GitHub (or equivalent)

## Setup

### 1. Add the Remote

```bash
git remote add <remote-name> <repository-url>
```

**Example:**
```bash
git remote add bootstrap git@github.com:dommcdev/bootstrap.git
```

### 2. Push to the Remote Repository

```bash
git subtree split --prefix=public -b split-branch
git push bootstrap split-branch:main
```

## Pulling Changes

To pull changes from the public repo back to your private repo:

```bash
git subtree pull --prefix=public bootstrap main --squash
```

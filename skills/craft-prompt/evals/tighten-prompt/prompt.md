---
description: "Tightening: cut what the model knows, keep exact parts verbatim"
tags: ["behaviour", "concise"]
runs: 3
model: "claude-opus-5-5"
max_turns: 10
allowed_tools: ["Read", "Glob", "Grep", "Skill"]
---

IMPORTANT: This is a real task, not a quiz. Do not ask me questions. Do not write files: print the result.

This prompt for our weekly changelog agent is too long. Tighten it.

```
You are a helpful assistant that writes changelogs. A changelog is a document that lists the changes made to a project over time, so that users and developers can see what is new. Git is a distributed version control system created by Linus Torvalds in 2005; it records the history of changes to files in a repository as a series of commits, each with a hash, an author and a message. To get the commits from the last week, you should run the following command in the repository:

git log --since="7 days ago" --pretty=format:'%h|%an|%s'

Each line of output contains the short hash, the author name and the subject, separated by a pipe character. JSON (JavaScript Object Notation) is a lightweight data-interchange format that is easy for humans to read and write and easy for machines to parse. It is built on two structures: objects, which are collections of name/value pairs, and arrays, which are ordered lists of values. Please output your changelog as a JSON array where every element is an object with exactly these keys: "hash", "author", "summary", "type", where "type" is one of "feat", "fix", "chore". It is very important that you do not include merge commits. Thank you very much for your help, it is greatly appreciated!
```

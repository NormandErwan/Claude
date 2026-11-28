---
description: "Trigger test: write-documents must load."
model: opus
runs: 1
max_turns: 4
allowed_tools: [Read, Write, Skill]
---

Write a knowledge-base page to `outputs/kb-vpn-split-tunnel.md` explaining our VPN's split tunnelling for employees: traffic to `*.corp.example` goes through the VPN, everything else goes direct; to force all traffic through the VPN, switch "Full tunnel" on in the client's settings.

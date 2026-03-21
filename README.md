# Redmine Auto Assign Plugin

Automatically assigns an issue to the first user who logs time against it.

---

## Overview

The **Redmine Auto Assign Plugin** improves workflow efficiency by ensuring issues are assigned when work begins.

When a user logs time on an issue:

- If the issue is **unassigned**, it is assigned to that user
- If the issue status is **"New"**, it is changed to **"In Progress"**

---

## Features

- Auto-assigns issue on first time entry
- Updates issue status from *New → In Progress*
- Lightweight and non-intrusive
- No UI changes required
- Works with standard Redmine time tracking

---

## Requirements

- Redmine 6.x
- Compatible Ruby version (per your Redmine install)

---

## Installation

1. Copy the plugin into your Redmine plugins directory:

```bash
cd /path/to/redmine/plugins
git clone https://github.com/rickbarrette/redmine_auto_assign.git
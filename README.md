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
```

2. Restart your Redmine server so the plugin and hooks are loaded.

## License

> The MIT License (MIT)
>
> Copyright (c) 2016 - 2026 Rick Barrette
>
> Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
>
> The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
>
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
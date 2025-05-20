---
title: Home
layout: home
nav_order: 1
description: "Another neovim configuration"
permalink: /
---

# leovim
{: .fs-9 }

leovim is another Neovim configuration. 
{: .fs-6 .fw-300 }

[Get started now](#getting-started){: .btn .btn-primary .fs-5 .mb-4 .mb-md-0 .mr-2 }
[View it on GitHub](https://github.com/leogabac/leovim){: .btn .fs-5 .mb-4 .mb-md-0 }

---

{: .warning }
> There is a lot of missing documentation. Work in progress.

Welcome to leovim. At first I made it for myself when I wanted to heavily modify the behavior of my Neovim distribution at the time, after changing too much, I decided to make my own configuration.

This is _not_ a neovim distribution, but a template that you can use, modify, and make your own. In fact, I encourage you to keep and use this configuration along your own. To do this, go to the [FAQ](./faq.md) section.

## Features

* Simplicity
* Preconfigured LaTeX support

## Getting started

### Requirements

**Mandatory**
- neovim > 0.10.0

**Optional**

- 


### Installation

Clone the repopository
```bash
git clone https://github.com/leogabac/leovim.git ~/.config/nvim
```
and launch
```bash
nvim
```

### Documentation

To see what all of the plugins leovim has, and how to work with some of them, you can go to the [Documentation](https://leogabac.github.io/leovim).

### License

Just the Docs is distributed by an [MIT license](https://github.com/leogabac/texodachi/blob/main/LICENSE).

#### Thank you to the contributors of leovim!

<ul class="list-style-none">
{% for contributor in site.github.contributors %}
  <li class="d-inline-block mr-1">
     <a href="{{ contributor.html_url }}"><img src="{{ contributor.avatar_url }}" width="32" height="32" alt="{{ contributor.login }}"></a>
  </li>
{% endfor %}
</ul>

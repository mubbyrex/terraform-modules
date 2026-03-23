# Terraform Modules

This is my personal collection of reusable Terraform modules.

I built this repo as I learn and experiment with Terraform at a deeper level. Instead of rewriting the same infrastructure over and over, I’m gradually extracting things into reusable modules here.

If it’s useful to you too, feel free to use anything 👍

---

## Structure (roughly)

```
terraform-modules/
├── aws/
│   ├── vpc/
│   ├── ec2/
│   ├── rds/
│   └── security-group/
├── kubernetes/
│   └── namespaces/
├── global/
│   └── tagging/
```

There’s no strict rule here — just grouping things in a way that makes sense to me.

---

## Why this repo exists

- To avoid duplicating Terraform code across projects
- To practice writing **clean, reusable modules**
- To simulate how a real team/platform repo might look
- To experiment with versioning, structure, and patterns

---

## How I approach modules

I try to follow a few simple rules:

- Keep modules **small and focused**
- Treat them like **building blocks**, not “do everything” modules
- Avoid hardcoding values
- Expose only what’s actually needed via outputs
- Add validation where it makes sense

Nothing too rigid — just trying to build good habits.

---

## Versioning

```
v1.0.0
v1.1.0
```

The idea is:

- Pin versions when using modules elsewhere
- Avoid breaking things unintentionally
- Be able to roll back if needed

---

## Usage

Example:

```hcl
module "vpc" {
  source = "git::https://github.com/<your-username>/terraform-modules.git//aws/vpc?ref=v1.0.0"

  cidr_block = "10.0.0.0/16"
}
```

---

## Notes

- Things may change, break, or be refactored anytime
- Some modules might be more complete than others

---

## What I’m experimenting with here

- Better module design
- Versioning strategy
- Reusability across environments
- Keeping things simple but flexible

---

## If you’re using this

Just:

- Pin versions
- Read the module before using it
- Don’t assume everything is battle-tested

---

## Final note

This repo is basically me getting better at Terraform in public.

It’ll keep evolving as I learn more.

# Officer Daily Workflow

Quick reference for handling tickets.

## Daily Checklist

**Morning:**
- [ ] Check [new tickets](../../issues?q=is%3Aissue+is%3Aopen+label%3A%22status%3A+new%22)
- [ ] Acknowledge within SLA ([see times](sla-reference.md))
- [ ] Check [overdue tickets](../../issues?q=is%3Aissue+is%3Aopen+label%3Aoverdue)

**Throughout day:**
- [ ] Respond to comments/updates
- [ ] Update `in-progress` tickets
- [ ] Check `waiting-for-user` (auto-closes after 7 days)

**Before end of day:**
- [ ] Any urgent tickets resolved?
- [ ] All new tickets acknowledged?

## Ticket Workflow

1. **New ticket** → Read → Change to `acknowledged` → Comment
2. **Need info?** → Change to `waiting-for-user` → Ask specific questions
3. **Working on it?** → Change to `in-progress` → Update every few days
4. **Fixed?** → Change to `resolved` → Ask for confirmation
5. **Confirmed?** → Close the issue

## Labels to Use

**Status** (one per ticket):
- `new` → `acknowledged` → `in-progress` → `resolved` → `closed`
- `waiting-for-user` (side branch when need info)

**Priority** (adjust if wrong):
- `urgent` (critical), `high` (blocking), `medium` (default), `low` (nice to have)

**Category** (one per ticket):
- `hardware`, `software`, `network`, `access`, `data`, `compute`, `procurement`, `other`
- `long-term` for multi-week projects

**Override** (when SLA doesn't apply):
- `complex-issue` - needs deep investigation
- `waiting-external` - blocked by vendor/NUS IT/etc
- `sla-exception` - special project
- `acknowledged-delay` - approved extension

## Special Cases

**Procurement (6 week timeline):**
- Verify PI approval before ordering
- Track: approval → order → delivery → setup
- Update stakeholders on timeline
- Extended SLA automatic, no override needed

**Long-term projects:**
- Use `[Long-term]` in title (auto-detected)
- Post weekly updates
- Break into milestones if complex
- Exempt from SLA

**Leave periods:**
- Set `.github/on-leave.yml`
- SLA tracking pauses automatically
- Welcome message updates
- Reminder issue created on return

## Commands

```bash
# View tickets by status
gh issue list --label "status: new"
gh issue list --label "overdue"
gh issue list --label "priority: urgent"

# Run label audit (dry run first!)
gh workflow run label-audit-fix.yml -f dry_run=true
gh workflow run label-audit-fix.yml -f dry_run=false

# Trigger weekly report manually
gh workflow run weekly-summary.yml
```

## Tips

- **Respond fast** - Even "I see this, looking into it" helps
- **Update regularly** - Every few days for ongoing work
- **Verify urgency** - Don't let people abuse urgent priority
- **Close proactively** - Don't let resolved tickets sit open
- **Use override labels** - Better than missing SLA on legitimate exceptions

See [SLA Reference](sla-reference.md) for detailed timing info.

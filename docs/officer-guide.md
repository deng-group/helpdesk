# Computer Officer Guide

This is your cheat sheet for managing the help desk. It's not meant to be comprehensive documentation—just the stuff you'll actually use day-to-day.

---

## Your Daily Routine

**Morning (5-10 mins)**

Start your day by checking what came in overnight:
- Go to the [Issues tab](../../issues) and filter by `status: new`
- Read through new tickets and leave a quick acknowledgment comment
- Change the label from `new` to `acknowledged`
- If something looks complicated or needs external help (like waiting on NUS IT), add the `complex-issue` or `waiting-external` label right away

Check if anything's gone stale:
- Filter by `overdue` label—automation flags these for you
- Look at `status: waiting-for-user` tickets—if they haven't responded in over a week, ping them or close it

**During the day**

Just respond to stuff as it comes in. You'll get email notifications when people comment on tickets.

**Before you leave**

Quick 2-minute check: any urgent tickets you missed? Any in-progress tickets that need a status update?

---

## How to Handle Tickets

Here's the basic flow:

**Step 1: Read it**
- What's the actual problem? (Sometimes what they say isn't what they mean)
- Did they mark it as urgent when it's really not? Adjust the priority if needed
- Do you have enough info to help them?

**Step 2: Acknowledge it**
Just drop a quick comment:
```
Hi [name], got your ticket. Looking into it now.
```
Change label to `acknowledged`.

**Step 3: Work on it**
- If you need more info from them: change to `waiting-for-user` and be specific about what you need
- If you're actively fixing it: change to `in-progress`
- For anything that takes more than a day or two, drop an update comment every few days so they know you haven't forgotten

**Step 4: Close it**
- When it's fixed: change to `resolved` and ask them to confirm it works
- After they confirm (or after 48 hours of silence): close the issue

**Long-term tasks**

These are different—they're multi-week projects like setting up new systems or buying equipment. For these:
- Review the scope first. Is this realistic? Do you have what you need?
- Break it into phases/milestones if it's complicated
- Post weekly updates even if it's just "still working on phase 2"
- Keep track of budgets and approvals
- These usually get the `priority: low` label but they're still important work

---

## Labels Explained

You only use one label from each category:

**Status** (where the ticket is)
- `new` → just submitted, need to acknowledge
- `acknowledged` → you've seen it
- `in-progress` → actively working on it
- `waiting-for-user` → need more info from them
- `resolved` → fixed, waiting for confirmation
- `closed` → done

**Priority** (how urgent)
- `urgent` → critical system down, data loss, grant deadline tomorrow
- `high` → blocking their work, no workaround
- `medium` → annoying but they can work around it
- `low` → nice to have

Don't let people abuse "urgent"—if it's not truly urgent, just adjust it and explain why.

**Category** (what type of problem)
- `hardware`, `software`, `network`, `access`, `data`, `compute`, `long-term`, `other`

These are usually correct from the template but double-check.

**Special labels** (use sparingly)

Use these when the normal SLA tracking doesn't apply:
- `complex-issue` → requires deep investigation, might take longer than normal
- `waiting-external` → blocked by NUS IT, vendor, hardware delivery, etc.
- `sla-exception` → special projects that don't fit normal support scope
- `acknowledged-delay` → you've reviewed it and approved an extended timeline

Don't overuse these! They're for genuinely exceptional cases. Most tickets should follow normal timeframes.

---

## Response Templates

Copy-paste these and customize:

**Acknowledging a ticket**
```
Hi @username,

Got your ticket. Looking into it now and will update you soon.

Tim
```

**Need more info**
```
Hi @username,

To help you out, I need a bit more info:
- [specific thing 1]
- [specific thing 2]

Once I have that, I can get started.

Tim
```

**Progress update** (use every 2-3 days for slow issues)
```
Hi @username,

Quick update: [what you're doing]. Should have this sorted by [timeframe].

Tim
```

**Marking as resolved**
```
Hi @username,

Fixed! [explain what you did]

Can you test it on your end and let me know if it's working?

Tim
```

**Closing it out**
```
Great! Glad it's working. Closing this now.

If anything else comes up, just open a new ticket.

Tim
```

**Long-term task update**
```
Hi @username,

Progress update:

Done:
- [x] Phase 1
- [x] Phase 2

Working on:
- [ ] Phase 3 - [status]

Still on track for [deadline].

Tim
```

**Complex issue** (when you add that label)
```
Hi @username,

This is more complex than expected—it's going to require [explanation].
I'm marking this as a complex issue, so it might take [timeframe] to sort out.

I'll keep you posted on progress.

Tim
```

**External dependency** (when you add that label)
```
Hi @username,

This is blocked by [NUS IT / vendor / hardware order]. I've [submitted ticket #123 / placed order / contacted them].

I'll follow up and update you when I hear back.

Tim
```

---

## When to Escalate

**To Prof. Deng:**
- Access requests that need PI approval
- Budget/purchasing decisions
- Policy questions
- If someone's upset with the support they're getting

**To NUS IT:**
- Building-wide network problems
- Campus-wide service outages
- Security incidents
- Infrastructure stuff you can't fix

**To vendors:**
- Licensed software issues (MATLAB, etc.)
- Hardware under warranty
- Specialized services

---

## Tips from Experience

**Communication**
- Respond fast, even if it's just "I've seen this"
- Keep people updated on long-running issues—silence makes them anxious
- Be friendly but you don't need to be formal
- If you don't know something, it's okay to say "let me look into that"

**Managing your time**
- Do all your acknowledgments in one batch
- Don't spend 4 hours on a low-priority ticket when high-priority stuff is waiting
- Set reminders for tickets you're waiting on
- It's fine to say "this will take a few days" upfront

**Prioritization**
When you have a bunch of tickets, work in this order:
1. Urgent + overdue (drop everything)
2. High + overdue (get on it today)
3. Urgent + new (start immediately)
4. High + in-progress (keep going)
5. Everything else by age

**When you're stuck**
- Search old closed tickets—you probably solved this before
- Google the exact error message
- Ask other group members
- Check vendor documentation
- Post in relevant forums

**Build a knowledge base as you go**
When you solve something tricky, add it to the FAQ. Future you will thank past you.

---

## Going on Leave

Before you're out:
1. Go to `.github/on-leave.yml` and set `on_leave: true`
2. Update `leave_end` with your return date
3. Add `urgent_instructions` (who to contact)
4. The bot will automatically tell people you're away
5. Let Prof. Deng know

When you're back, set `on_leave: false`.

---

## Weekly Maintenance

**Every Monday:**
- Review the automated weekly report (it's posted as an issue)
- Close any old `waiting-for-user` tickets (>14 days)
- Update the FAQ if you keep getting the same questions

**Every month:**
- Check if response time targets are realistic
- Look for patterns—lots of the same category? Maybe there's a bigger issue

---

## Quick GitHub Tips

**Filters you'll use a lot:**
```
is:issue is:open label:"status: new"
is:issue is:open label:overdue
is:issue is:open label:"priority: urgent"
is:issue is:open label:"status: waiting-for-user"
```

**Using GitHub CLI** (optional but faster):
```bash
# See all open tickets
gh issue list

# See new tickets
gh issue list --label "status: new"

# Close a ticket
gh issue close 123
```

---

## Emergency Situations

**If a major system goes down:**
1. Acknowledge ALL related tickets immediately
2. Create one master incident ticket
3. Link all the related tickets to it
4. Post updates to the master ticket every hour or so, even if it's "still working on it"
5. Once resolved, update everyone

**If you're overwhelmed:**
Talk to Prof. Deng. Maybe we need to update the FAQ, add more automation, or get you some help.

---

## Questions?

Update this guide with stuff you learn. It's a living document.

If something's confusing or you think the system needs changes, talk to Prof. Deng.

---

*Last updated: 2025-10-11*

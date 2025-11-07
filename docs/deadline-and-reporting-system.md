# Deadline Tracking & Weekly Reporting System

This document explains how the automated deadline tracking and weekly reporting systems work in the DENG Group Help Desk.

---

## Table of Contents

1. [Deadline Tracking System](#deadline-tracking-system)
2. [Weekly Report Generation](#weekly-report-generation)
3. [Exclusions and Overrides](#exclusions-and-overrides)
4. [Examples](#examples)

---

## Deadline Tracking System

### How It Works

The deadline tracker runs automatically **every day at 9 AM SGT** via GitHub Actions workflow (`.github/workflows/deadline-tracker.yml`).

### SLA Timeframes

Deadlines are calculated based on the ticket's **priority label** and **creation time**:

| Priority | Response Time | Resolution Time |
|----------|---------------|-----------------|
| `priority: urgent` | 2 hours | 8 hours |
| `priority: high` | 4 hours | 72 hours (3 days) |
| `priority: medium` | 24 hours | 120 hours (5 days) |
| `priority: low` | 48 hours | 168 hours (7 days) |

**Default Priority:** If no priority label is set, `priority: medium` is assumed.

### Deadline Stages

#### 1. Response Deadline
- **Applies to:** Tickets with `status: new` label
- **Measured from:** Time the ticket was created
- **What it means:** How quickly the officer should acknowledge the ticket

**Example:**
```
Ticket created: Monday 10:00 AM
Priority: high (4-hour response SLA)
Response deadline: Monday 2:00 PM
```

#### 2. Resolution Deadline
- **Applies to:** Tickets with `status: in-progress` or `status: acknowledged`
- **Measured from:** Time the ticket was created (not from acknowledgment)
- **What it means:** How quickly the issue should be fully resolved

**Example:**
```
Ticket created: Monday 10:00 AM
Priority: high (72-hour resolution SLA)
Resolution deadline: Thursday 10:00 AM
```

### Status Labels

The deadline tracker automatically applies these labels:

#### `at-risk` Label
- Applied when **less than 24 hours** remain until deadline
- Serves as an early warning
- Can be on response OR resolution deadline
- **No notification sent** - just a visual indicator

#### `overdue` Label
- Applied when the deadline has **passed**
- Replaces any `at-risk` label
- **Notification sent** to the computer officer via comment
- Comment includes:
  - How long past deadline (in hours/days)
  - Expected timeframe reminder
  - Mention to `@Tim-Pook` (or configured officer)

**Example overdue comment:**
```markdown
⏰ **Resolution Overdue**

This ticket has exceeded the expected resolution timeframe by 1.5 days.

@Tim-Pook - Please provide an update on progress.

*Expected resolution: 72 hours (~3.0 days)*
```

### Business Hours Note

The system calculates **calendar hours**, not business hours. The deadline comment includes a reminder:

> *Business hours: Mon-Fri, 9 AM - 5 PM SGT*

This reminds users that the officer may not respond outside business hours, even if technically "overdue."

---

## Weekly Report Generation

### When It Runs

The weekly report generates automatically **every Monday at 9 AM SGT** via GitHub Actions workflow (`.github/workflows/weekly-summary.yml`).

You can also trigger it manually:
1. Go to **Actions** tab
2. Click **Weekly Summary Report**
3. Click **Run workflow**

### Report Structure

The report is posted as a new GitHub issue with the `report` label.

#### 1. Overview Section

```markdown
## 📈 Overview

| Metric | Count |
|--------|-------|
| 🆕 New Tickets | 5 |
| ✅ Closed Tickets | 3 |
| 📂 Currently Open | 8 |
| 📌 Long-term Projects | 2 |
| 🔧 Exceptions & Complex | 3 |
| ⚠️ Overdue | 1 |

**Net Change:** +2
```

**What's counted:**
- **New Tickets:** Created in the past 7 days (excludes long-term projects)
- **Closed Tickets:** Closed in the past 7 days (excludes long-term projects)
- **Currently Open:** All open tickets right now (excludes long-term projects)
- **Long-term Projects:** Tickets with `category: long-term` label
- **Exceptions & Complex:** Tickets with override labels (see below)
- **Overdue:** Tickets with `overdue` label (excludes exceptions)

**Net Change:** New tickets minus closed tickets (positive = accumulating, negative = clearing backlog)

#### 2. Response Time Metrics

```markdown
## ⏱️ Response Time

- **Average Response Time:** 3.5 hours
- **Target:** <24 hours for medium priority

*Based on 3 resolved tickets this week*
```

**How it's calculated:**
1. For each ticket **closed this week**
2. Find the first comment by anyone other than the ticket creator
3. Calculate time difference between ticket creation and first response
4. Average all response times together

**Note:** This only includes tickets that were **closed** during the week, not all tickets that were opened.

#### 3. Open Tickets Breakdown

```markdown
## 📊 Open Tickets Breakdown

### By Priority
- priority: high: 3
- priority: medium: 4
- priority: low: 1

### By Category
- category: hardware: 2
- category: software: 3
- category: network: 1
- category: access: 2
```

Shows distribution of **currently open tickets** (excluding long-term projects) by priority and category labels.

#### 4. Exceptions & Complex Issues

```markdown
## 🔧 Exceptions & Complex Issues

*These tickets have override labels and are exempt from normal SLA tracking:*

- 🔍 #42: Database performance degradation
  - **complex issue** | status: in-progress | 12 days open
- ⏳ #38: Waiting for NUS IT firewall configuration
  - **waiting external** | status: acknowledged | 8 days open
- 🔗 #51: Fix connection pooling (parent: #49)
  - **sub issue** | status: in-progress | 3 days open
```

**What's included:**
- Tickets with any override label: `sla-exception`, `complex-issue`, `waiting-external`, `acknowledged-delay`, `sub-issue`
- Shows icon based on override type
- Displays current status
- **Shows how many days the ticket has been open**
- For sub-issues, shows parent issue reference
- **Sorted by longest open first**

**Icons:**
- 📋 `sla-exception` - Special projects
- 🔍 `complex-issue` - Requires deep investigation
- ⏳ `waiting-external` - Blocked by external dependencies
- ⏰ `acknowledged-delay` - Approved extended timeline
- 🔗 `sub-issue` - Child task of parent issue

#### 5. Attention Needed

```markdown
## ⚠️ Attention Needed

### Overdue Tickets (1)
- #67: Software installation not working

### Oldest Open Ticket
- #58 (23 days old)
```

**Overdue Tickets:**
- Lists all tickets with `overdue` label
- **Does NOT include** tickets with override labels (they can't be overdue)

**Oldest Open Ticket:**
- Single oldest ticket across all open issues
- **Excludes** long-term projects
- Helps identify stale tickets

#### 6. Tickets Opened This Week

```markdown
## 📋 Tickets Opened This Week

- #71: Printer not responding [priority: high, category: hardware]
- #72: VPN connection issues [priority: medium, category: network]
- #73: Access to cluster requested [priority: medium, category: access]
```

Lists all tickets **created in the past 7 days** with their priority and category.

#### 7. Tickets Closed This Week

```markdown
## ✅ Tickets Closed This Week

- #65: Password reset needed
- #66: Software license expired
- #68: File permission issue
```

Lists all tickets **closed in the past 7 days**.

#### 8. Long-term Projects

```markdown
## 📌 Long-term Projects (Ongoing)

- #45: Cluster storage expansion — **4 months** active [status: in-progress]
- #52: Migrate research data to new server — **2 months** active [status: acknowledged]
- #61: Set up CI/CD pipeline — **3 weeks** active [status: in-progress]

*Long-term projects are excluded from overdue tracking due to flexible deadlines.*
```

**What's included:**
- All open tickets with `category: long-term` label
- Shows how long they've been active (days/weeks/months)
- Shows current status
- **Sorted by longest active first**

**Note:** Long-term projects are **completely separate** from normal ticket tracking. They don't count toward "Currently Open" or overdue metrics.

#### 9. Insights

```markdown
## 💡 Insights

- ⚠️ High number of overdue tickets (4). Consider reviewing workload or priorities.
- ⚠️ Tickets are accumulating. New tickets outpacing closures.
- ✨ Excellent response time this week!
```

**Automatic insights triggered by:**
- No activity: `Quiet week! No new tickets.`
- 3+ overdue tickets: `High number of overdue tickets (X)`
- New tickets exceed closed by 5+: `Tickets are accumulating`
- All tickets resolved: `All tickets resolved! Great work!`
- Avg response < 12 hours: `Excellent response time this week!`

---

## Exclusions and Overrides

### What's EXCLUDED from Deadline Tracking

The following tickets are **completely exempt** from SLA enforcement and will **never** be marked `overdue` or `at-risk`:

#### 1. Long-term Projects
- **Label:** `category: long-term`
- **Why:** Have flexible deadlines (weeks/months), tracked separately
- **Duration options:** 1-2 weeks, 2-4 weeks, 1-2 months, 2-3 months, 3-6 months, 6+ months, Ongoing
- **Created via:** Long-term Task template

#### 2. Override Labels
Any ticket with one of these labels is exempt:

**`sla-exception`**
- For special projects outside normal support scope
- Example: Research collaboration setup, custom infrastructure

**`complex-issue`**
- Requires deep investigation beyond normal troubleshooting
- Example: Intermittent network issues, performance degradation

**`waiting-external`**
- Blocked by external dependencies
- Example: NUS IT ticket, hardware delivery, vendor support

**`acknowledged-delay`**
- Officer has reviewed and approved extended timeline
- Automatically applied when parent issues have sub-issues created

**`sub-issue`**
- Child task of a larger parent issue
- Example: Breaking down a complex problem into smaller tasks

#### 3. Officer on Leave
When `.github/on-leave.yml` has `on_leave: true`:
- **ALL SLA tracking stops** system-wide
- No overdue or at-risk labels applied
- Leave notices added to new tickets
- SLA resumes automatically when leave ends

### How Override Labels Work

When an override label is applied:

1. **Deadline tracker skips the ticket** entirely
2. **Removes existing `overdue` or `at-risk` labels** if present
3. **Logs:** `Issue #X has override label - skipping SLA checks`
4. **Shows in weekly report** under "Exceptions & Complex Issues" section

**Officer workflow:**
1. Identify ticket needs more time
2. Add appropriate override label
3. Comment to user explaining situation
4. Work on ticket without deadline pressure
5. Remove override label when returning to normal timeline (optional)

---

## Examples

### Example 1: Normal Ticket Lifecycle

**Scenario:** User reports software installation issue

```
Monday 9:00 AM - Ticket #100 created
  - Priority: medium (24h response, 5 day resolution)
  - Status: new

Monday 10:30 AM - Officer acknowledges
  - Status: new → acknowledged
  - Response time: 1.5 hours ✅ (within 24h)

Monday 2:00 PM - Officer starts working
  - Status: acknowledged → in-progress

Wednesday 9:00 AM - Deadline tracker runs
  - Age: 48 hours
  - Resolution deadline: 120 hours (5 days from Monday 9 AM)
  - Time remaining: 72 hours
  - Action: No label (still has 3 days)

Thursday 10:00 AM - Deadline tracker runs
  - Time remaining: 23 hours
  - Action: Adds 'at-risk' label ⚠️

Friday 8:00 AM - Officer resolves issue
  - Status: in-progress → resolved
  - Total time: 3 days 23 hours ✅ (within 5 days)

Friday 9:00 AM - User confirms fixed
  - Ticket closed

Monday (next week) - Weekly report
  - Counts in: "Closed Tickets" = 1
  - Response time: 1.5 hours (included in average)
```

### Example 2: Overdue Ticket

**Scenario:** High priority hardware issue

```
Monday 9:00 AM - Ticket #101 created
  - Priority: high (4h response, 3 day resolution)
  - Status: new

Monday 11:00 AM - Officer acknowledges
  - Response time: 2 hours ✅

Monday 2:00 PM - Officer starts investigation
  - Status: in-progress

Tuesday 9:00 AM - Deadline tracker runs
  - Time remaining: 48 hours
  - Action: None

Wednesday 9:00 AM - Deadline tracker runs
  - Time remaining: 24 hours
  - Action: None (not < 24 hours yet)

Thursday 8:00 AM - Still in progress

Thursday 9:00 AM - Deadline tracker runs
  - Age: 72 hours
  - Resolution deadline: 72 hours (Monday 9 AM + 3 days)
  - Time past deadline: 0 hours
  - Action: Adds 'overdue' label ⚠️
  - Comment: "Resolution Overdue - Please provide update"

Thursday 10:00 AM - Officer adds 'complex-issue' label
  - Deadline tracker will remove 'overdue' label tomorrow
  - Adds comment explaining complexity to user

Friday 9:00 AM - Deadline tracker runs
  - Sees 'complex-issue' label
  - Removes 'overdue' label ✅
  - Skips all SLA checks going forward

Next Monday - Weekly report
  - Shows under "Exceptions & Complex Issues"
  - Shows "5 days open"
  - NOT in "Overdue Tickets" section
```

### Example 3: Sub-Issue Creation

**Scenario:** Complex database problem broken into tasks

```
Monday 9:00 AM - Ticket #102 created: "Database very slow"
  - Priority: high
  - Status: new

Monday 10:00 AM - Officer investigates
  - Realizes this is complex
  - Status: in-progress

Monday 2:00 PM - Officer creates sub-issues
  - Creates #103: "Analyze slow queries"
    - Description includes: "Parent: #102"
    - Adds label: sub-issue
  - Creates #104: "Check index performance"
    - Description includes: "Parent: #102"
    - Adds label: sub-issue
  - Creates #105: "Review connection pooling"
    - Description includes: "Parent: #102"
    - Adds label: sub-issue

Monday 2:01 PM - Sub-issue handler workflow runs
  - Detects 'sub-issue' label on #103, #104, #105
  - Finds parent #102 in descriptions
  - Adds 'acknowledged-delay' to parent #102 ✅
  - Comments on #102: "Sub-issues created, deadline extended"
  - Comments on each sub-issue: "Linked to parent #102"

Tuesday 9:00 AM - Deadline tracker runs
  - Parent #102: Has 'acknowledged-delay' → Skipped ✅
  - Sub #103: Has 'sub-issue' → Skipped ✅
  - Sub #104: Has 'sub-issue' → Skipped ✅
  - Sub #105: Has 'sub-issue' → Skipped ✅
  - None will ever be marked overdue

Monday (next week) - Weekly report
  Shows under "Exceptions & Complex Issues":
  - #102: Database very slow
      acknowledged delay | 7 days open
  - #103: Analyze slow queries (parent: #102)
      sub issue | 7 days open
  - #104: Check index performance (parent: #102)
      sub issue | 7 days open
  - #105: Review connection pooling (parent: #102)
      sub issue | 7 days open
```

### Example 4: Officer Leave Period

**Scenario:** Officer goes on 1-week vacation

```
Friday 5:00 PM - Officer updates leave config
  - on_leave: true
  - leave_start: "2025-01-13"
  - leave_end: "2025-01-20"

Saturday 9:00 AM - Deadline tracker runs
  - Detects on_leave: true
  - Logs: "Officer is on leave - skipping SLA enforcement"
  - Exits without checking any deadlines ✅

Monday 9:00 AM - User creates new ticket #110
  - Welcome workflow detects leave status
  - Adds automated leave notice with return date

Tuesday 9:00 AM - User creates urgent ticket #111
  - Welcome workflow adds leave notice
  - Shows urgent instructions from config

Wednesday 9:00 AM - Deadline tracker runs
  - Still on leave
  - Skips all SLA checks ✅
  - No overdue labels applied

Monday 1/20 - Officer returns
  - Updates: on_leave: false

Tuesday 9:00 AM - Deadline tracker runs
  - Leave ended
  - Resumes normal SLA tracking ✅
  - Checks all open tickets

Tuesday 9:01 AM - Check-leave-status workflow runs
  - Creates reminder issue listing all tickets opened during leave
```

---

## System Files Reference

### Workflows
- **Deadline tracking:** `.github/workflows/deadline-tracker.yml`
- **Weekly reports:** `.github/workflows/weekly-summary.yml`
- **Sub-issue handling:** `.github/workflows/sub-issue-handler.yml`
- **Leave status check:** `.github/workflows/check-leave-status.yml`
- **New ticket welcome:** `.github/workflows/welcome.yml`

### Configuration
- **Officer info:** `.github/officer-config.yml`
- **Leave status:** `.github/on-leave.yml`

### Documentation
- **Officer procedures:** `docs/officer-guide.md`
- **This document:** `docs/deadline-and-reporting-system.md`

---

## Troubleshooting

### "Why isn't my ticket marked overdue?"

Check if the ticket has:
- ✅ One of the override labels (`sla-exception`, `complex-issue`, etc.)
- ✅ `category: long-term` label
- ✅ Officer is currently on leave
- ✅ Ticket is in `status: new` (only response deadline applies)
- ✅ Ticket is in `status: resolved` or `status: closed`
- ✅ Still within the SLA timeframe

### "Why is the weekly report missing tickets?"

Check if they're:
- ✅ Long-term projects (shown in separate section)
- ✅ Pull requests (excluded entirely)
- ✅ Created before the 7-day window
- ✅ Closed before the 7-day window

### "Can I manually trigger the deadline tracker?"

Yes!
1. Go to **Actions** tab
2. Click **Deadline Tracker**
3. Click **Run workflow**
4. Select branch (usually `main`)
5. Click **Run workflow**

Useful for testing or catching up after system maintenance.

---

## Best Practices

### For Officers

1. **Don't overuse override labels** - Most tickets should follow normal SLAs
2. **Add comments when applying overrides** - Explain to users why deadline is extended
3. **Review exceptions weekly** - Check the weekly report's exception section
4. **Close old exceptions** - When returning to normal timeline, remove override label
5. **Use sub-issues for complex work** - Break down problems, track separately
6. **Update leave config promptly** - Set leave status before departure

### For Users

1. **Set priority honestly** - Don't mark everything urgent
2. **Respond promptly** - Officer can't resolve without your input
3. **Check weekly reports** - Stay informed on helpdesk performance
4. **Be patient during leave** - SLA tracking pauses when officer is away

---

**Last Updated:** 2025-01-07

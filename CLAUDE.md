# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a GitHub Issues-based help desk system for the DENG Group at NUS. It uses GitHub Actions workflows to automate ticket tracking, deadline enforcement, weekly reporting, and officer leave management. The entire system runs without a traditional codebase—it's workflow automation that turns GitHub Issues into a full-featured help desk.

## Key Architecture Concepts

### Automated Workflow System

The help desk operates through interconnected GitHub Actions workflows located in `.github/workflows/`:

1. **Deadline Tracker** (`deadline-tracker.yml`) - Runs daily at 9 AM SGT
   - Enforces SLA timeframes based on ticket priority
   - Adds `overdue` and `at-risk` labels automatically
   - Skips tickets with override labels or during officer leave
   - Posts automated comments when deadlines are missed

2. **Weekly Summary** (`weekly-summary.yml`) - Runs every Monday at 9 AM SGT
   - Generates comprehensive statistics as a GitHub issue
   - Tracks new/closed tickets, response times, and overdue items
   - Separates long-term projects from regular tickets
   - Provides actionable insights based on metrics

3. **Sub-Issue Handler** (`sub-issue-handler.yml`) - Triggered on issue creation/labeling
   - Detects parent-child relationships via `Parent: #123` in descriptions
   - Automatically applies `acknowledged-delay` to parent issues
   - Links sub-issues back to their parent

4. **Status Label Cleanup** (`status-label-cleanup.yml`) - Triggered when labels are added
   - Automatically removes old status labels when a new status label is added
   - Prevents tickets from having multiple conflicting status labels
   - Operates silently without comments to avoid email notifications

5. **Leave Status Check** (`check-leave-status.yml`) - Runs daily
   - Creates reminder issues when officer returns from leave
   - Lists all tickets created during the leave period

6. **Welcome** (`welcome.yml`) - Triggered on new issues
   - Adds automated welcome messages to new tickets
   - Shows leave notices if officer is unavailable

7. **Label Audit & Fix** (`label-audit-fix.yml`) - Manual trigger only
   - Scans all open issues for incorrectly applied labels
   - Removes `overdue`/`at-risk` from long-term projects (detected by `[Long-term]` title or label)
   - Removes `overdue`/`at-risk` from issues with override labels
   - Fixes duplicate status labels (keeps most advanced status)
   - Supports dry-run mode to preview changes before applying
   - Results visible in Actions logs (no summary issue created)

### SLA Enforcement System

SLA timeframes are defined in `deadline-tracker.yml` and measured from ticket creation:

**Standard SLA (Priority-Based)**

Response Time (applies to `status: new`):
- Urgent: 4 hours
- High: 4 hours
- Medium: 24 hours (default)
- Low: 48 hours

Resolution Time (applies to `status: in-progress` or `status: acknowledged`):
- Urgent: 8 hours
- High: 72 hours (3 days)
- Medium: 120 hours (5 days)
- Low: 168 hours (7 days)

At-Risk Threshold (resolution):
- Standard tickets: 24 hours before deadline
- Procurement tickets: 168 hours (1 week) before deadline

**Procurement SLA** (for `category: procurement` tickets)

Special timeframes that override priority-based SLA:
- Response: 48 hours (2 days)
- Resolution: 1008 hours (6 weeks / 42 days)

Procurement tickets automatically use extended SLA to accommodate typical 4-8 week procurement timelines (approval → order → delivery → setup). No manual override labels needed.

### Label System

The system uses structured labels across three categories:

**Status Labels** (ticket lifecycle):
- `status: new` → Just submitted
- `status: acknowledged` → Officer has seen it
- `status: in-progress` → Being worked on
- `status: waiting-for-user` → Need more info
- `status: resolved` → Fixed, awaiting confirmation
- `status: closed` → Complete

**Priority Labels** (urgency):
- `priority: urgent` → Critical systems down
- `priority: high` → Blocking work
- `priority: medium` → Default
- `priority: low` → Nice to have

**Category Labels** (ticket type):
- `category: hardware`, `category: software`, `category: network`, etc.
- `category: long-term` → Special: multi-week projects exempt from SLA
- `category: procurement` → Purchasing requests

**Override Labels** (SLA exemptions):
- `sla-exception` → Special projects outside normal scope
- `complex-issue` → Requires deep investigation
- `waiting-external` → Blocked by external dependencies
- `acknowledged-delay` → Officer-approved extended timeline
- `sub-issue` → Child task of parent issue

### Ticket Categories and SLA Treatment

**Long-term projects** (detected by `[Long-term]` in title OR `category: long-term` label):
- Have flexible deadlines (weeks to months)
- **Completely exempt** from SLA tracking
- Never get `overdue` or `at-risk` labels
- Tracked separately in weekly reports
- Used for infrastructure projects, documentation, system setup
- Detection is automatic based on title prefix - no manual labeling required

**Procurement tickets** (`category: procurement`):
- Use **extended SLA**: 48h response, 6 weeks resolution
- Subject to SLA enforcement (but with realistic timeframes)
- Can get `overdue` or `at-risk` labels if deadlines missed
- Tracked with regular tickets in weekly reports
- Used for equipment, software, service purchases

**Regular tickets**:
- Use **priority-based SLA**: varies by urgency
- Subject to standard SLA enforcement
- Get deadline tracking and automated reminders
- Expected to resolve within hours to days

### Officer Leave System

Managed via `.github/on-leave.yml`:
- When `on_leave: true`, ALL SLA tracking stops system-wide
- New tickets receive automated leave notices
- Deadlines resume automatically when officer returns
- On return, a reminder issue lists all tickets created during leave

### Issue Templates

Issue templates are located in `.github/ISSUE_TEMPLATE/` and provide structured forms for users to submit requests:

**Design Philosophy:**
- **Simple and concise** - Only 3-4 fields per template to maximize completion rates
- **Flexible** - One optional "Additional Details" field for everything else
- **Consistent** - All templates follow the same pattern

**Standard Template Structure:**
1. Priority dropdown (required) - How urgent is this?
2. Main identifier field (required) - What/where is the issue?
3. Problem description (required) - What's wrong or what do you need?
4. Additional details (optional) - Catch-all for extra information

**Available Templates:**
- `general-help.yml` - Questions not covered by other categories
- `hardware-issue.yml` - Computer/equipment problems
- `software-support.yml` - Software installation/configuration/errors
- `network-issue.yml` - Connectivity problems
- `access-request.yml` - Permissions and credentials
- `computing-resources.yml` - HPC/server/cluster issues
- `data-storage.yml` - Storage/backup requests
- `procurement.yml` - Equipment/software purchases
- `long-term-task.yml` - Multi-week projects for officer

**Note:** Templates were intentionally simplified from 10-15 fields down to 3-4 fields to encourage completion. This follows the principle of **conciseness over comprehensiveness** - capture essential info quickly, let users add details if needed.

### Automated Label Management

**Labels Managed by Automation:**

The system automatically manages these labels:
- `overdue` - Added/removed by deadline tracker
- `at-risk` - Added/removed by deadline tracker
- `acknowledged-delay` - Added by sub-issue handler when sub-issues are created
- **Old status labels** - Removed by status label cleanup when new status is added

**Labels Requiring Manual Management:**

The officer must manually add/change:
- Status labels (`status: new` → `status: acknowledged`, etc.)
- Priority labels (`priority: urgent`, `priority: high`, etc.)
- Category labels (`category: hardware`, `category: software`, etc.)
- Override labels (`complex-issue`, `waiting-external`, `sla-exception`)

**Important**: When the officer adds a new status label (e.g., `status: acknowledged`), the status label cleanup workflow automatically removes the old status label (e.g., `status: new`) **without sending email notifications**. This ensures tickets only have one status label at a time.

## Common Development Commands

### Testing Workflows Manually

```bash
# Trigger deadline tracker manually (useful for testing)
gh workflow run deadline-tracker.yml

# Trigger weekly summary manually
gh workflow run weekly-summary.yml

# View workflow runs and their status
gh run list --workflow=deadline-tracker.yml
```

### Running Label Audit & Fix

The label audit workflow helps fix incorrectly applied labels across all issues:

```bash
# Dry run - preview changes without applying them (RECOMMENDED FIRST)
gh workflow run label-audit-fix.yml -f dry_run=true

# Live run - actually apply the fixes
gh workflow run label-audit-fix.yml -f dry_run=false

# View the audit results
gh run list --workflow=label-audit-fix.yml
```

**What it fixes:**
- Removes `overdue`/`at-risk` from long-term projects (title-based or label-based detection)
- Removes `overdue`/`at-risk` from issues with override labels
- Removes duplicate status labels (keeps most advanced status)
- Removes `overdue`/`at-risk` from resolved/closed issues

**Note:** Results are shown in the Actions workflow logs only. No summary issues are created.

**When to run:**
- After adding new workflows to clean up existing issues
- If labels get messed up somehow
- Periodically for general housekeeping
- After changing SLA policies or override labels

### Managing Officer Configuration

```bash
# Update officer information in .github/officer-config.yml
# Then run the update script:
./scripts/update-officer-docs.sh

# This updates README.md, CONTRIBUTING.md, and docs/faq.md
# with the new officer's name, email, and username
```

### Setting Officer Leave Status

Edit `.github/on-leave.yml`:
```yaml
on_leave: true  # or false
leave_start: "2025-01-13"
leave_end: "2025-01-20"
leave_reason: "Annual leave"
urgent_instructions: "For urgent issues, contact Prof. Deng"
```

### Viewing Issues by Status

```bash
# All new tickets needing acknowledgment
gh issue list --label "status: new"

# Overdue tickets
gh issue list --label "overdue"

# Urgent priority tickets
gh issue list --label "priority: urgent"

# Long-term projects
gh issue list --label "category: long-term"
```

## Workflow Modification Guidelines

### Modifying SLA Timeframes

**For priority-based SLA**, edit the `SLA` object in `.github/workflows/deadline-tracker.yml`:
```javascript
const SLA = {
  response: {
    'priority: urgent': 4,    // hours (changed from 2 to 4 for business hours realism)
    'priority: high': 4,
    'priority: medium': 24,
    'priority: low': 48
  },
  resolution: {
    'priority: urgent': 8,
    'priority: high': 72,
    'priority: medium': 120,
    'priority: low': 168
  }
};
```

**For procurement-specific SLA**, edit the `PROCUREMENT_SLA` object:
```javascript
const PROCUREMENT_SLA = {
  response: 48,        // 48 hours (2 days)
  resolution: 1008     // 1008 hours (6 weeks)
};
```

Note: Procurement SLA overrides priority labels. All `category: procurement` tickets use these timeframes regardless of their priority label.

### Adding New Override Labels

When adding new override labels, update three locations:
1. `deadline-tracker.yml` - Add to `overrideLabels` array
2. `weekly-summary.yml` - Add to `overrideLabels` array and emoji map
3. Create the label in GitHub repository settings

### Customizing Weekly Report

The weekly report is generated in `weekly-summary.yml` using string concatenation to avoid YAML parsing issues. All report sections are built programmatically.

## Important Behavioral Notes

### Deadline Calculation

- Deadlines are measured in **calendar hours**, not business hours
- Both response and resolution deadlines are calculated from **ticket creation time**
- Resolution deadline does NOT reset when moving from `acknowledged` to `in-progress`

### Exception Handling

When an override label is applied:
1. Deadline tracker skips the ticket entirely
2. Existing `overdue`/`at-risk` labels are automatically removed
3. Ticket appears in weekly report's "Exceptions & Complex Issues" section
4. Ticket will never be marked overdue while override label is present

### Sub-Issue Workflow

To create sub-issues properly:
1. Create new issue with `sub-issue` label
2. Add `Parent: #123` anywhere in the description
3. Sub-issue handler automatically links them and exempts both from SLA

### Weekly Report Timing

- Runs every Monday at 1 AM UTC (9 AM SGT)
- Analyzes tickets from past 7 days
- Response time only calculated for tickets **closed** during the week
- "Currently Open" is a snapshot at report generation time

## Documentation Structure

- `README.md` - User-facing help desk documentation (keep concise, ~200-300 lines)
- `CONTRIBUTING.md` - Guide for users on writing good tickets (keep brief)
- `docs/officer-guide.md` - Operational guide for the computer officer (day-to-day procedures)
- `docs/deadline-and-reporting-system.md` - Comprehensive technical reference for SLA and reporting systems
- `docs/faq.md` - Frequently asked questions (short answers preferred)
- `.github/officer-config.yml` - Officer contact information (used by workflows)
- `.github/on-leave.yml` - Officer availability status

**Documentation Philosophy:**
- **Concise over comprehensive** - Users prefer short, scannable docs
- **Examples over explanations** - Show, don't tell
- **Remove redundancy** - Don't repeat what's in other files
- **Progressive disclosure** - Basic info first, details in expandable sections or separate files

## Testing Changes

When modifying workflows:
1. Test in a fork first if making significant changes
2. Use `workflow_dispatch` to trigger manually without waiting for schedule
3. Check Actions tab for execution logs
4. Verify label changes and comments on test issues
5. For deadline tracker, temporarily modify SLA times to minutes for faster testing

## System Limitations

- GitHub Actions has a minimum schedule interval of ~5 minutes
- Daily workflows set to 9 AM SGT (1 AM UTC) via cron
- Report and deadline tracker use `per_page: 100` - repositories with 100+ open issues may need pagination
- Leave detection uses simple text parsing of YAML, not a YAML parser
- No email integration - relies on GitHub's built-in email notifications

# GitHub Projects Setup Guide

This guide explains how to set up GitHub Projects for better visual management of help desk tickets.

---

## Why Use GitHub Projects?

GitHub Projects provides Kanban-style boards and table views that make it easier to:
- Visualize ticket flow (New → In Progress → Resolved → Closed)
- Track long-term projects separately with milestone views
- Monitor procurement pipeline stages
- Group and filter tickets by category, priority, or assignee
- See workload at a glance

---

## Recommended Project Boards

### 1. Main Help Desk Board (Kanban)

**Purpose:** Day-to-day ticket management

**Setup Instructions:**

1. Go to repository **Projects** tab → Click **New Project**
2. Choose **Board** template
3. Name it: "Help Desk - Active Tickets"
4. Add these columns:
   - 🆕 **New** (status: new)
   - 👀 **Acknowledged** (status: acknowledged)
   - 🔧 **In Progress** (status: in-progress)
   - ⏳ **Waiting for User** (status: waiting-for-user)
   - ✅ **Resolved** (status: resolved)

**Automation:**
- Set up auto-add: All new issues → "New" column
- Auto-move based on labels:
  - `status: new` → New
  - `status: acknowledged` → Acknowledged
  - `status: in-progress` → In Progress
  - `status: waiting-for-user` → Waiting for User
  - `status: resolved` → Resolved
  - `status: closed` → Archive (auto-close after 7 days)

**Filters to Add:**
- Priority filters: Urgent, High, Medium, Low
- Category filters: Hardware, Software, Network, etc.
- Quick view: "Overdue Tickets" (label: overdue)

---

### 2. Long-Term Projects Board

**Purpose:** Track multi-week/month projects separately from daily tickets

**Setup Instructions:**

1. Create new project → Choose **Table** template
2. Name it: "Long-Term Projects"
3. Add custom fields:
   - **Status** (select): Planning, In Progress, On Hold, Blocked, Completed
   - **Priority** (select): High, Medium, Low
   - **Target Date** (date)
   - **Progress** (number): 0-100%
   - **Phase** (text): e.g., "Phase 2: Implementation"
   - **Blockers** (text): External dependencies
   - **Budget** (text): If applicable

**Filter:** Automatically show issues with `category: long-term` label

**Views to Create:**
- **Active Projects** (Status = In Progress)
- **High Priority** (Priority = High)
- **Blocked Projects** (Status = Blocked or labels include `waiting-external`)
- **Timeline View** (Gantt chart by target date)

---

### 3. Procurement Pipeline Board

**Purpose:** Track purchasing requests through approval and delivery

**Setup Instructions:**

1. Create new project → Choose **Board** template
2. Name it: "Procurement Pipeline"
3. Add these columns:
   - 📋 **Submitted** (new procurement requests)
   - 💰 **Budget Review** (checking funds)
   - ✅ **Approved** (PI approved)
   - 🛒 **Ordering** (placing order)
   - 📦 **Ordered** (waiting for delivery)
   - 🚚 **Delivered** (received, needs setup)
   - ✅ **Complete** (ready for use)

**Filter:** Show only issues with `category: procurement` label

**Custom Fields:**
- **Vendor** (text)
- **Cost** (text)
- **PO Number** (text)
- **Expected Delivery** (date)
- **Budget Source** (text)

---

## Setting Up Automation

### Automatic Issue Assignment to Projects

You can automate project assignment using GitHub Actions. Here's a workflow:

**File:** `.github/workflows/auto-assign-project.yml`

```yaml
name: Auto-assign to Project

on:
  issues:
    types: [opened, labeled]

jobs:
  assign-to-project:
    runs-on: ubuntu-latest
    steps:
      - name: Add to appropriate project
        uses: actions/add-to-project@v0.5.0
        with:
          project-url: https://github.com/orgs/YOUR-ORG/projects/PROJECT-NUMBER
          github-token: ${{ secrets.GITHUB_TOKEN }}
          labeled: category:long-term  # Only add if has this label
```

**Note:** Update `YOUR-ORG` and `PROJECT-NUMBER` with actual values.

---

## Using the Projects

### Daily Workflow with Main Board

1. **Morning:**
   - Check "New" column → Acknowledge tickets → Move to "Acknowledged"
   - Review "Waiting for User" → Ping stale tickets (>3 days)

2. **Throughout Day:**
   - Move cards between columns as you work
   - Add comments directly from project card
   - Drag cards to reorder by priority

3. **End of Day:**
   - Ensure all "In Progress" items have updates
   - Move resolved tickets to "Resolved" (automation may do this)

### Weekly Long-Term Project Review

1. Open "Long-Term Projects" board
2. Update **Progress %** for each project
3. Review **Blocked Projects** view → Escalate blockers
4. Check **Timeline View** → Adjust target dates if needed
5. Add weekly update comments to each active project

### Monthly Procurement Review

1. Review "Procurement Pipeline" board
2. Follow up on stuck items (>14 days in same column)
3. Update delivery dates
4. Close completed purchases

---

## Tips for Effective Use

**✅ Best Practices:**
- Update project cards in real-time as you work
- Use filters to focus on specific work (e.g., "Show only Urgent")
- Review boards at least daily
- Keep custom fields updated (especially dates and percentages)
- Archive closed tickets to keep boards clean

**❌ Common Mistakes:**
- Forgetting to move cards between columns (automate this!)
- Not updating custom fields like Progress %
- Letting "Waiting for User" column get too full
- Mixing short-term tickets with long-term projects (use separate boards!)

---

## Advanced Features

### 1. Issue Templates → Project Auto-Assignment

You can add project auto-assignment to issue templates:

```yaml
# In .github/ISSUE_TEMPLATE/long-term-task.yml
projects:
  - "Long-Term Projects"
```

### 2. Status Updates via Comments

Comment on an issue with keywords to auto-update fields:
- "/progress 50" → Updates Progress to 50%
- "/blocked" → Moves to Blocked status
- "/unblock" → Moves back to In Progress

(Requires custom GitHub Action)

### 3. Views for Reporting

Create custom views for weekly reviews:
- "Tickets by Category" (grouped by category)
- "Overdue This Week" (filtered by overdue label + updated_at)
- "Tickets by User" (grouped by issue creator)

### 4. Charts and Insights

GitHub Projects automatically generates:
- **Burndown charts** (if using iterations)
- **Velocity reports** (tickets closed per week)
- **Cycle time** (time in each column)

Access via: Project → "..." menu → "Insights"

---

## Integration with Existing Workflows

All existing automation (welcome bot, deadline tracker, weekly reports) works seamlessly with Projects:
- Labels automatically update → Cards move between columns
- Reports reference issue numbers → Click to see in project view
- Closed issues → Auto-archived from boards

---

## Troubleshooting

**Q: Issues not appearing in project?**
- Check project filters (label requirements)
- Verify automation is enabled
- Manually add using "+" button if needed

**Q: Cards not moving between columns?**
- Ensure label-based automation is configured
- Check that labels match column filters exactly
- May need to manually configure workflows (see above)

**Q: Can't see custom fields?**
- Switch to "Table" view (custom fields don't show in Board view for all field types)
- Or click individual card to edit fields

---

## Getting Started

**Quick Start (5 minutes):**
1. Create "Help Desk - Active Tickets" board with 5 columns
2. Set up label-based automation for status columns
3. Add all open issues to board
4. Start moving tickets as you work!

**Full Setup (30 minutes):**
1. Create all 3 recommended boards
2. Configure custom fields
3. Set up automation workflows
4. Create filtered views
5. Import existing tickets

---

## Further Reading

- [GitHub Projects Documentation](https://docs.github.com/en/issues/planning-and-tracking-with-projects)
- [Project Automation](https://docs.github.com/en/issues/planning-and-tracking-with-projects/automating-your-project)
- [Custom Fields Guide](https://docs.github.com/en/issues/planning-and-tracking-with-projects/understanding-fields)

---

*Last updated: 2025-10-29*

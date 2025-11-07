# SLA Reference

Quick reference for response times and deadline tracking.

## Response Times

| Priority | Response | Resolution |
|----------|----------|------------|
| Urgent | 4 hours | 8 hours |
| High | 4 hours | 72 hours (3 days) |
| Medium | 24 hours | 120 hours (5 days) |
| Low | 48 hours | 168 hours (7 days) |
| **Procurement** | 48 hours | 1008 hours (6 weeks) |

**Notes:**
- Times are calendar hours, not business hours
- Both deadlines measured from ticket creation time
- Procurement SLA overrides priority labels

## Exemptions

Tickets **exempt** from SLA (never marked overdue/at-risk):
- `[Long-term]` in title or `category: long-term` label
- Override labels: `sla-exception`, `complex-issue`, `waiting-external`, `acknowledged-delay`, `sub-issue`
- During officer leave

## Automated Labels

**`at-risk`** - Added 24 hours before resolution deadline (1 week for procurement)

**`overdue`** - Added when past response or resolution deadline

Both labels auto-removed when:
- Ticket has override label
- Ticket is long-term project
- Ticket resolved/closed
- Officer on leave

## Weekly Report

Auto-generated every Monday at 9 AM SGT, includes:
- New/closed ticket counts
- Average response time
- Open tickets by priority/category
- Overdue tickets
- Long-term projects status

See [example report](https://github.com/deng-group/helpdesk/issues?q=label%3Areport) for format.

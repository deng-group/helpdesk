# Contributing to DENG Group Help Desk

Thank you for using the DENG Group Help Desk! This guide will help you submit effective tickets and contribute to improving our support system.

---

## 📝 Submitting a Ticket

### Before You Submit

**Check these first:**
- [ ] Have you tried restarting? (Seriously - it fixes many issues!)
- [ ] Is your question answered in the [FAQ](docs/faq.md)?
- [ ] Have you searched [existing tickets](../../issues) for similar issues?
- [ ] Is this actually urgent, or can it wait?

### Creating a Good Ticket

A well-written ticket gets faster, better help! Include:

#### ✅ DO Include:
- **Clear title** - Summarize the issue in one line
- **Detailed description** - What's wrong? What were you trying to do?
- **Steps to reproduce** - How can we recreate the problem?
- **Error messages** - Exact errors (screenshots or copy-paste)
- **System information** - OS, software versions, computer name
- **What you've tried** - Shows you've made an effort and saves time
- **Impact on your work** - Helps us prioritize correctly
- **Deadline** (if applicable) - Be honest about urgency

#### ❌ DON'T:
- Write vague titles like "It doesn't work" or "Help!"
- Say "it's broken" without explaining what's broken
- Mark everything as "urgent" (we'll adjust the priority)
- Include passwords or sensitive credentials
- Create duplicate tickets (comment on the existing one instead)
- Demand immediate fixes (Tim-Pook is one person, be patient and respectful)

### Example: Bad vs Good Ticket

**❌ Bad Ticket:**
```
Title: Python broken

Description: Python doesn't work. Need help ASAP.

Priority: Urgent
```

**✅ Good Ticket:**
```
Title: Cannot import pandas on lab workstation-5

Description: I'm trying to run my data analysis script but getting an import error
when I try to import pandas.

Steps to reproduce:
1. SSH into workstation-5
2. Activate conda environment: conda activate myenv
3. Run: python -c "import pandas"

Error message:
ModuleNotFoundError: No module named 'pandas'

System info:
- Computer: workstation-5
- OS: Ubuntu 20.04
- Python version: 3.9.7
- Conda environment: myenv

What I've tried:
- Tried pip install pandas (got permission denied)
- Restarted the terminal session
- Checked that pandas is in requirements.txt

Impact: This is blocking my analysis for the ABC project, but I can work on other
things temporarily.

Priority: Medium
```

The good ticket gives Tim-Pook everything he needs to help you quickly!

---

## 🏷️ Understanding Labels

Your ticket will be labeled to help track its status:

### Status Labels (what stage your ticket is at)

| Label | What It Means | What You Should Do |
|-------|---------------|-------------------|
| `status: new` | Just submitted | Wait for Tim-Pook to acknowledge it |
| `status: acknowledged` | Tim-Pook has seen it | Expect updates soon |
| `status: in-progress` | Tim-Pook is working on it | Check for any questions from Tim-Pook |
| `status: waiting-for-user` | **Need info from you** | **Respond ASAP** to avoid delays |
| `status: resolved` | Fixed, needs your confirmation | **Test it** and confirm it works |
| `status: closed` | All done! | Optionally rate your experience |

### Priority Labels (how urgent it is)

- 🔴 `urgent` - Critical system down, data loss, imminent deadline
- 🟠 `high` - Blocking your work, no workaround available
- 🟡 `medium` - Impacting work but you have a workaround
- 🟢 `low` - Nice to have, not blocking

**Note:** Tim-Pook may adjust the priority if needed. This isn't personal - it's to ensure truly urgent issues get attention first.

### Category Labels

These help organize tickets by type:
- `hardware`, `software`, `network`, `access`, `data`, `compute`, `other`

---

## 💬 Communicating on Tickets

### Responding to Questions

When Tim-Pook asks for more information:
1. Respond as soon as you can
2. Answer all the questions
3. Provide complete information (not partial answers)
4. Use the "Add a comment" button or reply to the email notification

### Providing Updates

If your situation changes:
- **Got more urgent?** Comment: "This just became urgent because [reason]"
- **Found a workaround?** Comment: "FYI I found a workaround: [explanation]"
- **No longer needed?** Comment: "This is no longer needed, please close" or close it yourself

### Testing Resolutions

When Tim-Pook marks your ticket as resolved:
1. Test the fix thoroughly
2. Reply with either:
   - ✅ "Confirmed working, thank you!"
   - ❌ "Still having issues: [describe what's not working]"

Don't just ignore it - Tim-Pook needs to know if the fix worked!

---

## ⏰ Response Time Expectations

| Priority | First Response | Resolution Target |
|----------|---------------|-------------------|
| Urgent | 2 hours | 8 hours |
| High | 4 hours | 3 days |
| Medium | 24 hours | 5 days |
| Low | 48 hours | 7 days |

**These are targets during business hours (Mon-Fri, 9 AM - 5 PM SGT)**

- Complex issues may take longer to resolve
- Response times may be slower during holidays/weekends
- If you don't hear back within the expected timeframe, add a comment to bump the ticket

---

## 🤝 Being a Good Community Member

### Help Others

- Share your solutions with Tim-Pook - if you figured something out, document it!
- Be kind and supportive - we're all learning
- Help colleagues find information in the FAQ before they create tickets

### Improve the System

Help make this help desk better:

- **Found a mistake in the FAQ?** Email Tim-Pook with a correction
- **Have a suggestion?** Create a ticket or email Tim-Pook
- **Solved something tricky?** Suggest adding it to the FAQ
- **Template confusing?** Let us know so we can improve it

### Respect Tim-Pook's Time

Remember:
- Tim-Pook is one person supporting the entire research group
- Be patient - he's juggling multiple tickets
- Be respectful - kindness goes a long way
- Say thank you - it's appreciated!
- Don't abuse "urgent" priority
- Provide complete information upfront to avoid back-and-forth

---

## 🚫 What NOT to Post in Tickets

**For security and privacy:**
- ❌ Passwords or credentials
- ❌ Private API keys or tokens
- ❌ Sensitive personal information
- ❌ Confidential research data (unless in private repo)
- ❌ Credit card numbers or financial info

If you need to share sensitive information, Tim-Pook will provide a secure method.

---

## 🎯 Priority Guidelines

Choose the right priority to help everyone:

### 🔴 Urgent - Use When:
- Server or critical system is completely down
- Data loss or corruption actively happening
- Grant/paper deadline is within 24 hours and you're blocked
- Security incident or breach

### 🟠 High - Use When:
- You cannot do your work at all and have no alternative
- System/software completely non-functional
- Issue affects multiple people
- Time-sensitive research milestones

### 🟡 Medium - Use When:
- Issue impacts your work but you can work around it
- Software works but with bugs or reduced functionality
- Request is needed within a week
- Minor blockers

### 🟢 Low - Use When:
- Feature requests or enhancements
- General questions or how-to help
- Issue doesn't block any work
- Can wait a week or more

**When in doubt, choose medium.** Tim-Pook will adjust if needed.

---

## 📊 Feedback

Help us improve by:

- Rating your experience (👍 reaction on resolved tickets)
- Emailing feedback to Tim-Pook or Prof. Deng
- Suggesting improvements to this system
- Letting us know what works well and what doesn't

---

## 🆘 Getting Help with the Help Desk

If you're having trouble using this help desk system itself:

1. Check the [README](README.md) for basic instructions
2. Email Tim-Pook directly: [tim.pook@nus.edu.sg](mailto:tim.pook@nus.edu.sg)

---

## 📜 Code of Conduct

### Be Respectful
- Treat Tim-Pook with respect and patience
- Be understanding of response times
- Assume good intentions
- No harassment or abuse

### Be Constructive
- Provide useful information in tickets
- Be specific about problems
- Suggest solutions if you have ideas
- Focus on the issue, not personal criticism

### Be Responsible
- Don't abuse the urgent priority
- Respond promptly when Tim-Pook asks questions
- Update tickets with new information
- Keep sensitive information private

---

## Questions?

- 📖 [Read the FAQ](docs/faq.md)
- 🎫 [Create a ticket](../../issues/new/choose)
- 📧 [Email Tim-Pook](mailto:tim.pook@nus.edu.sg)

---

**Thank you for being part of the DENG Group community!** 🎉

---

*Last updated: 2025-10-11*

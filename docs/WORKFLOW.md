# Mobile Coding Workflow Guide

Real-world usage scenarios for coding from your phone using Connection.

---

## Daily Workflow Patterns

### Morning Commute (15 min)

**Scenario**: Quick code review and planning while on the bus/train.

1. **Wake Your PC** (30 seconds)
   - Open WOL app
   - Tap "My PC"
   - Wait for PC to boot

2. **Check What's Running** (2 min)
   - Open Tailscale → Verify PC is online
   - Open Happy-Coder → See if Claude Code session is active
   - Open browser → Check `http://100.x.x.x:3001` if web app is running

3. **Review Yesterday's Work** (10 min)
   - Open vscode.dev → Connect to tunnel
   - Browse recent git commits
   - Read code changes
   - Leave comments in code

4. **Plan Today's Work** (5 min)
   - Open Happy-Coder
   - Tell Claude: "Read the current TODO list and summarize what's left"
   - Tell Claude: "Create a task plan for implementing [feature]"

**Tools Used**: WOL app, Tailscale, Happy-Coder, vscode.dev

---

### Lunch Break Bug Fix (20 min)

**Scenario**: User reported a bug. You want to fix it quickly.

1. **Verify PC is Awake** (10 seconds)
   - Open Tailscale → Check green dot next to PC

2. **Investigate the Bug** (5 min)
   - Open Happy-Coder
   - Send: "A user reported that [bug description]. Find the cause."
   - Claude searches codebase and identifies the issue

3. **Review Claude's Findings** (2 min)
   - Read Claude's analysis
   - Look at the file/line numbers mentioned
   - Tap "Show me the code" in Happy-Coder

4. **Fix the Bug** (10 min)
   - Send: "Fix this bug and add a test for it"
   - Claude creates a PR with fix + test
   - Review the changes in Happy-Coder's diff view
   - Tap "Approve" to commit

5. **Verify Fix** (3 min)
   - Open browser → `http://100.x.x.x:3001`
   - Test the fixed functionality
   - Merge PR from GitHub mobile app

**Tools Used**: Tailscale, Happy-Coder, Browser

---

### Evening Code Session (1-2 hours)

**Scenario**: Comfortable at home, coding on phone/tablet while relaxing.

1. **Full Development Environment** (2 min)
   - Connect Bluetooth keyboard to phone (optional but recommended)
   - Open vscode.dev in browser
   - Connect to remote tunnel
   - Open terminal in VS Code

2. **Implement New Feature** (60 min)
   - **Method A: Claude Code via Happy-Coder**
     - Send high-level instructions to Claude
     - Review changes before applying
     - Approve/reject each change

   - **Method B: Manual Coding**
     - Edit files directly in vscode.dev
     - Use terminal for git commands
     - Run tests with `npm test`

3. **Monitor App/API** (ongoing)
   - Keep browser tab open: `http://100.x.x.x:4000/health`
   - Check logs in VS Code terminal
   - Use Happy-Coder to ask: "Show me the latest logs"

4. **Test Changes** (20 min)
   - Run dev server: `npm run dev` (in VS Code terminal)
   - Open `http://100.x.x.x:3001` in another tab
   - Test new feature on phone
   - Check responsive design

5. **Commit and Push** (5 min)
   - In VS Code terminal:
     ```bash
     git add .
     git commit -m "feat: Add new feature"
     git push
     ```
   - Or ask Claude: "Commit these changes with a good message"

**Tools Used**: vscode.dev, Happy-Coder, Browser, Bluetooth keyboard

---

### Weekend: RunPod GPU Video Generation

**Scenario**: Generate videos using your RunPod GPU from your phone.

1. **Start GPU Pod** (2 min)
   - Open browser → `http://100.x.x.x:3001/gpu`
   - Tap "Start GPU Pod"
   - Wait for status: "Pod Ready"

2. **Generate Video via Web UI** (5 min)
   - Stay on web app
   - Enter video prompt
   - Select template
   - Tap "Generate Video"

3. **Monitor Progress** (ongoing)
   - Refresh GPU status page
   - See: "Generating... 45% complete"
   - Estimated time remaining shows

4. **Alternative: Use Happy-Coder** (if web UI not available)
   - Send to Claude: "Start a GPU pod and generate a video with prompt: [your prompt]"
   - Claude uses your API to start pod and queue job
   - Ask: "What's the status?" to check progress

5. **Download Result** (2 min)
   - When complete, tap "Download" on web UI
   - Video saves to phone
   - Stop GPU pod to save credits

**Tools Used**: Browser (web app), Happy-Coder (optional)

---

## Workflow by Task Type

### Code Review

**Best Tool**: vscode.dev + Happy-Coder

1. Open PR on GitHub mobile app
2. Open vscode.dev → checkout PR branch
3. Ask Claude: "Review the changes in this PR for bugs"
4. Read Claude's analysis
5. Leave comments in GitHub app
6. Approve or request changes

**Time**: 10-15 minutes per PR

---

### Writing Documentation

**Best Tool**: vscode.dev

1. Open vscode.dev → Navigate to docs folder
2. Edit markdown files directly
3. Use phone's voice dictation for faster typing
4. Preview markdown with VS Code's preview pane
5. Commit and push

**Time**: 20-30 minutes

---

### Debugging Production Issue

**Best Tool**: Happy-Coder + vscode.dev

1. **Investigate**
   - Ask Claude: "Check the logs for errors in the last hour"
   - Claude searches log files

2. **Identify Root Cause**
   - Ask: "What's causing [error message]?"
   - Claude traces through code

3. **Hot Fix**
   - Ask: "Create a hot fix for this"
   - Review changes carefully
   - Test on staging via Tailscale connection

4. **Deploy**
   - Push to production branch
   - Monitor logs: Ask "Show me the latest production logs"

**Time**: 30-60 minutes

---

### Refactoring

**Best Tool**: Happy-Coder (Claude excels at refactoring)

1. Ask: "Refactor the authentication module to use TypeScript interfaces"
2. Claude creates refactoring plan
3. Review each step
4. Approve changes incrementally
5. Run tests after each step

**Time**: 1-3 hours (spread across multiple sessions)

---

### Adding Tests

**Best Tool**: Happy-Coder + vscode.dev

1. Ask: "Add unit tests for the payment module with 80% coverage"
2. Claude generates test files
3. Review test cases in vscode.dev
4. Run tests: `npm test` in VS Code terminal
5. Fix any failures by asking Claude

**Time**: 30-60 minutes

---

## Power User Tips

### 1. Create Shortcuts on Phone Home Screen

**iOS (Safari):**
1. Open vscode.dev → Connect to tunnel
2. Tap Share → "Add to Home Screen"
3. Name it "VS Code"
4. Now it opens like a native app

**Android (Chrome):**
1. Open vscode.dev → Three dots menu
2. Tap "Add to Home Screen"

Repeat for:
- Happy-Coder (https://happy.engineering)
- Your web app (http://100.x.x.x:3001)

### 2. Use Voice Typing

**For longer prompts to Claude:**
1. Open Happy-Coder
2. Tap microphone icon in keyboard
3. Speak your instructions
4. Much faster than typing on phone

### 3. Split Screen on iPad/Tablet

- Left side: vscode.dev
- Right side: Happy-Coder
- See code and AI suggestions simultaneously

### 4. Bluetooth Keyboard Shortcuts

When using Bluetooth keyboard with vscode.dev:
- `Cmd/Ctrl + P` - Quick file open
- `Cmd/Ctrl + Shift + F` - Search across files
- `Cmd/Ctrl + ~` - Toggle terminal
- `Cmd/Ctrl + B` - Toggle sidebar

### 5. Background Keep-Alive

Keep Happy-Coder session alive on PC:

**Windows:**
```powershell
# Create scheduled task that restarts happy-coder on boot
schtasks /create /tn "HappyCoder" /tr "happy-coder start" /sc onstart
```

**Linux/Mac:**
```bash
# Add to crontab
@reboot cd ~ && happy-coder start
```

### 6. Custom Claude Code Shortcuts

Create `.claude/shortcuts.json`:
```json
{
  "review": "Review this code for bugs and suggest improvements",
  "test": "Add unit tests for this file",
  "doc": "Add JSDoc comments to this file",
  "fix": "Fix the linting errors in this file"
}
```

Then in Happy-Coder: Type `/review` instead of full prompt.

---

## Time-Saving Patterns

### Pattern 1: Morning Batch Processing

**Setup once, repeat daily:**
1. Create a Claude prompt: "Morning routine: Pull latest changes, check for merge conflicts, run tests, summarize any issues"
2. Save as `/morning` shortcut
3. Every morning: Open Happy-Coder → Send `/morning`
4. Get full status report in 30 seconds

### Pattern 2: Commit Message Generation

Instead of writing commit messages:
1. Stage changes in vscode.dev terminal: `git add .`
2. Ask Claude: "Generate a conventional commit message for these changes"
3. Copy and commit: `git commit -m "[generated message]"`

### Pattern 3: Quick Edits Without Opening Editor

For one-line fixes:
1. Ask Claude: "Change line 42 in auth.ts from X to Y"
2. Claude makes the change
3. Verify in Happy-Coder diff view
4. Approve and commit

### Pattern 4: Multi-File Refactoring

For changes across many files:
1. Ask: "Rename function getUserData to fetchUserData across all files"
2. Claude searches and replaces in all files
3. Review changes (Happy-Coder shows multi-file diff)
4. Approve all at once

---

## When to Use Each Tool

| Task | Best Tool | Why |
|------|-----------|-----|
| Quick code review | Happy-Coder | Fast, AI-assisted analysis |
| Writing new code | vscode.dev + keyboard | Full editor experience |
| Debugging | Happy-Coder | AI can trace issues faster |
| File browsing | vscode.dev | Better file tree visualization |
| Running commands | vscode.dev terminal | Full terminal access |
| Committing code | Happy-Coder | Auto-generates good commit messages |
| Refactoring | Happy-Coder | Claude excels at systematic changes |
| Testing web app | Browser + Tailscale | Direct access to localhost |
| Starting GPU jobs | Web app or Happy-Coder | Both work well |

---

## Realistic Time Expectations

**What's Fast on Phone (5-10 min)**:
- Code review
- Quick bug fix
- Commit and push
- Check logs
- Restart services
- Update documentation

**What Takes Medium Time (20-30 min)**:
- Implement small feature
- Add tests
- Debug production issue
- Refactor a single file

**What Takes Longer (1-2 hours)**:
- Implement complex feature
- Large refactoring
- Performance optimization
- Setting up new infrastructure

**Not Recommended on Phone**:
- Initial project setup
- Large dependency updates
- Complex merge conflicts
- Video editing (if part of your workflow)

---

## Emergency Scenarios

### Scenario 1: Production is Down

1. Open Happy-Coder immediately
2. Ask: "Check production logs for errors in last 30 minutes"
3. Ask: "What's the fastest way to roll back?"
4. Execute rollback command via vscode.dev terminal
5. Monitor recovery

**Time to resolve**: 5-15 minutes

### Scenario 2: Critical Security Patch Needed

1. Open vscode.dev → Create hotfix branch
2. Ask Claude: "Apply security patch for [CVE]"
3. Review changes carefully
4. Run tests in terminal
5. Merge and deploy immediately

**Time to patch**: 10-20 minutes

### Scenario 3: Client Needs Feature ASAP

1. Ask Claude: "What's the quickest way to implement [feature]?"
2. Choose the suggested approach
3. Tell Claude: "Implement this now"
4. Review and approve changes
5. Deploy to staging for client review

**Time to MVP**: 30-60 minutes

---

## Workflow Checklist

**Before Coding Session**:
- [ ] PC is awake (or use WOL app)
- [ ] Tailscale connected on phone
- [ ] Happy-Coder session active
- [ ] Bluetooth keyboard paired (if using one)
- [ ] Battery charged or plugged in

**After Coding Session**:
- [ ] All changes committed and pushed
- [ ] Tests passing
- [ ] GPU pod stopped (if used)
- [ ] Happy-Coder session saved
- [ ] PC can sleep (or leave running)

---

## Next Steps

- Read **TROUBLESHOOTING.md** for common issues
- Read **SECURITY.md** for secure remote access best practices
- Customize your workflow based on your needs

Happy mobile coding!

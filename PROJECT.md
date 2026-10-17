# LOCKED IN — Habit tracker for iPhone

## Product description
Locked In is a habit tracker for you and a small group of friends. It replaces a habit spreadsheet with an app where checking off a habit takes one tap and progress is always visible. You set the habits you want to build, each with a weekly goal (for example "Gym, 4 days a week"). Every day you tick off what you did. The app turns those ticks into clear numbers: today's score, this week's score, and how each habit is doing against its goal. Habits belong to weeks. You can add or drop habits from one week to the next, and past weeks keep the set they had. This keeps your history and percentages honest. There are three time views, Day, Week and Month, which sit in the same place in the header. Insights shows trends and statistics. Crew shows your friends' progress on the habits they choose to share.
The look is dark and motivational ("Dream it. Build it. Lock it in."): a black background, one accent color the user picks, big bold numbers, and iOS 26 Liquid Glass for navigation. It is built for iPhone first, with layouts for iPad and iPhone Duo.

## Key concepts
- Habit: a name, an icon, a weekly goal (1–7 days), the days it shows on, and whether it's shared with the crew. (UPDATED) The icon is either one of 16 built-in icons or any SF Symbol the user picks.
- Check-in: one habit marked done on one day.
-Day score: check-ins today ÷ habits active today.
- Week score: check-ins so far ÷ possible check-ins so far this week.
- Goal hit: a habit's check-ins this week ≥ its weekly goal.
- Chain: consecutive days with at least one check-in.
- Week-scoped habits: each week has its own habit list. A habit added "next week" doesn't show up in the current week.

## USER STORY 1 — Core tracking (Row 1: build first)
As a user, I want to see today's habits, tick them off with one tap, see my week at a glance, add new habits and check my weekly stats, so I can stay consistent and see my progress without any spreadsheet work.
Out of scope for this story: the Month view, month and year insights, Crew, Profile and Settings. They come in later stories.

### EPIC 1.0 — App shell & data foundation (needed by every screen)
- T1.0.1 Set up the data model: Habit (id, name, icon, weeklyGoal, activeDays, shared,startWeek, endWeek) and CheckIn (habitId, date).
- T1.0.2 Week-scoped habit sets: given a week, return the habits active in it. Adding a habit for "this week" or "next week" sets its start week.
- T1.0.3 Local storage for habits and check-ins (works offline; sync comes later with Crew).
- T1.0.4 Score calculations: day score, week score, per-day %, per-habit count vs goal, goal hit, chain length.
- T1.0.5 Design tokens in code: colors, fonts (Big Shoulders, Geist, Geist Mono), spacing, corner radii, the materials (card, glass, the active-tab highlight, accent).
- T1.0.6 Accent color as a single app-wide setting (default Volt #D4FF3F), read by every component.
- T1.0.7 Floating glass tab bar: Track · Insights · Crew. The active tab gets the highlight and the accent color. Content scrolls underneath.
- T1.0.8 Round accent action button next to the tab bar: "+" opens New habit on Track screens.
- T1.0.9 Header component: date label and title on the left, the Day / Week / Month switch on the right. Fixed 62 pt height; the title text changes with the view and its position never moves.
- T1.0.10 Loading skeleton component: shimmer only on values that come from data, at the exact size of the value. Titles, labels, card outlines and glass stay solid.
- T1.0.11 (NEW) The habit icon field stores two kinds of value: a built-in icon id, or an SF Symbol name (e.g. "figure.run"). One shared icon view draws either kind at any size. If a symbol name doesn't exist on the device's iOS version, it falls back to a default icon.

### EPIC 1.1 — Today (Day view)
Shows today's habits, the day score, and lets you tick habits off.
- T1.1.1 Header: "FRI · 16 OCT" label, TODAY title, switch with Day selected.
- T1.1.2 Day strip: 7 day cells (Mon–Sun) with weekday and date. Past days show a small progress tick, today is a white pill, future days are an outline.
- T1.1.3 Tapping a past day in the strip opens that day (read and edit its check-ins).
- T1.1.4 Day score card: big done/total count (e.g. 4/7), a progress ring with %, and the chain line ("16-day chain · don't break it").
- T1.1.5 Motto line plus an "X TO GO" counter that turns into "PERFECT DAY" at 100%.
- T1.1.6 Habit row: icon tile, name, "x of goal this week" meta line, check circle.
- T1.1.7 Tap anywhere on a row to toggle done: accent fill, light haptic, 180 ms animation. Tapping again undoes it.
- T1.1.8 Live updates: toggling a habit updates the count, ring, %, the day's tick in the strip and the meta line straight away.
- T1.1.9 Habit list scrolls under the tab bar (112 pt bottom padding so the last row is never hidden).
- T1.1.10 Empty state for a day with no habits, with a button to New habit.
- T1.1.11 Loading state (skeleton): day progress ticks, score number, chain line, ring %, habit icons, names and checks shimmer.
- T1.1.12 (NEW) Habit row icon tile shows custom SF Symbol icons through the shared icon view (T1.0.11), with the same size, color and accent-when-done behaviour as built-in icons.

#### EPIC 1.2 — Week view
Shows the whole week as a grid and lets you fix past days.
- T1.2.1 Header: "WK 42 · THIS WEEK" label, "OCT 12–18" title, switch with Week selected (same spot as Today).
- T1.2.2 Day strip, week variant: 7 cells with weekday, date and that day's % (100% in accent). Today is a white pill; future days show "—".
- T1.2.3 Week score card: big week % in accent, "25 of 35 check-ins so far", progress bar, "X DAYS LEFT · FINISH STRONG".
- T1.2.4 Week habit card: icon, name, count vs goal (e.g. 4/5), and a GOAL HIT chip once the goal is reached.
- T1.2.5 7 day cells per habit with states: done (accent + check), missed (grey), today not yet done (outline), future (dashed, locked).
- T1.2.6 Tapping a past or today cell toggles it. Future cells can't be tapped.
- T1.2.7 Live updates: a toggle updates the habit count, GOAL HIT, the day %, the week score and the bar.
- T1.2.8 Only show habits that belong to this week (uses T1.0.2).
- T1.2.9 Dashed "Add a habit to this week" button at the end of the list, which opens New habit with Starts set to "This week".
- T1.2.10 Swipe left/right (or tap the title) to change week.
- T1.2.11 Loading state: day %, score number, line, footer, habit names, counts and all cells shimmer.
- T1.2.12 (NEW) Week habit card icon also uses the shared icon view, so custom SF Symbols show here too.

### EPIC 1.3 — New habit
Create a habit with a weekly goal.
- T1.3.1 Screen shell: glass close button, "NEW HABIT" label, "What are you building?" title.
- T1.3.2 Name text field (required; the save button is disabled while it's empty).
- T1.3.3 (UPDATED) Icon picker: one row of 56 pt tiles that scrolls sideways and runs to the screen edges. Order: 16 built-in icons → the custom SF Symbol tile (if one was picked, marked "SF") → a dashed "+" tile, always last. Single choice; the selected tile gets an accent outline, and its name shows to the right of the ICON label. Helper text: "Swipe for all 16 built-in icons. Tap + to use any SF Symbol."
- T1.3.4 Weekly goal stepper, 1–7, showing "days / week".
- T1.3.5 "Show on" day pills (Mon–Sun, multi-select, all on by default).
- T1.3.6 Starts picker: "This week (from Mon 12 Oct)" or "Next week (from Mon 19 Oct)", with the helper text about per-week habits.
- T1.3.7 "Visible to crew" switch (on by default; stored now, used once Crew exists).
- T1.3.8 "Lock it in" primary button: validates, saves the habit with its start week, closes the screen, and the new habit appears in Today and Week.
- T1.3.9 No loading state needed (it's a local form).
- T1.3.10 (NEW) The "+" tile opens the "Any symbol" sheet: a glass bottom sheet with a grabber, title, close button, search field, category chips (All, Health, Fitness, Mind, Food, Objects), a 5-column grid of symbols with their names underneath, and a "Use '<symbol name>'" button.
- T1.3.11 (NEW) Search filters symbols by name and keywords as you type. Category chips filter the grid. The current custom symbol is pre-selected when the sheet opens.
- T1.3.12 (NEW) Tapping "Use" closes the sheet. The symbol gets its own tile just before "+", it becomes the selected icon, and the row scrolls so it's visible. Tapping "+" again replaces it; tapping a built-in icon switches back without losing the custom tile.
- T1.3.13 (NEW) Symbol catalogue: ship a curated list of SF Symbol names with search keywords and categories (habit-friendly symbols first), and check each name exists on the device's iOS version before showing it.
- T1.3.14 (NEW) Save: "Lock it in" stores either the built-in icon id or the SF Symbol name (T1.0.11).

### EPIC 1.4 — Insights · Week
Statistics for the current week.
- T1.4.1 Week / Month / Year switch at the top (Week selected; Month and Year come in later stories).
- T1.4.2 Hero block: "WEEK 42 · OCT 12 – 18" label, a big week %, and a change-vs-last-week chip (e.g. "+6 PTS VS WK 41").
- T1.4.3 "25 of 35 check-ins so far" line under the hero.
- T1.4.4 Daily score chart: a smooth line and area of each day's %, gridlines at 0/50/100, today as a white dot with its value, 100% days as filled accent dots, future days dashed, day letters underneath.
- T1.4.5 Stat tiles (3 in a row): Best day (e.g. WED, Perfect 7/7), Weak spot (e.g. THU, 3/7 done), Goals hit (e.g. 2/7, 2 days left).
- T1.4.6 Progress vs weekly goal list: one row per habit with name, done/goal, %, and a bar (accent when the goal is hit, grey otherwise), sorted best first.
- T1.4.7 All numbers come from the same calculations as Today and Week (T1.0.4), so they always match.
- T1.4.8 Loading state: hero number, chip, line, chart area, tile values and all progress rows shimmer. The chart gridlines and day letters stay visible.

### Definition of done for User Story 1
- [ ] You can create a habit, see it on Today, tick it off, see it reflected in Week and Insights, and everything still matches after restarting the app.Habits added for next week don't appear in the current week.
- [ ] Every screen has its loading state, works with any of the 4 accent colors, and has 44 pt minimum touch targets.
- [ ] (NEW) A habit can use any SF Symbol as its icon, picked through the "+" tile, and that icon shows correctly on New habit, Today and Week, including after restarting the app.

Two tasks go beyond what the Row 1 screens show: T1.1.3 (opening a past day from the strip) and T1.2.10 (changing week). They're there because the views imply them. Delete them if you'd rather keep v1 smaller.
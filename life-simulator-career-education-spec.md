# Career & Education System — Detailed Spec

> **Date:** July 2, 2026
> **Part of:** AI Life Simulator
> **Supplement to:** [`life-simulator-spec.md`](./life-simulator-spec.md)

---

## 1. Core Design Philosophy

- **Birth-to-death continuum:** Every simulation begins at age ~3 in Kindergarten and progresses through life chronologically.
- **Full multi-class:** Player can actively pursue 2–3 career paths simultaneously (e.g. running a business while climbing politics, with crime on the side).
- **Deeply interconnected:** Crime feeds business, money buys politics, fame opens doors. All paths constantly affect each other.
- **AI-decided prerequisites:** Education requirements for careers are determined by the AI based on world logic, not hardcoded rules.
- **Strict prerequisites enforced by AI:** Many careers realistically require specific education. No degree? You can't be a doctor. AI enforces this narratively.
- **Organic career switching:** Your past follows you. Former crime boss running for office? Your criminal record will come up.
- **Multiple end goals per path:** Each path has 3–5 possible outcomes (success, neutral, failure, death, retirement, etc.).
- **Multi-generational:** When the player dies, they can continue as a descendant with inherited assets via a detailed will system.
- **Configurable time flow:** Player can adjust time speed per life stage. Education can be fast-forwarded if desired.

---

## 2. Life Stages Overview

| Stage | Ages | Duration (in-game) | Type |
|-------|------|-------------------|------|
| Kindergarten | 3–5 | 3 years | Education (full sim) |
| Elementary School | 6–10 | 5 years | Education (full sim) |
| Middle School | 11–13 | 3 years | Education (full sim) |
| High School | 14–18 | 4 years | Education (full sim) |
| University | 18–22+ | 4+ years | Education (full campus sim) |
| Career / Adulthood | 18+ | Variable | Career paths begin |
| Retirement | 65+ | Variable | Late life |
| Death | Variable | — | End → multi-generational |

**Time flow:** Time flows via the hybrid real-time + manual advance system. Player can configure time speed per life stage in settings.

**Aging:** Time flows normally (real-time + fast-forward). When the calendar says it's your birthday, you age up. School progresses by time passed.

---

## 3. Education System (Detailed)

### 3.1 Kindergarten (Ages 3–5)

**Unique features:**
- Playtime (outdoor, indoor, structured, free)
- Snack time / naptime schedule
- Making first friends (NPC children)
- Learning basics: ABCs, 123s, colors, shapes
- Art time (drawing, crafts, show-and-tell)
- Getting scolded / behaving
- First crush (cute childlike)
- Teacher interactions
- Parent drop-off/pickup dynamics

**Key NPCs:** Teachers, classmates (first friends, first bullies), parents

**Stat impacts:** Low-level Intelligence gain, Social skill development, trait formation

**Transition:** Graduation ceremony → Elementary School at age 6

### 3.2 Elementary School (Ages 6–10)

**Unique features:**
- Core subjects: Math, Reading, Science, Social Studies
- Homework system (completing vs neglecting)
- Recess dynamics (playground politics)
- After-school clubs (sports, art, music, chess)
- Field trips (museum, zoo, farm)
- Report cards (grades affect parent reactions)
- Parent-teacher nights
- Making real friendships (vs fleeting kindergarten friends)
- Bullies emerge
- First responsibilities (chores at home)

**Key NPCs:** Homeroom teacher, subject teachers, classmates, bullies, best friends, parents, siblings

**Stat impacts:** Steady Intelligence growth, Social development, Physical through recess/sports

### 3.3 Middle School (Ages 11–13)

**Unique features:**
- Social hierarchy system (popularity tiers)
- Cliques form (jocks, nerds, artsy, popular, outcasts)
- Changing classes (different teachers per subject)
- Lockers and hall dynamics
- Electives (art, music, woodshop, computers)
- Puberty events (growth spurts, voice changes, awkward moments)
- First romantic relationships (crushes, asking someone out, first kiss)
- Group projects (cooperation dynamics)
- Academic tracking (honors vs regular classes)
- Bullying escalates (can become serious)
- Cell phone / social media dynamics

**Key NPCs:** Multiple subject teachers, guidance counselor, principal, clique leaders, romantic interests, rivals

**Stat impacts:** Intelligence grows, Social heavily impacted by hierarchy position, Physical affected by sports/PE, Stress from social pressure

### 3.4 High School (Ages 14–18)

**Unique features:**
- Clubs system: Debate, Drama, Yearbook, Chess, Science Olympiad, etc.
- Sports teams: Tryouts, games, team dynamics
- Homecoming and School Spirit events
- Prom (date, dress, after-party)
- SAT/ACT prep and exams
- College applications process
- Part-time jobs (fast food, retail, tutoring)
- Driving lessons and license
- Student council / class president elections
- Teachers as distinct personalities
- Senior pranks, graduation
- Vaping/smoking/drinking choices
- Dating system (relationships can be serious)

**Key NPCs:** Teachers, principal, coach, classmates, best friends, romantic partners, rivals, mentors

**Stat impacts:** All stats active. Intelligence from academics, Social from extracurriculars, Fitness from sports, Money from part-time jobs

**College prep pathway:**
- PSAT → SAT/ACT
- College research and visits
- Application essays
- Letters of recommendation
- Scholarship applications
- Acceptance/rejection letters

### 3.5 University (Ages 18–22+)

#### Academic System
- **Choose a Major** — defines your course load and unlocks career paths
- **Minors and double majors** possible
- **Semester system** with 4–6 classes per semester
- **GPA tracking** (0.0–4.0 scale)
- **Class attendance** — affects grades
- **Assignments and exams** — midterms, finals, papers, projects
- **Professor relationships** — office hours, letters of rec
- **Academic probation** if GPA drops too low

#### Campus Life
- **Dorm living** — roommate dynamics, RA, dorm events
- **Fraternities / Sororities** — rush, pledging, hazing (optional), brotherhood/sisterhood
- **Parties** — social events, drinking, consequences
- **Clubs and organizations** — student government, clubs, honor societies
- **Sports** — intramural, varsity tryouts, games
- **Dating scene** — relationships can be casual or serious
- **Roommate drama** — conflicts, resolutions, moving

#### Career Building
- **Internships** — apply, interview, work summers
- **Part-time jobs** — on-campus or off-campus
- **Career fairs** — networking with recruiters
- **Research assistant** positions with professors
- **Study abroad** — semester in another country
- **Portfolio building** — for creative majors

**Key NPCs:** Professors, advisor, roommate(s), classmates, club members, frat/sorority brothers/sisters, romantic partners, career counselor, dean

**Stat impacts:** Heavy Intelligence growth, Social from campus life, skills development per major

**Graduation:** Commencement ceremony, degree awarded, alumni network unlocked

---

## 4. Career Paths

### 4.1 Crime Path

**Scope:** Full spectrum — street crime, organized crime, AND white collar crime. Player chooses their flavor.

**Unique mechanics:**
- **Heat Meter (core):** Every crime increases police attention. Heat decays slowly. High heat = police raids, wiretaps, investigation. Core mechanic throughout.
- **Crew System (full):** Recruit NPCs for your crew (hacker, getaway driver, muscle, fixer, fence). Each has loyalty and skill ratings. They can be arrested, betray you, or die. Manage from a crew screen.
- **Criminal Specializations:** Theft, fraud, drug trade, smuggling, extortion, hacking, money laundering, armed robbery, contract killing
- **Gang/Faction affiliations:** Join or lead organized groups. Territory control, wars, alliances.
- **Fences and black markets:** Selling stolen goods, finding buyers
- **Money laundering:** Legitimizing dirty money through businesses

**Milestones:**
- First crime (petty theft / small scam)
- Join a crew / attract police attention
- First heist / major score
- Build a reputation (street cred)
- Become a made man / crew leader
- Run a territory / operation
- Rival gang war / turf conflict
- Go legit (launder money, buy businesses)
- Become kingpin / untouchable
- Get whacked / arrested / retire

**Sub-reputations:**
- **Street Cred** (0–100) — how feared/respected in the underworld
- **Heat Level** (0–100) — police investigation intensity
- **Crew Loyalty** (0–100) — how loyal your crew is to you

**Endgame outcomes:**
- Kingpin: Run the entire underworld
- Untouchable: Retired with fortune, never caught
- Arrested: Life in prison / death row
- Killed: Killed by rivals or in a job gone wrong
- Reformed: Left crime behind, started fresh

### 4.2 Prison System

**Dual entry:** Can be BOTH a consequence (caught while on Crime path) AND a choice (start a new game in prison with a generated backstory).

**Starting scenarios for Prison:**
- Wrongful conviction
- Undercover cop
- Framed by rival
- Born into crime family, grew up visiting
- Voluntary entry (witness protection, hiding from mob)

**Connection to outside:** Limited connection — occasional visits, phone calls, letters. You get news but can't directly act on it. Some things continue (NPC relationships decay slower) but big stuff pauses (your business is in 'maintenance mode').

**Prison ecosystem (full):**
- **Prison jobs:** Laundry, kitchen, library, gardening, manufacturing
- **Gym/Fitness:** Work out, gain strength (protective)
- **Contraband economy:** Smuggle in phones, drugs, weapons
- **Gang politics:** Join or avoid prison gangs. Territory inside.
- **Rivalries:** Conflicts with other inmates, guards
- **Fights:** Combat events
- **Education programs:** GED, college courses, vocational training
- **Solitary confinement:** Punishment for infractions
- **Parole hearings:** Apply for early release based on behavior
- **Phone calls:** Limited contact with outside
- **Visitors:** Family, lawyers, associates
- **Rehabilitation:** Counseling, good behavior to reduce sentence

**Prison milestones:**
- First day (orientation, finding your cell)
- Make an ally / enemy
- Join a prison gang / stay solo
- First fight / defend yourself
- Get a prison job
- First contraband acquisition
- Parole hearing
- Escape attempt (risky)
- Release day

**Sub-reputations (prison):**
- **Inmate Respect** (0–100) — how other prisoners treat you
- **Guard Rapport** (0–100) — how guards perceive you (trusted vs troublemaker)

### 4.3 Politics Path

**Scope:** Full political career — Local (city council, mayor) → State (governor, state senate) → National (Congress, Senate, President).

**Unique mechanics:**
- **Scandal System (central):** Secrets from your past (or current) can be exposed by rivals. Opposition research, leaks, media exposes. Managing scandals is a core part of politics.
- **Policy/Agenda System (full):** Choose stances on taxes, healthcare, education, crime, foreign policy, environment, etc. Stances affect voter approval by demographic, donor support, and NPC reactions.
- **Election System:** Primaries, general elections, debates, polling, fundraising, campaign events
- **Fundraising:** Donors, PACs, small-dollar donations. Money for ads, staff, events.
- **Media Relations:** Press conferences, interviews, scandals, spin
- **Staffing:** Campaign manager, chief of staff, speechwriters, advisors
- **Legislative System:** Propose bills, committee hearings, voting, lobbying, compromise
- **Party Politics:** Party leadership, endorsements, party-line votes

**Milestones:**
- First campaign (school board / city council)
- Win first election
- Pass first bill / resolution
- Survive first scandal
- Rise in party ranks
- Higher office campaign
- Win state-level office
- National campaign
- Cabinet position / party leadership
- Presidential campaign
- Win presidency / lose / retire
- Legacy assessment

**Sub-reputations:**
- **Voter Approval** (0–100) — public opinion, affects re-election
- **Party Standing** (0–100) — how party leaders see you, affects endorsements
- **Media Favorability** (0–100) — press coverage tone

**Endgame outcomes:**
- President: Highest office achieved
- Party Leader: Led party to power
- Disgraced: Resigned in scandal
- Retired Statesman: Left office with honor
- Assassinated: Killed by extremist / rival
- Lost: Defeated in election, left politics

### 4.4 Business Path

**Scope:** Start anywhere, grow anywhere. Lemonade stand → small shop → chain → corporation. The type of business affects everything.

**Unique mechanics:**
- **Full Management Sim:** Hire/fire staff, manage inventory, set prices, handle suppliers, customer satisfaction — all tracked with numbers
- **Full Financials tracked:**
  - P&L (Profit & Loss) statement
  - Balance sheet (assets, liabilities, equity)
  - Burn rate / cash flow
  - Unit economics (cost per customer, lifetime value)
  - Growth metrics (month-over-month, year-over-year)
- **Business Types (AI-generated):** Retail, Food & Beverage, Tech/SaaS, Services, Manufacturing, Hospitality, Construction, E-commerce
- **Location selection:** Choose where to open (affects rent, foot traffic, demographics)
- **Employees:** Hire, train, promote, fire. Morale, productivity, loyalty tracked.
- **Marketing:** Ads, social media, word-of-mouth, promotions
- **Competitors:** Other businesses compete for customers, price wars
- **Expansion:** New locations, new product lines, franchising
- **Funding:** Bootstrapping, loans, investors, venture capital (can transition to Tycoon path)

**Milestones:**
- First sale
- Hire first employee
- First profitable month
- Break even on startup costs
- Open second location
- Major client win / contract
- Survive first crisis (lawsuit, bad press, supply chain)
- Expansion round
- Franchise / chain growth
- Acquisition offer
- IPO (Initial Public Offering)
- Sell the company / retire

**Sub-reputations:**
- **Industry Reputation** (0–100) — how peers see you
- **Customer Trust** (0–100) — brand loyalty, reviews
- **Employee Morale** (0–100) — staff satisfaction

**Endgame outcomes:**
- IPO: Took company public, wealth explosion
- Acquired: Bought out by larger company
- Empire: Built a business conglomerate
- Bankrupt: Business failed, lost everything
- Sold: Profitable exit, retired comfortably

### 4.5 Tycoon Path

**Scope:** Empire building through investments, real estate, startups, and financial markets. Distinct from Business path (which focuses on running a specific company).

**Unique mechanics:**
- **Portfolio Screen (dedicated UI):** See all assets, their values, returns, diversification. Buy/sell/manage from the screen.
- **Full Economic Sandbox:** Real estate, stocks, bonds, crypto, commodities, venture capital, art collection, private equity
- **Full Financial Leverage:** Loans, margin, leverage ratios, interest payments, default risk, credit ratings. Real financial simulation.
- **Real Estate:** Buy/sell properties, rental income, development projects, commercial vs residential
- **Stock Market:** Trades, dividends, market cycles, crashes, insider trading (risky)
- **Startup Investments:** Angel investing, VC rounds, exits (IPO or acquisition)
- **Passive Income:** Dividends, rent, royalties, interest
- **Mergers & Acquisitions:** Buy entire companies, hostile takeovers
- **Board Seats:** Influence company decisions as major shareholder

**Milestones:**
- First investment (any asset class)
- First profitable trade/deal
- First million in net worth
- First property purchase
- First startup investment
- First successful exit
- Build a diversified portfolio
- Make first acquisition
- Reach $100M net worth
- Billionaire status
- Philanthropic phase (optional)

**Sub-reputations:**
- **Investor Credibility** (0–100) — how seriously other investors take you
- **Market Savvy** (0–100) — your ability to read market trends
- **Public Image** (0–100) — how the media/the public sees your wealth

**Endgame outcomes:**
- Billionaire: Reached 10-figure net worth
- Market Legend: Known as one of the greatest investors
- Philanthropist: Gave away majority wealth
- Bankrupt: Leverage bet went wrong, lost everything
- Retired: Comfortable wealth, stepped away

### 4.6 Movie Producer Path

**Scope:** Full filmmaker career. Start at the bottom (production assistant/runner) and work up. Can pursue indie OR studio paths.

**Unique mechanics:**
- **Full Film Production Cycle:**
  1. **Development:** Concept, script acquisition, writers
  2. **Pre-Production:** Budgeting, casting, crew hiring, location scouting
  3. **Production:** Principal photography, daily shooting, on-set decisions
  4. **Post-Production:** Editing, VFX, sound, scoring
  5. **Distribution:** Theatrical, streaming, festival circuit
  6. **Marketing:** Trailers, press, premieres
- **Multi-Project Pipeline:** Manage multiple films at different stages simultaneously
- **Cast & Crew Management:** Hire directors, actors, writers, cinematographers. Their reputation and chemistry affect film quality
- **Budget & Box Office:** Pitch budgets, secure funding (studios, investors, crowdfunding), track production costs, opening weekend, total gross, profitability
- **Critical Reception:** Critic scores (Rotten Tomatoes / Metacritic equivalent), audience scores
- **Art vs Commerce Tension (central):** Every project has an Art vs Commerce balance. Art films win awards. Commercial films make money. Player chooses their balance.
- **Awards System:** Festival selections (Sundance, Cannes, TIFF), nominations (Oscars, Golden Globes, BAFTAs), wins
- **Studio Politics:** Navigating studio executives, notes, greenlight process
- **Talent Relationships:** Building relationships with stars who want to work with you

**Milestones:**
- First short film
- First festival selection
- First studio deal / distribution deal
- Hire your first star actor
- First box office hit
- First critical darling
- First award nomination
- Win first award
- Build a production company
- Major franchise / blockbuster
- Lifetime achievement / legacy

**Sub-reputations:**
- **Critical Rep** (0–100) — how critics rate your films
- **Box Office Track** (0–100) — commercial track record
- **Industry Status** (0–100) — how Hollywood sees you
- **Talent Rapport** (0–100) — how actors/directors like working with you

**Endgame outcomes:**
- Oscar Winner: Won the Academy Award
- Studio Head: Left producing to run a studio
- Blockbuster King: Consistent commercial hits
- Indie Legend: Respected auteur producer
- Flopped Out: String of failures ended the career
- Retired: Left the industry on own terms

---

## 5. Cross-Path Systems

### 5.1 Path Interconnection (Deep)

All paths exist in the same living world. Examples of cross-path interactions:

| Interaction | From Path | To Path | How It Works |
|-------------|-----------|---------|-------------|
| Money laundering | Crime | Business | Use a front business to clean dirty money |
| Campaign finance | Tycoon | Politics | Fund a politician, get favorable policies |
| Blackmail | Crime | Politics | Discover a politician's secret, leverage it |
| Production funding | Tycoon | Movie | Fund a film as an investment |
| Mob film deals | Crime | Movie | Mob financing for films, with strings attached |
| Property development | Tycoon | Crime | Develop in territories controlled by gangs |
| Lobbying | Business | Politics | Influence policy for business advantage |
| Legit front | Crime | Business | Buy a business as a cover for operations |
| Biopic rights | Movie | Politics | Make a film about a politician's life |
| Real estate shell | Tycoon | Crime | Use shell companies to hide criminal assets |

### 5.2 Per-Field Reputation System (Detailed)

Each career path has 2–3 sub-metrics:

| Path | Sub-Rep 1 | Sub-Rep 2 | Sub-Rep 3 |
|------|-----------|-----------|-----------|
| **Crime** | Street Cred | Heat Level | Crew Loyalty |
| **Prison** | Inmate Respect | Guard Rapport | — |
| **Politics** | Voter Approval | Party Standing | Media Favorability |
| **Business** | Industry Rep | Customer Trust | Employee Morale |
| **Tycoon** | Investor Cred | Market Savvy | Public Image |
| **Movie** | Critical Rep | Box Office Track | Industry Status / Talent Rapport |

### 5.3 Multi-Class System

- Player can actively pursue 2–3 paths simultaneously
- Each path has its own progress track and sub-reputations
- Balancing multiple paths is a management challenge (time, energy, attention)
- Example: Business owner + Politician + Movie Investor
- Time allocation per day/week affects progress in each path
- Some combinations have natural synergy (Tycoon + Business), others create tension (Politician + Crime)

### 5.4 Career Switching

- **Organic:** You don't just "switch" — your past follows you
- A former crime boss running for office will face questions about their past
- Skills partially transfer (Social skills useful in any people-facing career)
- Relationships from previous path can be assets or liabilities
- Some switches are natural (Business → Tycoon), others dramatic (Crime → Politics)

---

## 6. Will & Inheritance System

### 6.1 Will Drafting

- Player can create a detailed will specifying beneficiaries per asset
- Assets include: properties, businesses, cash, investments, valuables
- Per-asset assignment: "House goes to oldest child, business to spouse, cash split equally"
- Can be modified at any time during life
- AI-assisted drafting: suggests reasonable defaults based on relationships

### 6.2 Intestate Defaults

- If player dies without a will, legal default rules apply:
  - Spouse inherits majority
  - Children split remainder
  - No spouse + no children → parents/siblings
  - No living family → state takes everything
- These defaults are calculated from the family relationship data

### 6.3 Multi-Generational Inheritance

- When the player character dies:
  1. Life review screen: stats, milestones, relationships, net worth
  2. Will is executed (or intestate defaults apply)
  3. Choose which descendant/heir to continue as
  4. New character starts with inherited assets
  5. Family reputation partially carries over
  6. Some relationships carry (family members remember the previous generation)

---

## 7. Data Model Additions

New tables needed beyond the base spec:

```sql
career_paths
  id: int (PK)
  player_id: int (FK)
  path_type: text (crime, politics, business, tycoon, movie, prison)
  is_active: bool
  started_at: datetime
  status: text (active, retired, failed, deceased)

career_milestones
  id: int (PK)
  career_path_id: int (FK)
  milestone_type: text
  title: text
  description: text
  achieved_at: datetime
  importance: int (1-10)

crime_crew
  id: int (PK)
  player_id: int (FK)
  npc_id: int (FK)
  role: text
  loyalty: real (0-100)
  skill: real (0-100)
  joined_at: datetime
  status: text (active, arrested, deceased, betrayed)

prison_sentence
  id: int (PK)
  player_id: int (FK)
  crime_path_id: int (FK, nullable)
  started_at: datetime
  sentence_length: int (days)
  good_conduct: real (0-100)
  inmate_respect: real (0-100)
  guard_rapport: real (0-100)
  status: text (serving, paroled, escaped, released)

political_positions
  id: int (PK)
  player_id: int (FK)
  office_title: text
  jurisdiction: text
  district: text
  party: text
  started_at: datetime
  ended_at: datetime (nullable)
  performance: real (0-100)

policy_stances
  id: int (PK)
  player_id: int (FK)
  issue: text (taxes, healthcare, education, etc.)
  stance: text (conservative, moderate, liberal, etc.)
  strength: int (1-10)

scandals
  id: int (PK)
  player_id: int (FK)
  title: text
  description: text
  severity: int (1-10)
  exposed_at: datetime
  is_resolved: bool
  resolution: text (nullable)

businesses
  id: int (PK)
  player_id: int (FK)
  name: text
  business_type: text
  description: text
  location_id: int (FK)
  founded_at: datetime
  revenue: real
  profit: real
  employees: int
  customer_satisfaction: real (0-100)
  industry_rep: real (0-100)
  status: text (operating, closed, bankrupt, acquired)

investments
  id: int (PK)
  player_id: int (FK)
  asset_type: text (stock, real_estate, crypto, bond, startup, art)
  name: text
  description: text
  purchase_price: real
  current_value: real
  quantity: real
  purchased_at: datetime

film_projects
  id: int (PK)
  player_id: int (FK)
  title: text
  genre: text
  budget: real
  box_office: real (nullable)
  critical_score: real (0-100) (nullable)
  audience_score: real (0-100) (nullable)
  stage: text (development, pre_production, production, post, distribution, released)
  art_score: int (1-10)
  commerce_score: int (1-10)
  started_at: datetime
  released_at: datetime (nullable)

film_crew
  id: int (PK)
  film_project_id: int (FK)
  npc_id: int (FK)
  role: text (director, actor, writer, cinematographer, etc.)
  salary: real
  performance: real (0-100)

wills
  id: int (PK)
  player_id: int (FK)
  created_at: datetime
  last_updated: datetime
  is_active: bool

will_bequests
  id: int (PK)
  will_id: int (FK)
  asset_type: text
  asset_id: int (FK, nullable)
  description: text
  beneficiary_type: text (npc, charity)
  beneficiary_id: int (FK, nullable)
  beneficiary_name: text
  percentage: real (nullable)

family_tree
  id: int (PK)
  player_id: int (FK)
  npc_id: int (FK)
  relationship: text (parent, child, sibling, spouse, grandparent, etc.)
```

---

## 8. New Screens & UI

### Education Screens
- **School Dashboard:** Current stage, grades, upcoming events, social status summary
- **Class Schedule:** Daily/weekly view of classes
- **Grades/Report Card:** Subject-by-subject performance
- **Extracurriculars:** Clubs, sports, activities management
- **College Apps:** Application tracker, essays, acceptance/rejection status

### Career Screens
- **Career Dashboard:** Active paths overview, current status, next milestones
- **Crime:** Heat meter, crew roster, active operations
- **Prison:** Sentence timer, jobs, contraband inventory, visitor log, parole status
- **Politics:** Office details, approval ratings, policy stances, upcoming elections, scandal tracker
- **Business:** P&L, balance sheet, employee roster, supplier/customer lists, expansion options
- **Tycoon:** Portfolio view (all assets with values), market news, leverage/debt tracker
- **Movie:** Project pipeline (multi-stage view), film details per project, awards/nominations

### Inheritance UI
- **Will Drafting Screen:** Asset list → assign beneficiaries, add charities
- **Life Review:** Full timeline, stats summary, achievements
- **Heir Selection:** Choose which descendant to continue as, see inherited assets

### Timeline Screen
- **Life Timeline:** Chronological view of all major milestones across ALL paths
- Filterable by path type, date range, importance
- "On This Day" view of past events
- Share/extract life story summary

---

## 9. Education Milestone Definitions

| Stage | Milestone Event | Age Trigger | Description |
|-------|----------------|-------------|-------------|
| Kindergarten | First Day | 3 | First day of school, separation anxiety |
| Kindergarten | First Friend | 3–4 | Make a meaningful friend |
| Kindergarten | First Crush | 4–5 | Innocent childhood crush |
| Kindergarten | Graduation | 6 | Moving up ceremony |
| Elementary | First Report Card | 6–7 | First graded evaluation |
| Elementary | First Field Trip | 6–8 | Class trip (zoo, museum) |
| Elementary | Bullied / Bully | 7–10 | Social conflict event |
| Elementary | Best Friend | 8–10 | Deep friendship forms |
| Elementary | Graduation | 10–11 | Moving up to middle school |
| Middle School | Puberty Event | 11–13 | Physical/emotional changes |
| Middle School | First Relationship | 11–14 | First romantic involvement |
| Middle School | Clique Integration | 11–14 | Find your social group |
| Middle School | First Elective | 12–13 | Choose a subject to explore |
| Middle School | Graduation | 13–14 | Moving up to high school |
| High School | Freshman Orientation | 14 | Starting high school |
| High School | Tryouts | 14–15 | Sports team / club auditions |
| High School | First Job | 15–16 | Part-time job starts |
| High School | Driver's License | 16 | Driving test |
| High School | Prom | 17–18 | Junior or senior prom |
| High School | SAT/ACT | 17–18 | College entrance exams |
| High School | College Acceptances | 18 | Decision time |
| High School | Graduation | 18 | Ceremony, senior activities |
| University | Freshman Welcome | 18 | Orientation, move into dorms |
| University | Major Declaration | 19–20 | Choose a field of study |
| University | First Internship | 19–21 | Work experience |
| University | Study Abroad | 20–22 | Semester overseas |
| University | Graduation | 22 | Commencement, degree awarded |

---

## 10. Career Path Interactions Map

```
                    ┌─────────────┐
                    │  EDUCATION  │
                    │ (K → Uni)   │
                    └──────┬──────┘
                           │
          ┌────────────────┼────────────────┐
          │                │                │
          ▼                ▼                ▼
   ┌────────────┐   ┌────────────┐   ┌────────────┐
   │  BUSINESS  │   │  TYCOON    │   │  MOVIE     │
   │ (company)  │◄──►│ (empire)   │◄──►│ (films)    │
   └──────┬─────┘   └──────┬─────┘   └──────┬─────┘
          │                │                │
          │   ┌────────────┼────────────────┤
          │   │            │                │
          ▼   ▼            ▼                ▼
   ┌────────────────────────────────────────────┐
   │              CRIME / UNDERWORLD             │
   │   (funding, enforcement, dirty money)      │
   └────────────────┬───────────────────────────┘
                    │
                    ▼
   ┌────────────────────────────────────────────┐
   │               PRISON SYSTEM                 │
   │   (consequence or choice)                  │
   └────────────────┬───────────────────────────┘
                    │
          ┌─────────┘
          ▼
   ┌────────────────────────────────────────────┐
   │              POLITICS                       │
   │   (laws, enforcement, pardons)             │
   └────────────────────────────────────────────┘
```

**Key interaction flows:**

1. **EDUCATION → All careers** — Education unlocks prerequisites and skills
2. **BUSINESS ↔ TYCOON** — Build a business, grow into tycoon. Tycoon buys businesses.
3. **TYCOON → MOVIE** — Fund films as investments. Buy studios.
4. **BUSINESS → CRIME** — Front companies for money laundering. Legitimate cover.
5. **CRIME → BUSINESS** — Dirty money needs laundering. Intimidation for business advantage.
6. **CRIME → POLITICS** — Bribes, blackmail, enforcement. Politicians can be dirty.
7. **POLITICS → CRIME** — Laws affect criminal operations. Police budgets. Corruption.
8. **CRIME → PRISON** — Get caught → serve time. Prison gangs connect to outside crime.
9. **TYCOON → POLITICS** — Campaign funding. Lobbying. Media ownership.
10. **MOVIE → POLITICS** — Celebrity endorsements. Biopics. Media influence.
11. **BUSINESS → POLITICS** — Job creation = political capital. Industry regulation.

---

## 11. Career Path Failure & Recovery

| Path | Failure Mode | Consequence | Recovery Options |
|------|-------------|-------------|-----------------|
| Crime | Arrested | Prison time | Serve sentence, escape, plea deal |
| Crime | Killed | Death | Game over → heir continues |
| Politics | Election loss | Lost office | Run again next cycle, change paths |
| Politics | Major scandal | Resignation, criminal charges | Rebuild reputation, leave politics |
| Business | Bankruptcy | Lose the business, debt | Start over, take job, rebuild |
| Tycoon | Margin call / crash | Significant wealth loss | Rebuild portfolio, pivot |
| Movie | Box office bomb | Lost investment, reputation damage | Make next film, change genres |
| Movie | Career-ending flop | Can't get funding | Move to TV, producing, teaching |
| Prison | Death in prison | Game over | Heir continues |
| Prison | Extended sentence | More time served | Parole, appeal, escape |

**Severity-based consequences:**
- Minor failure = soft reset, continue with some penalties
- Major failure (murder conviction, huge scandal) = permanent consequences
- Player chooses whether to continue or start fresh with heir

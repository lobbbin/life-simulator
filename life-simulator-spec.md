# AI Life Simulator — App Specification

> **Date:** July 2, 2026
> **Status:** Draft Spec
> **Project Type:** Greenfield Android App (built with Flutter)

---

## 1. Product Vision

A modern-day, single-player, AI-powered text-based life simulator for Android. Players live a simulated life through natural conversation with AI. The AI acts as both the narrator/world engine and drives the personalities of the NPCs that inhabit the world. The simulation tracks detailed life stats, relationships, careers, inventory, and locations in an open-world sandbox format.

The app is a free, local-only passion project. Users bring their own AI API key(s).

---

## 2. Core Architecture

### 2.1 Technology Stack

| Layer | Technology | Rationale |
|-------|-----------|-----------|
| **Framework** | Flutter (Dart) | Cross-platform readiness for future iOS/desktop |
| **State Management** | Provider | Simple, well-established pattern for Flutter |
| **Local Database** | SQLite (drift package) | Relational storage for structured simulation data |
| **Target API Level** | 24+ (Android 7.0 Nougat) | Broadest device compatibility (~95% of devices) |
| **Min. Dart SDK** | 3.x | Latest stable language features |
| **Min. Flutter SDK** | 3.x | Latest stable framework |

### 2.2 AI Integration

- **Architecture:** Flexible / configurable — user brings their own API key(s)
- **Hybrid AI Model:** Main narrator AI + specialist models per character (future enhancement)
- **Supported Providers (TBD):**
  - OpenAI (GPT-4.1, GPT-5.5) — best for instruction-following
  - Anthropic (Claude 3.5+, 4.x) — best for narrative depth and character writing
  - Google (Gemini 2.5+) — native Android integration path
  - OpenRouter — unified API to many providers
- **Response Style:** Configurable — user can choose between streaming (token-by-token) or full response
- **System Prompt Architecture:** Structured system prompt with dynamic injection of:
  - Current world state (stats, location, time)
  - Active character personas
  - Relevant memories from vector store
  - Recent conversation context

---

## 3. Life Simulation Mechanics

### 3.1 Player Stats & Attributes (Full Simulation)

#### Core Vitals
| Stat | Range | Description |
|------|-------|-------------|
| **Health** | 0–100 | Physical well-being. Affected by sleep, food, exercise, injury. |
| **Energy** | 0–100 | Stamina. Depletes with activity, recharges with rest/sleep. |
| **Happiness** | 0–100 | Emotional state. Affected by events, relationships, achievements. |

#### Life Domains
| Stat | Range | Description |
|------|-------|-------------|
| **Money** | 0–unbounded | Currency. Earned through career, spent on goods/services. |
| **Intelligence** | 0–100 | Knowledge & problem-solving. Grows through study, reading, experiences. |
| **Social** | 0–100 | Social skills & charisma. Grows through interactions. |
| **Fitness** | 0–100 | Physical fitness. Grows through exercise, declines with inactivity. |
| **Career** | 0–100 | Career progression. Tied to job level, performance, skills. |

#### Derived/Compound Stats
- **Hunger** (0–100) — independent tracker, eating reduces it
- **Stress** (0–100) — builds from work, difficult events; reduced by leisure
- **Reputation** (0–100) — how the world/NPCs perceive the player

### 3.2 Inventory System

- **Items** have: name, description, category (consumable/equipment/key_item), quantity, condition
- **Categories include:** Food, Clothing, Electronics, Books, Furniture, Tools, Documents, Misc
- Items can be:
  - Acquired (bought, found, gifted)
  - Used (consumed, equipped)
  - Traded/given to NPCs
  - Lost or broken

### 3.3 Skills System

| Skill | Description | Levels |
|-------|-------------|--------|
| Communication | Conversation, persuasion, debate | 1–100 |
| Physical | Athletics, strength, dexterity | 1–100 |
| Intellectual | Academics, logic, creativity | 1–100 |
| Practical | Cooking, cleaning, repair, driving | 1–100 |
| Artistic | Writing, music, visual arts | 1–100 |
| Social | Empathy, networking, leadership | 1–100 |

Skills unlock new actions and dialogue options.

### 3.4 Player Traits

Players have traits that affect gameplay:
- **Personality traits** (e.g., Introvert/Extrovert, Optimist/Pessimist, Brave/Cautious)
- **Lifestyle traits** (e.g., Early Bird/Night Owl, Neat/Messy)
- **Acquired traits** gained through life experiences (e.g., "Trauma: Car Accident", "Certified: Doctor")
- Traits affect stat changes, NPC interactions, and available actions

### 3.5 Time & Calendar System

#### Time Model
- **Real-time + Manual Advance:** Time passes in real-time when app is open. User can fast-forward by tapping to advance.
- **When app is closed:** A configurable amount of time passes (or none, user preference).
- **Time increments:** Each action/message advances time by a configurable increment.

#### Calendar
- Full calendar system: days, weeks, months, seasons, years
- **Seasons:** Spring, Summer, Autumn, Winter — affect weather, NPC behavior, events
- **Holidays:** Real-world holidays recognized and simulated
- **Day of week:** Weekdays vs weekends affect NPC availability, job requirements
- **Weather system:** Generated daily, affects mood, available activities

### 3.6 Location System (Open World Sandbox)

- **Player location** is a tracked state variable
- **Pre-defined core locations** (for first release):
  - Home (apartment/house — customizable)
  - Neighborhood streets
  - Local café/restaurant
  - Park
  - Grocery store
  - Gym
  - Hospital/clinic
- **AI-generated locations** — player can say "I want to go to [place]" and the AI describes a new location on the fly
- Locations have:
  - Name, description, type
  - List of NPCs present
  - Available interactions/actions
  - Time-dependent availability (shops close at night, etc.)

### 3.7 NPC Characters (Large Simulated World)

#### Character Mix
- **Core NPCs** (5–10 hand-crafted characters with rich backstories):
  - Family members
  - Close friends
  - Romantic interests
  - Rivals/antagonists
- **Procedural NPCs** — AI-generated characters encountered in the world:
  - Coworkers, neighbors, shopkeepers, strangers
  - Generated with personality, appearance, backstory on first encounter
  - Persisted if player interacts meaningfully
  - Forgotten/cleaned up if never encountered again

#### NPC Attributes
| Attribute | Description |
|-----------|-------------|
| Name, Age, Gender | Basic identity |
| Personality | Big 5 traits (Openness, Conscientiousness, Extraversion, Agreeableness, Neuroticism) |
| Backstory | Short narrative history |
| Occupation | What they do |
| Relationship to player | Friendship score (0–100), Romance score (0–100), Rivalry score (0–100) |
| Mood | Current emotional state |
| Schedule | Their daily routine (location + activity by time of day) |
| Memory | What this NPC remembers about past interactions with the player |

### 3.8 Relationship System (Numerically Tracked)

- **Each NPC** has three relationship dimensions with the player:
  - **Friendship** (0–100): Trust, camaraderie, platonic bond
  - **Romance** (0–100): Romantic/sexual interest
  - **Rivalry** (0–100): Competition, animosity, conflict
- Relationship thresholds unlock:
  - New dialogue options
  - Special events (dates, fights, collaborations)
  - NPC favor requests
  - Moving in together, marriage (romance)
- The AI updates relationship scores based on interaction content

### 3.9 Career System (Full Progression)

#### Career Stages
1. **Education** — choose path (high school -> college/trade school -> graduate)
2. **Skill Building** — develop skills relevant to desired career
3. **Job Applications** — apply to positions matching skills/education
4. **Interviews** — AI-simulated interview events
5. **Employment** — work events, performance reviews, raises/promotions
6. **Career Changes** — switch industries, start a business, retire

#### Career Attributes
- Job title, company, industry
- Salary (weekly/monthly income)
- Performance rating
- Relationships with boss and coworkers
- Career events (projects, deadlines, office politics, layoffs)

### 3.10 Memory System (Tiered)

The memory system has three tiers for maintaining coherence across sessions:

| Tier | Content | Storage | Retrieval |
|------|---------|---------|-----------|
| **Core Facts** | Player name, stats, key relationships, current job, location, owned property | Always stored in app state | Injected into every system prompt |
| **Recent History** | Last ~20–50 player-AI exchanges | In-memory + SQLite | Always included in prompt context |
| **Long-term Memories (RAG)** | Important past events, character interactions, milestones | SQLite with text embeddings | Retrieved via semantic similarity search for relevant context |

Memory items are:
- Automatically generated by the AI after significant events
- Tagged with timestamp, location, characters involved
- Summarized periodically to prevent unbounded growth
- Searchable by the player

---

## 4. User Interface

### 4.1 Visual Design Philosophy

- **Style:** Minimalist text-based / messaging app aesthetic
- **Color scheme:** Light and dark theme support (system-default)
- **Typography:** Clean, readable — standard Flutter Material Design fonts
- **No images/avatars:** Pure text experience (at least for MVP)

### 4.2 Screen Map

#### 1. Home Screen / Chat Feed
- Primary interface — a scrollable chat feed
- Shows AI narration bubbles and player message bubbles
- Character name headers on narration (e.g., "Narrator:", "Alex:", "Stranger:")
- Timestamps
- Inline stat updates (e.g., "[Energy -10] [Happiness +5]")
- Context-aware action buttons below the text input
- Text input field at the bottom for freeform typing

#### 2. Player Profile / Stats Panel
- View all player stats as bars/numbers
- Skills list with levels
- Traits list
- Inventory browser
- Quick summary card (visible as a drawer/panel)

#### 3. World Map / Locations
- List of known locations
- Current location highlighted
- Quick travel options

#### 4. Relationships / Contacts
- List of all known NPCs
- Per-NPC detail view: stats, relationship scores, interaction history, memory of you

#### 5. Calendar / Timeline
- Day/week/month view
- Upcoming events
- Past events log

#### 6. Settings
- AI provider selection + API key configuration
- Model selection per provider
- Streaming toggle
- Time acceleration settings
- Memory/context length preferences
- Theme toggle (light/dark)
- Data management (export, reset simulation)

#### 7. Career View
- Current job details
- Skill requirements for next level
- Performance history
- Job applications tracker

### 4.3 Interaction Model

- **Freeform chat:** Player types anything
- **Suggested actions:** 3–5 context-aware action buttons above the input (e.g., "Go to work", "Check phone", "Talk to [NPC]", "Eat lunch")
  - Suggestions are generated by the AI based on the current context
  - Tapping a suggestion sends it as a message
- **Stat management:** Occasional prompts from AI about low stats ("You're hungry, what would you like to eat?")
- **Streaming:** Enable/disable in settings

---

## 5. Data Model (Preliminary)

### SQLite Tables (drift ORM)

```
players
  id: int (PK)
  name: text
  age: int
  created_at: datetime
  last_played: datetime
  total_time_played: int (seconds)

player_stats
  id: int (PK)
  player_id: int (FK)
  stat_name: text (health, energy, happiness, money, intelligence, social, fitness, career, hunger, stress, reputation)
  stat_value: real
  updated_at: datetime

player_skills
  id: int (PK)
  player_id: int (FK)
  skill_name: text
  skill_level: int
  experience: real

player_traits
  id: int (PK)
  player_id: int (FK)
  trait_name: text
  trait_type: text (innate/acquired)
  acquired_at: datetime
  description: text

inventory_items
  id: int (PK)
  player_id: int (FK)
  name: text
  description: text
  category: text
  quantity: int
  condition: real (0.0-1.0)
  acquired_at: datetime

locations
  id: int (PK)
  name: text
  description: text
  location_type: text
  is_core: bool
  created_at: datetime

npc_characters
  id: int (PK)
  name: text
  age: int
  gender: text
  personality: text (JSON)
  backstory: text
  occupation: text
  current_location_id: int (FK)
  schedule: text (JSON - daily routine)
  is_core: bool
  created_at: datetime

relationships
  id: int (PK)
  player_id: int (FK)
  npc_id: int (FK)
  friendship: real (0-100)
  romance: real (0-100)
  rivalry: real (0-100)
  last_updated: datetime

career
  id: int (PK)
  player_id: int (FK)
  job_title: text
  company: text
  industry: text
  salary: real
  performance_rating: real (0-100)
  started_at: datetime
  is_current: bool

memories
  id: int (PK)
  player_id: int (FK)
  content: text
  summary: text
  embedding: blob (for vector search)
  timestamp: datetime
  location_id: int (FK, nullable)
  involved_npcs: text (JSON array of NPC IDs)
  importance: int (1-10)
  is_core: bool

conversation_messages
  id: int (PK)
  player_id: int (FK)
  session_id: text
  role: text (player/ai/narrator/npc)
  npc_id: int (FK, nullable)
  content: text
  timestamp: datetime
  stat_changes: text (JSON - optional)

calendar_events
  id: int (PK)
  player_id: int (FK)
  title: text
  description: text
  event_date: datetime
  event_type: text
  recurring: text (none/daily/weekly/yearly)
  location_id: int (FK, nullable)
  involved_npcs: text (JSON array)
  is_completed: bool
```

---

## 6. AI Prompt Architecture

### 6.1 System Prompt Structure

The system prompt sent to the AI will be dynamically assembled from these components:

```
[WORLD CONTEXT]
- Current date/time: {datetime}
- Season: {season}
- Weather: {weather}
- Player location: {location}

[PLAYER PROFILE]
- Name: {name}, Age: {age}
- Key Stats: {stats_summary}
- Skills: {skills_summary}
- Traits: {traits}
- Current Money: {money}

[RECENT HISTORY] (last 20 exchanges)
{chat_history}

[CORE MEMORIES] (always-injected important life events)
{memories}

[RELEVANT MEMORIES] (RAG-retrieved)
{retrieved_memories}

[CURRENT LOCATION]
{location_description}
{npcs_present}

[ACTIVE NPCS]
{character_sheets_for_engaged_npcs}

[RELATIONSHIPS WITH PRESENT NPCS]
{relationship_scores}

[SYSTEM RULES]
- You are a modern-day life simulator.
- Narrate in second person ("You wake up...").
- Track all stats consistently.
- Suggest 3-5 contextual actions at the end of each response.
- Keep responses 2-4 paragraphs unless the player asks for more.
- Time advances appropriately with each action.

[OUTPUT FORMAT]
Respond in the following format:
NARRATION: <narrative text>
ACTIONS: <JSON array of suggested actions>
STAT_CHANGES: <JSON object of stat changes>
```

### 6.2 AI Response Parsing

The app will parse structured output from the AI to extract:
- Narrative text (displayed as chat)
- Suggested actions (displayed as buttons)
- Stat changes (applied to the data model)
- Optional: memory items to persist

---

## 7. Development Phasing

While the vision is "full-featured from start," the implementation should follow a logical build order:

### Phase 1: Core Foundation
- [ ] Flutter project setup with Provider, drift, theming
- [ ] Data model (all SQLite tables)
- [ ] Settings screen (API key configuration, provider selection)
- [ ] Basic chat UI (message list + text input)
- [ ] AI integration service (send prompt, receive response, parse output)
- [ ] Player stat tracking (update based on AI responses)

### Phase 2: Life Simulation Core
- [ ] Time system (real-time + manual advance)
- [ ] Calendar system (days, seasons, weather)
- [ ] Location system (core locations + travel)
- [ ] Stat panel UI (profile screen)
- [ ] Skill system (tracking and progression)
- [ ] Inventory system (add, use, remove items)
- [ ] Suggested actions rendering

### Phase 3: Characters & World
- [ ] NPC system (core characters + procedural generation)
- [ ] Relationship system (tracking + UI)
- [ ] Character sheet view
- [ ] NPC scheduling (daily routines)
- [ ] Multi-character conversations

### Phase 4: Advanced Systems
- [ ] Full career system (education -> applications -> promotions)
- [ ] Event system (random events, holidays, life milestones)
- [ ] Trait system (personality + acquired traits)
- [ ] Calendar/timeline view
- [ ] World map screen

### Phase 5: Memory & Persistence
- [ ] Tiered memory system implementation
- [ ] RAG memory (text embeddings + similarity search)
- [ ] Memory management (summarization, pruning)
- [ ] Save/load simulation state
- [ ] Export simulation data

### Phase 6: Polish & Quality of Life
- [ ] Streaming AI responses
- [ ] Dark mode
- [ ] Animations and transitions
- [ ] Error handling and recovery
- [ ] Performance optimization
- [ ] Edge case handling

---

## 8. Project Structure (Proposed)

```
life_simulator/
├── android/
├── ios/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   ├── config/
│   │   ├── theme.dart
│   │   ├── constants.dart
│   │   └── routes.dart
│   ├── models/
│   │   ├── player.dart
│   │   ├── stats.dart
│   │   ├── skills.dart
│   │   ├── traits.dart
│   │   ├── inventory_item.dart
│   │   ├── location.dart
│   │   ├── npc_character.dart
│   │   ├── relationship.dart
│   │   ├── career.dart
│   │   ├── memory.dart
│   │   ├── calendar_event.dart
│   │   └── conversation_message.dart
│   ├── database/
│   │   ├── app_database.dart
│   │   ├── tables.dart
│   │   └── daos/
│   ├── providers/
│   │   ├── simulation_provider.dart
│   │   ├── player_provider.dart
│   │   ├── chat_provider.dart
│   │   ├── settings_provider.dart
│   │   └── time_provider.dart
│   ├── services/
│   │   ├── ai_service.dart
│   │   ├── prompt_builder.dart
│   │   ├── response_parser.dart
│   │   ├── memory_service.dart
│   │   ├── time_service.dart
│   │   └── event_service.dart
│   ├── screens/
│   │   ├── chat_screen.dart
│   │   ├── profile_screen.dart
│   │   ├── inventory_screen.dart
│   │   ├── locations_screen.dart
│   │   ├── contacts_screen.dart
│   │   ├── npc_detail_screen.dart
│   │   ├── career_screen.dart
│   │   ├── calendar_screen.dart
│   │   ├── timeline_screen.dart
│   │   ├── settings_screen.dart
│   │   └── world_map_screen.dart
│   ├── widgets/
│   │   ├── chat_bubble.dart
│   │   ├── stat_bar.dart
│   │   ├── action_suggestion_chip.dart
│   │   ├── npc_card.dart
│   │   ├── location_card.dart
│   │   ├── inventory_tile.dart
│   │   └── skill_display.dart
│   └── utils/
│       ├── helpers.dart
│       ├── constants.dart
│       └── extensions.dart
├── test/
├── pubspec.yaml
└── README.md
```

---

## 9. Edge Cases & Constraints

### Constraints
- **No internet = no simulation** — AI APIs require connectivity
- **API costs** borne by the user (their own API keys)
- **Latency** depends on chosen AI provider and model
- **Rate limits** imposed by AI providers
- **Context window limits** of chosen AI models — handled by tiered memory
- **No images** — pure text experience keeps data light and local

### Edge Cases
| Situation | Handling |
|-----------|----------|
| User loses internet mid-conversation | Cache last response, show "Reconnecting" indicator, retry |
| AI returns unparseable response | Show raw response to user, log for debugging |
| All NPCs forget player (memory full) | Summarize and prune oldest low-importance memories |
| Player dies (Health = 0) | Death event, option to restart or continue as "hospital recovery" |
| Player runs out of money | AI generates survival scenarios (homelessness, loans, help from NPCs) |
| Player wants to reset game | Full reset option in settings with confirmation dialog |
| AI rejects a prompt (safety filters) | Show error, suggest rephrasing, log the rejected prompt |
| Multiple AI providers configured | Allow user to select default per session |
| Time skip during app close | Option in settings: whether and how much time passes while away |
| Very long single play session | Periodic memory summarization in background, context window management |

---

## 10. Open Questions for Future Exploration

- [ ] Which AI provider to support as the primary/default? (OpenRouter is a good unified option)
- [ ] Text embeddings service for RAG memory — local on-device embeddings vs cloud API
- [ ] Specific core NPC archetypes and backstories (pre-defined characters)
- [ ] Weather generation approach (procedural vs AI-generated)
- [ ] Whether to support on-device LLMs (e.g., via llama.cpp/Ollama) for complete offline use
- [ ] Character portrait generation (text-to-image) — out of scope for MVP
- [ ] Specific stat change formulas (how much does exercise increase Fitness?)
- [ ] Push notifications for time-sensitive simulation events

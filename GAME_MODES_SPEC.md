## Disc Golf For Idiots - Complete Feature Specification

### **Game Modes Architecture**

#### **1. ACE RACE** (Already Partially Implemented)
Fast-paced competition hunting for aces (first-throw baskets).

**Gameplay:**
- Players throw at randomly generated challenges
- Score points for:
  - Aces (first throw hit): 5 points (configurable)
  - Metal (rim hit): 1 point (configurable)
  - Constraint completion: bonus points
- Track scores hole-by-hole

**Configuration:**
- Hole count: 3, 6, 9, 18
- Point values (ace, metal)
- Randomization toggles:
  - Random tee (short/long)
  - Random basket (short/long)
  - Random throw constraint (forehand/backhand/etc.)
- Multi-player support

**Scorecard Fields:**
- Course name
- Number of holes
- Players and scores
- Randomly selected tee pad
- Randomly selected target basket
- Par for each hole
- Winner indication

---

#### **2. PIN THE TAIL ON THE BIRDIE** (New)
Blindfolded target throwing - challenge players to throw at where they think the basket is.

**Gameplay:**
- Players are blindfolded (or turn away)
- Given a description of the hole (distance, terrain, par)
- Throw disc at where they think the basket is
- Score based on accuracy:
  - Direct hit: highest points
  - Near miss: medium points
  - Far miss: lower points
- Measure distance from basket to landing spot

**Configuration:**
- Hole count: 3, 6, 9, 18
- Scoring system (distance-based)
- Par confirmation per hole
- Player count

**Scorecard Fields:**
- Course name
- Number of holes
- Players and accuracy scores
- Randomly selected tee pad
- Randomly selected target basket
- Par for each hole
- Distance from basket (accuracy metric)
- Winner indication (most accurate/closest)

---

#### **3. ROUND RANDOMIZER** (New - Not Ace Race)
When the group can't decide the format, randomize everything!

**Gameplay:**
- Each hole has:
  - Randomly selected tee pad (short/long)
  - Randomly selected target basket (short/long)
  - Par for that hole (user-confirmable, default: 3)
- Players throw according to selected format
- Standard score keeping (stroke count)

**Configuration Options:**

**Required:**
- Course name / location
- Hole count: 3, 6, 9, 18
- Default par (typically 3, user can confirm/change per hole)

**Optional Option A - Throwing Style:**
- Forehand required
- Backhand required
- Any (no restriction)

**Optional Option B - Randomize Throwing Hand:**
- Left hand only
- Right hand only
- Randomize each throw (left or right)

**Configuration:**
- Multi-player support
- Par confirmation/adjustment per hole

**Scorecard Fields:**
- Course name
- Number of holes
- Players and stroke scores
- Randomly selected tee pad per hole
- Randomly selected target basket per hole
- Par for each hole
- Throwing style restriction (if any)
- Throwing hand restriction (if any)
- Winner indication (lowest score)

---

### **Scorecard Component (Universal)**

**Common Fields (All Modes):**
- Course name
- Number of holes
- Player names & count
- Date/time started
- Date/time completed

**Per-Hole Scorecard Data:**
- Hole number
- Randomly selected tee pad
- Randomly selected target basket
- Par value
- Individual player scores/results
- Timestamp per hole

**Summary:**
- Final scores for each player
- Winner (by mode rules)
- Game statistics
  - Total strokes (if applicable)
  - Accuracy metrics (if applicable)
  - Ace count (if applicable)

---

### **Data Models to Create/Update**

#### **New Models Needed:**

**1. GameMode (Enum)**
```
- ACE_RACE
- PIN_THE_TAIL
- ROUND_RANDOMIZER
```

**2. HoleConfiguration**
```
- holeNumber: int
- teeSelected: String (short/long)
- basketSelected: String (short/long)
- parValue: int
- throwStyleConstraint: String? (forehand/backhand/any)
- throwHandConstraint: String? (left/right/randomize)
```

**3. Scorecard**
```
- id: String
- roundId: String
- gameMode: GameMode
- courseName: String
- holeCount: int
- players: List<Player>
- holes: List<HoleConfiguration>
- scores: Map<playerId, List<int>> (scores per hole)
- accuracyMetrics: Map? (for pin the tail)
- winner: Player
- createdAt: DateTime
- completedAt: DateTime?
```

**4. GameRound (Updated Round Model)**
```
- Extends existing Round
- gameMode: GameMode
- holeConfigurations: List<HoleConfiguration>
- scorecard: Scorecard
```

---

### **Services to Create/Update**

#### **1. GameModeService** (New)
- Initialize game mode
- Get configuration options for each mode
- Validate game mode rules
- Calculate winners

#### **2. HoleRandomizerService** (New)
- Generate random hole configurations
- Support different randomization strategies per mode
- Apply constraints (throwing style, hand)

#### **3. ScorecardService** (New)
- Create scorecard template
- Update scores during gameplay
- Calculate statistics
- Format for display/export

#### **4. AceRaceGenerator** (Update)
- Refactor to use HoleRandomizerService
- Add mode-specific generation

#### **5. StorageService** (Update)
- Add scorecard persistence
- Add game round persistence
- Query by game mode

---

### **UI Screens to Create/Update**

#### **1. Home Screen** (Update)
- Add three game mode options:
  - Ace Race
  - Pin The Tail On The Birdie
  - Round Randomizer
- Update navigation

#### **2. Ace Race Setup Screen** (Already exists - keep)
- Fine-tune existing implementation

#### **3. Pin The Tail Setup Screen** (New)
- Course selection
- Hole count
- Par confirmation
- Player setup
- Accuracy scoring preferences

#### **4. Round Randomizer Setup Screen** (New)
- Course selection / entry
- Hole count (3, 6, 9, 18)
- Default par
- Optional Option A: Throwing style toggle
- Optional Option B: Throwing hand toggle
- Player setup
- Per-hole par confirmation

#### **5. Scorecard Display Screen** (New - Universal)
- Shows:
  - Course name
  - Players & scores
  - Hole-by-hole breakdown
  - Tee/basket selection per hole
  - Par for each hole
  - Winner indication
  - Export/share options

#### **6. Game Play Screen** (New - Universal)
- Current hole display
- Tee pad information
- Target basket information
- Par value
- Score input per player
- Navigation (next hole, previous hole)
- Live scoreboard

---

### **Implementation Priority**

**Phase 1 (Core Models & Services):**
1. Create GameMode enum
2. Create HoleConfiguration model
3. Create Scorecard model
4. Create GameModeService
5. Create HoleRandomizerService
6. Update StorageService

**Phase 2 (Game Setup Screens):**
7. Update HomeScreen
8. Keep/refine AceRaceSetupScreen
9. Create PinTheTailSetupScreen
10. Create RoundRandomizerSetupScreen

**Phase 3 (Gameplay & Scoring):**
11. Create GamePlayScreen (universal)
12. Create ScorecardService
13. Create ScorecardDisplayScreen

**Phase 4 (Polish & Testing):**
14. Comprehensive testing
15. Export/share functionality
16. Statistics tracking

---

### **Future Upgrade: U-Disc API Integration**

When ready, add:
- `UDiscService` to fetch:
  - Courses by location
  - Course layout (holes, pars, distances)
  - Tee pad options per hole
  - Basket/target options per hole
  - Course ratings & slope
- Update course selection to use real data
- Pre-populate hole configurations from U-Disc

---

### **Database Schema (Firestore)**

**Collections:**
- `rounds` - All game rounds
- `scorecards` - Scorecard templates and results
- `game_sessions` - Active games with live scores
- `holes_configuration` - Per-hole random selections
- `players` - Player profiles
- `courses` (Future) - U-Disc integrated course data

---

### **Key Features Summary**

| Feature | Ace Race | Pin The Tail | Round Randomizer |
|---------|----------|-------------|------------------|
| Game Type | Speed Competition | Accuracy Challenge | Standard Format |
| Scoring | Points | Distance-based | Strokes |
| Randomization | Challenges | Target blind | Everything |
| Constraints | Yes | Yes | Optional |
| Par Value | Configured | N/A | Per hole |
| Multiplayer | Yes | Yes | Yes |
| Scorecard | Yes | Yes | Yes |


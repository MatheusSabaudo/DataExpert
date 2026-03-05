/*
===============================================================================
NBA Players Dimensional Model - Cumulative Table Design
===============================================================================
This script implements a slowly changing dimensional model for NBA player data,
tracking player statistics across seasons using array type to maintain history.

Purpose:
- Transform raw seasonal player data into a cumulative dimensional model
- Track player performance metrics across seasons
- Maintain historical statistics in an array structure
- Classify players based on scoring performance

Source Table: player_seasons (raw seasonal data)
Target Table: players (cumulative dimensional table)

Data Flow:
1. Define custom types for structured data storage
2. Create players table with array type for historical stats
3. Incrementally load data season by season
4. Query examples for analysis

Author: Analytics Engineering Team
Last Modified: 2024
===============================================================================
*/

-- =============================================================================
-- STEP 1: Define Custom Data Types
-- =============================================================================

/*
season_stats: Composite type to store yearly player statistics
- season: Year of the season (e.g., 2001 represents 2000-2001 season)
- gp: Games played that season
- pts: Points per game average
- reb: Rebounds per game average
- ast: Assists per game average
*/
CREATE TYPE season_stats AS (
	season INTEGER,
	gp INTEGER,
	pts REAL,
	reb REAL,
	ast REAL
);

/*
scoring_class: Enum to categorize players based on scoring performance
- star: Elite scorers (> 20 points per game)
- good: Above-average scorers (15-20 points per game)
- average: Mid-range scorers (10-15 points per game)
- bad: Below-average scorers (< 10 points per game)
*/
CREATE TYPE scoring_class AS ENUM ('star', 'good', 'average', 'bad');
	

-- =============================================================================
-- STEP 2: Create Players Table (Cumulative Design)
-- =============================================================================

/*
players: Main dimensional table with cumulative statistics
Design Pattern: Type 2 Slowly Changing Dimension using array for history

Columns:
- player_name: Unique identifier for player
- height: Player height (text to preserve format)
- college: College attended
- country: Country of origin
- draft_year: Year drafted
- draft_round: Round drafted (1, 2, etc.)
- draft_number: Overall pick number
- season_stats: Array of season_stats type, storing all seasons
- scoring_class: Current scoring classification
- years_since_last_season: Years since last active season
- current_season: Most recent season in the data

Primary Key: (player_name, current_season) - Ensures one record per player per season
*/
CREATE TABLE players (
	player_name TEXT,
	height TEXT,
	college TEXT,
	country TEXT,
	draft_year TEXT,
	draft_round TEXT,
	draft_number TEXT,
	season_stats season_stats[],
	scoring_class scoring_class,
	years_since_last_season INTEGER,
	current_season INTEGER,
	PRIMARY KEY(player_name, current_season)
);

-- Check the earliest season available in the source data
SELECT MIN(season) FROM player_seasons;

-- =============================================================================
-- STEP 3: Data Loading - Incremental Update Pattern
-- =============================================================================

/*
Incremental Load Pattern: 
Load one season at a time (2001 in this example) by joining:
- yesterday: Existing player records from previous season (2000)
- today: New season data from source table (2001)

This pattern builds history incrementally and maintains player continuity
across seasons, even for inactive players.
*/

INSERT INTO players

WITH yesterday AS (
	-- Get all players from previous season
	SELECT * FROM players
	WHERE current_season = 2000
),
	today AS (
		-- Get new data for current season from source
		SELECT * FROM player_seasons
		WHERE season = 2001
	)

SELECT
	-- Player biographical data - coalesce to handle new/returning players
	COALESCE(t.player_name, y.player_name) AS player_name,
	COALESCE(t.height, y.height) AS height,
	COALESCE(t.college, y.college) AS college,
	COALESCE(t.country, y.country) AS country,
	COALESCE(t.draft_year, y.draft_year) AS draft_year,
	COALESCE(t.draft_round, y.draft_round) AS draft_round,
	COALESCE(t.draft_number, y.draft_number) AS draft_number,

	/*
	Build season_stats array:
	3 scenarios:
	1. New player: Create new array with first season
	2. Existing player with new season: Append to existing array
	3. Existing player no new season: Keep existing array
	*/
	CASE 
	WHEN y.season_stats IS NULL
		THEN ARRAY[ROW(
				t.season,
				t.gp,
				t.pts,
				t.reb,
				t.ast
			)::season_stats]
	
	WHEN t.season IS NOT NULL 
		THEN y.season_stats || ARRAY[ROW(
				t.season,
				t.gp,
				t.pts,
				t.reb,
				t.ast
			)::season_stats]
	
	ELSE y.season_stats
	END AS season_stats,
	
	/*
	Determine scoring class based on current season's points
	If no current season, retain last known classification
	*/
	CASE 
		WHEN t.season IS NOT NULL THEN 
			CASE 
				WHEN t.pts > 20 THEN 'star'
				WHEN t.pts > 15 THEN 'good'
				WHEN t.pts > 10 THEN 'average'
				ELSE 'bad'
		END::scoring_class
	ELSE y.scoring_class  
	END as scoring_class,

	/*
	Track inactivity:
	- 0 if player active this season
	- Increment previous value + 1 if inactive
	*/
	CASE
		WHEN t.season IS NOT NULL THEN 0
	ELSE y.years_since_last_season + 1
	END AS years_since_last_season,
	
	-- Current season: use new season data or increment from previous
	COALESCE(t.season, y.current_season + 1) as current_season
	
FROM today t 
FULL OUTER JOIN yesterday y
	ON t.player_name = y.player_name;

-- =============================================================================
-- STEP 4: Analysis Queries
-- =============================================================================

/*
Player Improvement Analysis:
Calculate the ratio of current season points to first season points
for star players in 2001.

This demonstrates accessing array elements:
- season_stats[1]: First season in player's career
- season_stats[CARDINALITY(season_stats)]: Most recent season
- ::season_stats: Cast array element to composite type
- .pts: Access points field from the composite type
*/

SELECT 
	player_name,
	-- Calculate improvement ratio (current pts / first season pts)
	(season_stats[CARDINALITY(season_stats)]::season_stats).pts/
	CASE 
		WHEN (season_stats[1]::season_stats).pts = 0 
		THEN 1  -- Avoid division by zero
	ELSE (season_stats[1]::season_stats).pts
	END as improvement_ratio
FROM players 
WHERE current_season = 2001 
AND scoring_class = 'star';

/*
Additional Analysis Possibilities:
- Career trajectory analysis using array unnesting
- Year-over-year performance changes
- Draft class performance comparisons
- Player longevity analysis using years_since_last_season
- Country/college performance aggregation
*/
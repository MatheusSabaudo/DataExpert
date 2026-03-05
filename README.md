
# DataExpert.io Bootcamp - Data Engineering Learning Journey

![Data Engineering](https://img.shields.io/badge/Data%20Engineering-Bootcamp-blue)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15%2B-green)
![Status](https://img.shields.io/badge/Status-In%20Progress-yellow)

## 📚 About This Repository

This repository contains my learning journey through the **DataExpert.io Bootcamp** by Zach Wilson. It serves as a comprehensive collection of exercises, projects, and implementations of modern data engineering patterns and techniques taught in the bootcamp.

## 🎯 Learning Objectives

- Master dimensional data modeling techniques used at FAANG companies
- Implement cumulative table designs for historical data tracking
- Build efficient ETL/ELT pipelines
- Understand slowly changing dimensions (SCDs) and their implementations
- Learn real-world data engineering patterns and best practices

## 📋 Repository Structure

```
dataexpert-bootcamp/
│
├── 01-dimensional-data-modeling/
│   ├── cumulative-table-design/
│   │   ├── nba_players_cumulative.sql
│   │   ├── README.md
│   │   └── analysis_queries.sql
│   ├── slowly-changing-dimensions/
│   └── README.md
│
├── 02-fact-data-modeling/
│   ├── fact-tables/
│   ├── daily-facts/
│   └── README.md
│
├── 03-apache-spark/
│   ├── spark-fundamentals/
│   ├── spark-sql/
│   └── README.md
│
├── 04-real-time-processing/
│   ├── kafka/
│   ├── flink/
│   └── README.md
│
├── 05-data-quality/
│   ├── data-tests/
│   ├── monitoring/
│   └── README.md
│
├── projects/
│   └── nba-player-tracker/
│       ├── schema/
│       ├── etl/
│       └── analysis/
│
├── resources/
│   ├── cheatsheets/
│   ├── useful-queries.sql
│   └── links.md
│
├── .gitignore
├── LICENSE
└── README.md
```

## 🏗️ Key Implementations

### Cumulative Table Design (NBA Players Example)

One of the core patterns learned in the bootcamp - implementing a cumulative table design for tracking NBA player statistics across seasons:

```sql
-- Example pattern from the bootcamp
CREATE TABLE players (
    player_name TEXT,
    season_stats season_stats[],  -- Array of yearly stats
    scoring_class scoring_class,
    years_since_last_season INTEGER,
    current_season INTEGER,
    PRIMARY KEY(player_name, current_season)
);
```

**Key Concepts Demonstrated:**
- Array data types for historical tracking
- Slowly changing dimensions (Type 2 SCD)
- Incremental loading patterns
- Handling active vs. inactive players

## 🛠️ Technologies & Tools

- **Databases:** PostgreSQL, Snowflake
- **Big Data:** Apache Spark, Databricks
- **Streaming:** Apache Kafka, Apache Flink
- **Languages:** SQL, Python, Scala
- **Cloud:** AWS, cloud-agnostic patterns
- **Orchestration:** Airflow (pattern implementations)

## 📊 Progress Tracker

| Module | Status | Topics Covered |
|--------|--------|----------------|
| Dimensional Data Modeling | 🔄 In Progress | Cumulative tables, SCDs, Arrays |
| Fact Data Modeling | ⏳ Not Started | Fact tables, daily aggregates |
| Apache Spark | ⏳ Not Started | RDDs, DataFrames, Spark SQL |
| Real-time Processing | ⏳ Not Started | Kafka, Flink, streaming |
| Data Quality | ⏳ Not Started | Testing, monitoring, validation |

## 🚀 Getting Started

### Prerequisites
- PostgreSQL 15+
- Basic SQL knowledge
- Python 3.8+ (for future Spark modules)

### Running the Examples

1. Clone the repository:
```bash
git clone https://github.com/yourusername/dataexpert-bootcamp.git
cd dataexpert-bootcamp
```

2. Set up the database:
```bash
psql -f 01-dimensional-data-modeling/cumulative-table-design/setup.sql
```

3. Run the cumulative table example:
```bash
psql -f 01-dimensional-data-modeling/cumulative-table-design/nba_players_cumulative.sql
```

## 💡 Key Learnings & Insights

### Cumulative Table Design Pattern
This pattern, taught in the bootcamp, is particularly powerful for:
- Tracking player/entity history without storing duplicates
- Enabling efficient time-series analysis
- Reducing query complexity for historical comparisons
- Maintaining data quality with type enforcement

### Real-World Application
These patterns are directly applicable to:
- User behavior tracking
- Inventory management systems
- Financial time-series data
- IoT sensor data aggregation

## 📝 Notes & Best Practices

- **Always** define clear primary keys
- Use custom types for complex data structures
- Implement incremental loading for scalability
- Document edge cases (inactive players, null handling)
- Test with small datasets before scaling

## 🤝 Contributing

This is a personal learning repository, but if you spot errors or have suggestions:
1. Open an issue
2. Submit a pull request
3. Reach out on LinkedIn/Twitter

## 📚 Additional Resources

- [DataExpert.io Official Site](https://dataexpert.io)
- [Zach Wilson's YouTube Channel](https://youtube.com/@ZachWilsonTech)
- [Bootcamp Community Discord](https://discord.gg/dataexpert)
- [Recommended Reading List](./resources/reading-list.md)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Zach Wilson** for creating this comprehensive curriculum
- **DataExpert.io Community** for support and discussions
- Everyone sharing their learning journeys in the Discord community

---

<div align="center">
  <sub>Learning data engineering one cumulative table at a time</sub><br>
  <sub>⭐ Star this repo if you find it helpful! ⭐</sub>
</div>

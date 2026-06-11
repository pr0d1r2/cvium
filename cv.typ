// CV — Marcin Nowicki
// 2-page Staff/L5 CV targeting CI infrastructure & technical leadership roles

#set document(
  title: "Marcin Nowicki — Staff Software Engineer",
  author: "Marcin Nowicki",
)

#set page(
  paper: "a4",
  margin: (top: 1.6cm, bottom: 1.3cm, left: 1.8cm, right: 1.8cm),
)

#set text(font: "New Computer Modern", size: 9.2pt)
#set par(justify: true, leading: 0.5em)

#let accent = rgb("#2563eb")
#let muted = rgb("#6b7280")

#let section(title) = {
  v(0.4em)
  text(size: 10.5pt, weight: "bold", fill: accent, upper(title))
  v(-0.3em)
  line(length: 100%, stroke: 0.5pt + accent)
  v(0.2em)
}

#let role(title, company, dates) = {
  v(0.3em)
  grid(
    columns: (1fr, auto),
    text(weight: "bold", size: 9.5pt, title),
    text(fill: muted, size: 8.5pt, dates),
  )
  if company != "" {
    text(fill: muted, size: 8.5pt, company)
  }
  v(0.15em)
}

#let bullet(body) = {
  grid(
    columns: (1em, 1fr),
    column-gutter: 0.2em,
    text(fill: accent, "•"), body,
  )
}

// ── HEADER ──────────────────────────────────────────────────────────────────

#grid(
  columns: (auto, 1fr),
  column-gutter: 1em,
  align(top, image("avatar.png", width: 2.5cm)),
  {
    text(size: 22pt, weight: "bold", "Marcin Nowicki")
    v(-0.1em)
    text(
      size: 11pt,
      fill: muted,
      "Staff Software Engineer — CI/CD & Developer Tooling",
    )
    v(0.4em)
    text(size: 8.5pt, fill: muted)[
      marcin\@prodix.pl #h(0.8em)
      Częstochowa, Poland #h(0.8em)
      github.com/pr0d1r2 #h(0.8em)
      linkedin.com/in/pr0d1r2
    ]
    v(0.35em)
    text(size: 9.2pt)[
      Engineer with 30+ years in technology — all remote — building CI/CD infrastructure and developer tooling at scale.
      Coordinated with 200+ engineers across organizations at Toptal,
      built company-wide CI systems at Oyster, and led teams from inception through self-sufficiency.
      Passionate about tools that multiply engineering quality and velocity.
    ]
  },
)

// ── EXPERIENCE ──────────────────────────────────────────────────────────────

#section("Experience")

#role(
  "Operational Staff Engineer → Lead Engineer",
  "Oyster HR — Entire Engineering / Total Rewards Team",
  "2022.04 – Present",
)
#bullet[Built company-wide CI system from scratch, migrating from GitHub Actions to a unified pipeline serving all engineering teams.]
#bullet[Building agentic AI developer tooling ecosystem (open-source) — autonomous NixOS agent nodes that open PRs, run specs, and maintain 30+ repositories independently; declarative agent configuration; cross-agent persistent memory.]
#bullet[Shaped engineering behavior through high-level BDD frameworks — used RSpec tooling to resolve cross-team communication issues with the Data Team.]
#bullet[Created Sentry notification and triage system adopted as seed pattern across Engineering.]
#bullet[Scaled impact from single team to entire engineering org — established processes enabling promotions, provided pair programming support and ad-hoc issue resolution company-wide.]

#role(
  "Senior Back-End Engineer",
  "Toptal — Goldsmiths Team",
  "2020.10 – 2022.02",
)
#bullet[Built GraphQL generators for types and mutations used by 5+ teams across 12 schemas stitched via Apollo Server — eliminated boilerplate across dozens of teams.]
#bullet[Created custom RuboCop cops preventing anti-patterns in implementation and specs company-wide.]
#bullet[Drove GraphQL standardization across the company through RFC processes.]

#role(
  "Technical Team Lead / Manager",
  "Toptal — Billing Extraction Team",
  "2019.08 – 2020.10",
)
#bullet[Scaled team from 4 to 16 engineers; conducted dozens of technical and cultural interviews. Reported to VP of Engineering on a CEO-priority SOA migration project.]
#bullet[Co-built semi-automated "extraction tool" to decouple monolith engine into separate repositories and services.]
#bullet[Split team into Back-End and Front-End; found and trained two successor Team Leads. Managed OKRs/KPIs and engineer career paths.]

#role(
  "Technical Team Lead / Manager → Senior Back-End Engineer",
  "Toptal — Verticalization Team",
  "2016.03 – 2019.06",
)
#bullet[Coordinated with 200+ engineers to implement multi-tenancy support across the entire platform.]
#bullet[Created "Vertical Wizard" — codified all multi-tenancy knowledge into a database-driven tool, making the team intentionally redundant ("meta-team" philosophy).]
#bullet[Led company-wide spec performance refactor saving six-figure annual infrastructure costs.]
#bullet[Implemented company-wide abilities system around verticals. Found and trained successor Team Lead.]

#role(
  "Senior Back-End Engineer",
  "Distribusion Technologies",
  "2014.10 – 2017.01",
)
#bullet[Owned API integrations on transportation platform. Built cross-team developer tooling and championed remote work adoption.]

#pagebreak()

#role(
  "Ruby on Rails Developer",
  "JustGo Music — Social Management Platform",
  "2013.08 – 2014.04",
)
#bullet[Integrated multiple external APIs (Facebook, Twitter, Instagram, YouTube, SoundCloud, MixCloud). Metrics via KISS Metrics and Intercom. Hosted on Heroku.]

#role(
  "Staff Software Engineer",
  "Mamymo — E-commerce Platform",
  "2011.01 – 2013.08",
)
#bullet[All four Staff Engineer aspects: Tech Lead, Architect, Solver, Right Hand. Reported to CEO with a 12-person team.]
#bullet[Multi-country e-commerce (15 countries, 30 languages, 2–5 brands each) with millions of weekly visits and near-zero downtime tolerance.]
#bullet[Integrated multiple shopping APIs with SEM-driven landing pages for Google traffic arbitrage.]

#role(
  "Technical Team Lead → Developer",
  "Studitemps GmbH (Jobmensa.de)",
  "2008.08 – 2010.03",
)
#bullet[Led team of 8 as SCRUM Master. Student job outsourcing platform with geolocation.]

#role(
  "Ruby on Rails Developer",
  "Experteer",
  "2010.03 – 2010.12",
)
#bullet[Google-friendly job catalog with cross-site API scraping and MongoDB log statistics aggregation.]

#role(
  "Founder / Developer",
  "go28days.com — Startup",
  "2006.04 – 2008.04",
)
#bullet[Co-founded fertility tracking platform. Custom TeX-based Ruby DSL for charting. Full-stack on Rails 1.x.]

#role(
  "Freelance PHP Developer / Linux & Network Administrator",
  "",
  "1995 – 2006",
)
#bullet[PHP/MySQL projects for local businesses (2000–2006). Managed 2–5 Gentoo Linux servers, 150+ Windows machines and WAN at Wyższa Szkoła Zarządzania w Częstochowie (1995–2000).]

// ── SKILLS ──────────────────────────────────────────────────────────────────

#section("Technical Skills")

#grid(
  columns: (auto, 1fr),
  column-gutter: 0.8em,
  row-gutter: 0.3em,

  text(weight: "bold", size: 8.5pt, "Languages"),
  text(
    size: 8.5pt,
    "Ruby, Shell (bash/zsh), JavaScript/TypeScript, Nix, Python, PHP",
  ),

  text(weight: "bold", size: 8.5pt, "Frameworks"),
  text(
    size: 8.5pt,
    "Ruby on Rails, RSpec, GraphQL, React.js, Stimulus, Backbone.js",
  ),

  text(weight: "bold", size: 8.5pt, "CI/CD & Testing"),
  text(
    size: 8.5pt,
    "Jenkins, GitHub Actions, HarnessCI, RSpec, Minitest, Capybara, Cucumber, Selenium, RuboCop (custom cops)",
  ),

  text(weight: "bold", size: 8.5pt, "Infrastructure"),
  text(
    size: 8.5pt,
    "Docker, NixOS, GCP, Terraform, Chef, Ansible, Gentoo/Debian/Alpine Linux",
  ),

  text(weight: "bold", size: 8.5pt, "Data & Search"),
  text(
    size: 8.5pt,
    "PostgreSQL, MySQL, MongoDB, ElasticSearch (Chewy), Redis, Memcached",
  ),

  text(weight: "bold", size: 8.5pt, "Architecture"),
  text(
    size: 8.5pt,
    "Microservices, SOA, REST, GraphQL (Apollo Federation), Monolith decomposition",
  ),

  text(weight: "bold", size: 8.5pt, "AI & Tooling"),
  text(
    size: 8.5pt,
    "Agentic AI infrastructure, Autonomous Agents, Claude Code, SDD (CAVEKIT), LLM token optimization (RTK), Vector stores, BM25, Embeddings",
  ),

  text(weight: "bold", size: 8.5pt, "Leadership"),
  text(
    size: 8.5pt,
    "Scaled Scrum, Kanban, LEAN, OKRs/KPIs, Team building (4→16), Technical mentoring",
  ),
)

// ── EDUCATION ───────────────────────────────────────────────────────────────

#section("Education")

#grid(
  columns: (1fr, auto),
  text(
    size: 9pt,
  )[*Electronic Technician, Computer Systems* — Techniczne Zakłady Naukowe, Częstochowa],
  text(fill: muted, size: 8.5pt, "1997 – 2002"),
)

// ── HIGHLIGHTS ──────────────────────────────────────────────────────────────

#section("Key Highlights")

#grid(
  columns: (1fr, 1fr),
  column-gutter: 1.5em,
  row-gutter: 0.25em,
  bullet[30+ years in technology, exclusively remote],
  bullet[Built CI systems for entire engineering organizations],

  bullet[Coordinated with 200+ engineers at Toptal],
  bullet[Scaled teams from scratch (4→16 engineers)],

  bullet[Trained 3+ successor technical leads],
  bullet[Six-figure annual savings from spec optimization],

  bullet[260+ OSS repos; 30+ composable Nix CI packages],
  bullet[Building agentic AI developer tooling ecosystem],
)

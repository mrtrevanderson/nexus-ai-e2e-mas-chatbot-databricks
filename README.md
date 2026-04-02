# Nexus AI — E2E Multi-Agent Supervisor Chatbot (Databricks)

> A monorepo containing the Databricks app source code and demo setup materials for the Nexus AI multi-agent supervisor chatbot, demoed via ErgoPro — a fictional ergonomic chair company.

---

## Repo Structure

```
nexus-ai-e2e-mas-chatbot-databricks/
│
├── README.md
│
├── app/                          ← Databricks app source code
│   ├── client/                      React frontend (Vite + Tailwind)
│   ├── server/                      ExpressJS backend
│   ├── packages/                    Shared packages (auth, core, db, utils)
│   ├── scripts/                     DB migration & setup scripts
│   ├── tests/                       Playwright e2e tests
│   ├── databricks.yml               Databricks Asset Bundle config
│   ├── app.yaml                     App runtime config
│   └── package.json                 Root workspace manifest
│
└── demo/                         ← Demo setup & reference materials
    ├── 01_data_setup/               Sample data & catalog setup
    ├── 02_subagent_config/          Sub-agent tool and endpoint configs
    ├── 03_supervisor_config/        MAS supervisor agent configuration
    ├── 04_sample_prompts/           Example prompts and conversation flows
    ├── 05_marketing/                LinkedIn / social copy and assets
    ├── 06_branding/                 ErgoPro brand assets (logo, colors, copy)
    └── 07_docs/                     Architecture diagrams and documentation
```

---

## App

The `app/` directory contains the full Databricks chat application — a multi-agent supervisor (MAS) chatbot with a React frontend, ExpressJS backend, and Databricks Agent Bricks integration.

See [`app/`](./app) for setup and deployment instructions.

### Quick Start

```bash
cd app
npm install
cp .env.example .env   # fill in DATABRICKS_CONFIG_PROFILE + endpoint name
npm run dev
```

App runs at [localhost:3000](http://localhost:3000) (frontend) / [localhost:3001](http://localhost:3001) (backend).

### Deploying to Databricks

```bash
cd app
databricks bundle deploy -t dev
databricks bundle run nexus_mas_chatbot -t dev
```

GitHub Actions workflows handle CI/CD automatically:
- **Dev** — deploys on every push to `main`
- **Staging** — deploys on push to `staging` branch or manual trigger
- **Prod** — manual trigger only (requires typing `DEPLOY` to confirm)

---

## Demo Materials

The `demo/` directory contains everything needed to set up and present the ErgoPro demo environment. Add your configs, sample data, and assets to the appropriate subfolder — kept separate so demo changes never touch app source code.

| Folder | Contents |
|---|---|
| `01_data_setup/` | Unity Catalog tables, sample order/product data |
| `02_subagent_config/` | Tool definitions and sub-agent endpoint configs |
| `03_supervisor_config/` | MAS supervisor prompt and routing config |
| `04_sample_prompts/` | Example conversation flows and test prompts |
| `05_marketing/` | LinkedIn posts, social assets |
| `06_branding/` | ErgoPro logo, color palette, UI copy |
| `07_docs/` | Architecture diagrams, setup walkthroughs |

---

*ErgoPro is a fictional company used for demo purposes only.*

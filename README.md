# ErgoPro Support Assistant

> **Demo Project** — A conversational AI support assistant for ErgoPro, a fictional ergonomic chair company. Built on the Databricks Agent Chat template (v2 simplified output) to showcase multi-agent AI in a real-world customer support context.

---

## About This Demo

This project demonstrates how an AI-powered support chatbot can be deployed for a direct-to-consumer ergonomics brand. The **ErgoPro Support Assistant** handles two core use cases:

- **Product Recommendations** — Helps customers find the right ergonomic chair based on their work habits, body type, and budget
- **Customer Support** — Answers questions about orders, returns, warranties, setup guides, and posture tips

The assistant is powered by a Databricks Agent Bricks endpoint and surfaces a clean, minimal chat UI. Intermediate agent reasoning is hidden from the user — only the final response is shown, giving the experience a polished, consumer-friendly feel.

---

## Tech Stack

| Layer | Technology |
|---|---|
| Frontend | React, Vite, Tailwind CSS, Vercel AI SDK |
| Backend | ExpressJS, Databricks Auth |
| AI | Databricks Agent Serving / Agent Bricks |
| Database (optional) | Databricks Lakebase (Postgres) |
| Deployment | Databricks Apps (DAB) |

---

## Features

- **Simplified Output (v2)** — Intermediate tool calls hidden; users see a "Working…" indicator while the agent reasons, then only the final answer
- **Product Recommendation Flow** — Conversational chair finder based on customer needs
- **Customer Support** — Orders, returns, warranty, ergonomics tips
- **Persistent Chat History** — Conversations stored in Lakebase (optional)
- **Ephemeral Mode** — Runs without a database for quick demos
- **Databricks Auth** — Secure user identification

---

## Running Locally

### Quick Start

```bash
# 1. Install dependencies
npm install

# 2. Copy and configure environment
cp .env.example .env
# Fill in your Databricks CLI profile and serving endpoint name

# 3. Start the app
npm run dev
```

The app will be available at [localhost:3000](http://localhost:3000) (frontend) and [localhost:3001](http://localhost:3001) (backend).

### Environment Variables

```bash
# Required
DATABRICKS_CONFIG_PROFILE=your_profile_name
SERVING_ENDPOINT_NAME=your_agent_endpoint_name

# Optional — enables persistent chat history
POSTGRES_URL=...
# OR
PGUSER=...
PGPASSWORD=...
PGDATABASE=...
PGHOST=...
```

---

## Deploying to Databricks

```bash
# Validate bundle config
databricks bundle validate

# Deploy
databricks bundle deploy

# Start the app
databricks bundle run databricks_chatbot
```

---

## Project Structure

```
ergopro-chatbot-demo/
├── client/              # React frontend (Vite)
│   ├── src/
│   │   ├── components/  # UI components (chat, sidebar, greeting, etc.)
│   │   ├── pages/       # NewChatPage, ChatPage
│   │   └── contexts/    # Session, AppConfig
│   └── public/          # Static assets (ErgoPro logo, favicon)
├── server/              # ExpressJS backend
├── packages/            # Shared packages (auth, core)
└── scripts/             # DB migration & setup scripts
```

---

## Suggested Chat Prompts

Try these to see the assistant in action:

- *"Which ErgoPro chair is right for me?"*
- *"What is your return and warranty policy?"*
- *"How do I adjust my chair for better posture?"*
- *"Track my order or check shipping status"*

---

*This is a fictional demo company. ErgoPro does not exist as a real business.*

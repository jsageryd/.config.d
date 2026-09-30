import { tool } from "@opencode-ai/plugin"

// Local Ollama serves the System One API (same request/response shape as Jev
// on OpenCode Zen) for models with the "decision" capability.
const ENDPOINT = "http://localhost:11434/v1/systemone"
const MODEL = "nimble"

const s = tool.schema

const question = s.discriminatedUnion("type", [
  s.object({
    type: s.literal("noul"),
    instructions: s.string().describe("Yes/no question to answer about the state"),
  }),
  s.object({
    type: s.literal("choice"),
    instructions: s.string().describe("What to choose between"),
    criteria: s
      .record(s.string(), s.string())
      .describe("Option ID mapped to a description of when it applies"),
  }),
  s.object({
    type: s.literal("score"),
    instructions: s.string().describe("What to score"),
    criteria: s
      .array(s.string())
      .min(2)
      .describe("Rubric levels, ordered from lowest to highest"),
  }),
])

export default tool({
  description:
    "Ask a local System One decision model (Ollama `nimble`) fast structured questions about a piece of text. " +
    "Returns probabilities per question instead of prose. Question types: " +
    "`noul` (yes/no, returns probability of yes), `choice` (pick one of named options), " +
    "`score` (pick a level on a rubric). " +
    "Use for classification, triage and routing decisions, not for generating text.",

  args: {
    state: s.string().describe("The text to evaluate"),
    questions: s
      .record(s.string(), question)
      .describe("Question ID mapped to a question; all are evaluated in one request"),
  },

  async execute(args, context) {
    const res = await fetch(ENDPOINT, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        model: MODEL,
        state: args.state,
        questions: args.questions,
      }),
      signal: context.abort,
    })

    const body = await res.text()
    if (!res.ok) {
      throw new Error(`System One request failed: ${res.status} ${res.statusText}\n${body}`)
    }

    try {
      return JSON.stringify(JSON.parse(body), null, 2)
    } catch {
      return body
    }
  },
})

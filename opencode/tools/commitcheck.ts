import { tool } from "@opencode-ai/plugin"
import { execFile } from "node:child_process"

function runCommitcheck(
  operation: "fmt" | "check",
  message: string,
): Promise<string> {
  return new Promise((resolve, reject) => {
    const child = execFile(
      "commitcheck",
      [operation, "-"],
      (error, stdout, stderr) => {
        if (error) {
          // `check` uses its output even when validation fails.
          if (operation === "check" && stdout) {
            resolve(stdout)
            return
          }

          reject(new Error(stderr || error.message))
          return
        }

        resolve(stdout)
      },
    )

    child.stdin?.write(message)
    child.stdin?.end()
  })
}

export const fmt = tool({
  description:
    "Format a commit message: reflow body at 72 columns, normalize trailers, and strip trailing whitespace.",

  args: {
    message: tool.schema
      .string()
      .describe("Draft commit message to format"),
  },

  async execute(args) {
    return runCommitcheck("fmt", args.message)
  },
})

export const check = tool({
  description:
    "Validate a commit message against formatting rules and report violations.",

  args: {
    message: tool.schema
      .string()
      .describe("Commit message to validate"),
  },

  async execute(args) {
    return runCommitcheck("check", args.message)
  },
})

import { execFile } from "node:child_process"
import { Plugin } from "@opencode/plugin"

const BELL_EVENTS = new Set([
  "permission.asked",
  "form.created",
  "session.execution.succeeded",
  "session.execution.failed",
])

const ringTmuxBell = () => {
  const pane = process.env.TMUX_PANE
  if (!process.env.TMUX || !pane) return
  execFile("tmux", ["display-message", "-p", "-t", pane, "#{pane_tty}"], (error, stdout) => {
    if (error) return
    execFile("sh", ["-c", `printf '\\a' > "$1"`, "sh", stdout.trim()], () => {})
  })
}

export default Plugin.define({
  id: "notification",
  setup(ctx) {
    const controller = new AbortController()
    void (async () => {
      for await (const event of ctx.event.subscribe({ signal: controller.signal })) {
        if (BELL_EVENTS.has(event.type)) ringTmuxBell()
      }
    })().catch(() => {})
    return () => controller.abort()
  },
})

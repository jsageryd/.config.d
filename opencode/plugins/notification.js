export const NotificationPlugin = async ({ project, client, $, directory, worktree }) => {
  return {
    event: async ({ event }) => {
      if ([
        'permission.asked',
        'session.error',
        'session.idle',
      ].includes(event.type)) {
        await $`[ -z "$TMUX" ] || printf '\a' > "$(tmux display-message -p -t "$TMUX_PANE" '#{pane_tty}')"`
      }
    },
  }
}

return {
  cmd = { 'sqls' },
  filetypes = { 'sql' },
  root_markers = { '.git' },
  settings = {
    sqls = {
      connections = {
        {
          driver = 'postgresql',
          dataSourceName = 'host=localhost port=5432 user=postgres dbname=postgres sslmode=disable',
        },
      },
    },
  },
}

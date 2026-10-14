return {
  "emrearmagan/atlas.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons", -- optional but recommended
    "esmuellert/codediff.nvim",
  },
  -- See Configuration below
  opts = {
    providers = {
      gitlab = {
        base_url = "https://gitlab.internal.modeproduit.fr",
        token = vim.env.GITLAB_PERSONAL_ACCESS_TOKEN,
        cache_ttl = 300,
      },
    },
    issues = {
      gitlab = {
        views = {
          {
            name = "Assigned",
            key = "1",
            scope = "assigned_to_me",
            state = "opened",
            current_repo = true,
          },
          {
            name = "Ready",
            key = "2",
            scope = "all",
            state = "opened",
            labels = "READY",
            current_repo = true,
          },
          {
            name = "Doing",
            key = "3",
            scope = "all",
            state = "opened",
            labels = "DOING",
            current_repo = true,
          },
          {
            name = "Review",
            key = "4",
            scope = "all",
            state = "opened",
            labels = "REVIEW",
            current_repo = true,
          },
        },

        bookmarks = {
          key = "S",
          label = "Search",
          items = {
            ["Support"] = { scope = "all", state = "opened", labels = "SUPPORT" },
          },
        },
      },
    },
    pulls = {
      gitlab = {
        views = {
          {
            name = "Assigned to me",
            key = "1",
            scope = "assigned_to_me",
            state = "opened",
            current_repo = true,
          },
          {
            name = "Opened MRs",
            key = "2",
            scope = "all",
            state = "opened",
            current_repo = true,
            order_by = "updated_at",
            sort = "desc",
          },
          {
            name = "Renovate MRs",
            key = "3",
            scope = "all",
            state = "opened",
            current_repo = true,
            labels = "RENOVATE",
            order_by = "updated_at",
            sort = "desc",
          },
        },
        bookmarks = {
          key = "S",
          label = "Search",
          items = {
            ["Changes requested on mine"] = {
              scope = "created_by_me",
              state = "opened",
              review_states = { "REQUESTED_CHANGES" },
              current_repo = true,
            },
          },
        },
      },
    },
  },
}

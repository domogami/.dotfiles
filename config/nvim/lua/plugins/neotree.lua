return {
    "neo-tree.nvim",
    opts = {
        filesystem = {
            filtered_items = {
                visible = true,
                hide_gitignored = false,
                hide_dotfiles = false,
                hide_by_name = {
                    ".DS_Store",
                },
                never_show = { ".DS_Store" },
            },
        },
        default_component_configs = {
            git_status = {
                symbols = {
                    untracked = "",
                },
            },
        },
    },
}

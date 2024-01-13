local M = { "nvim-telescope/telescope.nvim" }

M.dependencies = {
	"nvim-lua/plenary.nvim",
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
	},
}

M.event = "VimEnter"

function M.config()
	local telescope = require("telescope")
	local builtin = require("telescope.builtin")
	local actions = require("telescope.actions")

	telescope.setup({
		defaults = {
			mappings = {
				i = {
					["<esc>"] = actions.close,
				},
			},
		},
		extensions = {
			fzf = {
				fuzzy = true,
				override_generic_sorter = true,
				override_file_sorter = true,
				case_mode = "smart_case",
			},
		},
	})
	telescope.load_extension("fzf")

	vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
	vim.keymap.set("n", "<leader>fs", builtin.grep_string, {})
	vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
	vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
	vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
end

return M

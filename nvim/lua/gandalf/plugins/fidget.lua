local M = { "j-hui/fidget.nvim" }

M.lazy = false

M.cond = false

function M.config()
	require("fidget").setup({
		notification = {
			override_vim_notify = true,
			window = {
				y_padding = 1,
			},
		},
	})
end

return M

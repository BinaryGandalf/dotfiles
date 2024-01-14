local M = { "stevearc/conform.nvim" }

M.event = "BufEnter"

M.manual = false
M.timeout = 2500

function M.invoke()
	require("conform").format({
		lsp_fallback = false,
		async = false,
		timeout_ms = M.timeout,
	})
end

function M.config()
	require("conform").setup({
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "isort", "black" },
			sh = { "shfmt" },
			c = { "clang_format" },
			cpp = { "clang_format" },
		},
	})

	vim.api.nvim_create_autocmd("BufWritePre", {
		group = require("gandalf.settings").gandalf_augroup,
		callback = function()
			if not M.manual then
				print("x")
				M.invoke()
			end
		end,
	})
end

return M

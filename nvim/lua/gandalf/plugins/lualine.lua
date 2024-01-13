local M = { "nvim-lualine/lualine.nvim" }

M.dependencies = {
	"nvim-tree/nvim-web-devicons",
}

M.lazy = false

function M.config()
	require("lualine").setup({
		options = {
			globalstatus = true,
			component_separators = {
				left = "",
				right = "",
			},
			section_separators = {
				left = "",
				right = "",
			},
		},
		sections = {
			lualine_a = {
				"mode",
			},
			lualine_b = {
				{
					"branch",
					icon = "",
				},
				"diff",
				"diagnostics",
			},
			lualine_c = {
				{
					"filename",
					file_status = true,
					path = 1,
				},
			},
			lualine_x = {
				"filesize",
				"encoding",
				"fileformat",
			},
			lualine_y = {
				"hostname",
				"location",
			},
			lualine_z = {
				{
					"filetype",
					colored = false,
					icon_only = false,
					icon = {
						align = "left",
					},
				},
			},
		},
		extensions = {
			"nvim-dap-ui",
		},
	})
end

return M

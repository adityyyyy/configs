return {
	"mfussenegger/nvim-dap",
	event = "VeryLazy",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
		"rcarriga/cmp-dap",
		-- Installs the debug adapters for you
		"williamboman/mason.nvim",
		"jay-babu/mason-nvim-dap.nvim",
		-- Add your own debuggers here
		"leoluz/nvim-dap-go",
		"mfussenegger/nvim-dap-python",
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		dapui.setup()

		local keymap = vim.keymap

		require("mason-nvim-dap").setup({
			handlers = {},
		})

		keymap.set("n", "<leader>dc", dap.continue, { desc = "Debug: Start/Continue" })
		keymap.set("n", "<leader>dsi", dap.step_into, { desc = "Debug: Step Into" })
		keymap.set("n", "<leader>dso", dap.step_over, { desc = "Debug: Step Over" })
		keymap.set("n", "<leader>dsO", dap.step_out, { desc = "Debug: Step Out" })
		keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
		keymap.set("n", "<leader>dl", dapui.toggle, { desc = "Debug: See last session result." })

		keymap.set("n", "<leader>bp", function()
			dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
		end, { desc = "Debug: Set Breakpoint" })

		keymap.set("n", "<leader>dr", "<cmd>lua require'dap'.repl.toggle()<cr>")

		dap.listeners.after.event_initialized["dapui_config"] = dapui.open
		dap.listeners.before.event_terminated["dapui_config"] = dapui.close
		dap.listeners.before.event_exited["dapui_config"] = dapui.close

		local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
		require("dap-python").setup(path)

		require("dap-go").setup()
	end,
}

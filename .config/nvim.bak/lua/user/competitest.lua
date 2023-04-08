local status_ok, competitest = pcall(require, "competitest")
if not status_ok then
	return
end

competitest.setup({
	runner_ui = {
		interface = "popup",
	},
	compile_command = {
		-- cpp = { exec = "g++", args = { "-Wall", "$(FNAME)", "-o", "$(FNOEXT)" } },
	},
	run_command = {
		cpp = { exec = "./build/$(FNOEXT)" },
	},
	testcases_input_file_format = "$(FNOEXT)_sample$(TCNUM).in",
	testcases_output_file_format = "$(FNOEXT)_sample$(TCNUM).out",
})

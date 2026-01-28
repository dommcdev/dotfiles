-- Code Runner - run files in a floating terminal
-- Available placeholders:
--   ${file}     - full file path
--   ${dir}      - directory of the file
--   ${name}     - filename without extension
--   ${ext}      - file extension

local M = {}

M.commands = {
  cpp = "mkdir -p ${dir}/bin && g++ ${file} -o ${dir}/bin/${name} && ${dir}/bin/${name}",
  c = "mkdir -p ${dir}/bin && gcc ${file} -o ${dir}/bin/${name} && ${dir}/bin/${name}",
  py = "python3 ${file}",
  js = "node ${file}",
  ts = "npx tsx ${file}",
  go = "go run ${file}",
  rs = "cargo run",
  lua = "lua ${file}",
  sh = "bash ${file}",
  rb = "ruby ${file}",
  java = "java ${file}",
  zig = "zig run ${file}",
}

function M.run()
  local file = vim.fn.expand("%:p")
  local dir = vim.fn.expand("%:p:h")
  local name = vim.fn.expand("%:t:r")
  local ext = vim.fn.expand("%:e")

  -- Save the file before running
  vim.cmd("silent! write")

  local cmd_template = M.commands[ext]

  -- Check for Makefile
  if vim.fn.filereadable(dir .. "/Makefile") == 1 then
    cmd_template = "cd ${dir} && make build && make run"
  end

  -- Handle shebang for scripts (if no Makefile found)
  if not cmd_template or cmd_template == M.commands[ext] then
    local f = io.open(file, "r")
    if f then
      local first_line = f:read("*l")
      f:close()
      if first_line and first_line:match("^#!") then
        local interpreter = first_line:match("^#!(.*)")
        cmd_template = vim.trim(interpreter) .. " ${file}"
      end
    end
  end

  if not cmd_template then
    vim.notify("No run command configured for ." .. ext .. " files", vim.log.levels.WARN)
    return
  end

  local cmd = cmd_template:gsub("${file}", file):gsub("${dir}", dir):gsub("${name}", name):gsub("${ext}", ext)

  -- Append wait command so the terminal doesn't close immediately
  -- Try zsh read (-k) first, then bash read (-n)
  cmd = cmd .. '; echo ""; echo "Press any key to exit..."; read -k 1 -s 2>/dev/null || read -n 1 -s'

  Snacks.terminal.open(cmd, {
    win = {
      position = "float",
      height = 0.9,
      width = 0.9,
      border = "rounded",
    },
  })
end

vim.keymap.set("n", "<leader>r", M.run, { desc = "Run File" })

vim.api.nvim_create_user_command("Run", M.run, { desc = "Run current file" })

return M

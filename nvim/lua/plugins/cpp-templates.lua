return {
  {
    "nvim-telescope/telescope.nvim",
    optional = true,
  },
  {
    name = "cpp-templates",
    dir = vim.fn.stdpath("config"),
    lazy = false,
    priority = 100,
    config = function()
      -- Template definitions
      local templates = {
        {
          name = "Competitive Programming",
          description = "Full competitive programming template with fast I/O",
          content = [[#include <bits/stdc++.h>
using namespace std;

typedef long long ll;
typedef long double ld;
#define endl '\n'

void solve() {

}

int main() {
  // Fast IO
  ios::sync_with_stdio(0);
  cin.tie(NULL);
  cout.tie(NULL);

  ll T;
  cin >> T;
  while (T--) {
    solve();
  }

  return 0;
}]],
        },
        {
          name = "Simple Main",
          description = "Basic C++ template with main function",
          content = [[#include <bits/stdc++.h>
using namespace std;

int main() {

  return 0;
}]],
        },
        {
          name = "Basic Template",
          description = "Minimal C++ template with common headers",
          content = [[#include <iostream>
#include <vector>
#include <string>
using namespace std;

int main() {

  return 0;
}]],
        },
        {
          name = "Algorithm Practice",
          description = "Template for algorithm practice with common includes",
          content = [[#include <iostream>
#include <vector>
#include <algorithm>
#include <string>
#include <map>
#include <set>
#include <queue>
#include <stack>
using namespace std;

int main() {

  return 0;
}]],
        },
        {
          name = "Class Template",
          description = "Template with a basic class structure",
          content = [[#include <iostream>
using namespace std;

class Solution {
public:

};

int main() {
  Solution sol;

  return 0;
}]],
        },
      }

      -- Function to apply template to current buffer
      local function apply_template(template)
        local buf = vim.api.nvim_get_current_buf()
        local lines = vim.split(template.content, "\n")
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

        -- Find the first empty line or cursor position
        for i, line in ipairs(lines) do
          if line:match("^%s*$") and i > 1 then
            vim.api.nvim_win_set_cursor(0, { i, vim.fn.indent(i) })
            break
          end
        end

        vim.notify("Applied template: " .. template.name)
      end

      -- Function to select template using vim.ui.select (fallback if telescope not available)
      local function select_template_fallback()
        local items = {}
        for _, template in ipairs(templates) do
          table.insert(items, template.name .. " - " .. template.description)
        end

        vim.ui.select(items, {
          prompt = "Select C++ Template:",
        }, function(choice, idx)
          if choice and idx then
            apply_template(templates[idx])
          end
        end)
      end

      -- Function to select template using telescope (if available)
      local function select_template()
        local ok, telescope = pcall(require, "telescope")
        if not ok then
          select_template_fallback()
          return
        end

        local pickers = require("telescope.pickers")
        local finders = require("telescope.finders")
        local conf = require("telescope.config").values
        local actions = require("telescope.actions")
        local action_state = require("telescope.actions.state")

        pickers
          .new({}, {
            prompt_title = "C++ Templates",
            finder = finders.new_table({
              results = templates,
              entry_maker = function(entry)
                return {
                  value = entry,
                  display = entry.name .. " - " .. entry.description,
                  ordinal = entry.name,
                }
              end,
            }),
            sorter = conf.generic_sorter({}),
            attach_mappings = function(prompt_bufnr, map)
              actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                apply_template(selection.value)
              end)
              return true
            end,
          })
          :find()
      end

      -- Make functions available globally
      _G.cpp_templates = {
        apply_template = apply_template,
        select_template = select_template,
        templates = templates,
      }

      -- Auto-apply template for new .cpp files
      vim.api.nvim_create_autocmd("BufNewFile", {
        pattern = "*.cpp",
        callback = function()
          -- Check if file is empty
          local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
          if #lines == 1 and lines[1] == "" then
            -- Ask user if they want to use a template
            vim.defer_fn(function()
              local choice = vim.fn.confirm("Use C++ template?", "&Yes\n&No\n&Select", 1)
              if choice == 1 then
                -- Apply competitive programming template by default
                apply_template(templates[1])
              elseif choice == 3 then
                select_template()
              end
            end, 100)
          end
        end,
      })

      -- Create user commands
      vim.api.nvim_create_user_command("CppTemplate", function()
        select_template()
      end, { desc = "Select C++ template" })

      vim.api.nvim_create_user_command("CppCompetitive", function()
        apply_template(templates[1])
      end, { desc = "Apply competitive programming template" })

      vim.api.nvim_create_user_command("CppSimple", function()
        apply_template(templates[2])
      end, { desc = "Apply simple main template" })

      -- Create keymaps
      vim.keymap.set("n", "<leader>ct", function()
        select_template()
      end, { desc = "C++ Templates" })

      vim.keymap.set("n", "<leader>ccp", function()
        apply_template(templates[1])
      end, { desc = "C++ Competitive Programming Template" })

      vim.keymap.set("n", "<leader>csm", function()
        apply_template(templates[2])
      end, { desc = "C++ Simple Main Template" })

      vim.notify("C++ Templates loaded successfully!", vim.log.levels.INFO)
    end,
  },
}


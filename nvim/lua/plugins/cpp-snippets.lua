return {
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local ls = require("luasnip")
      local s = ls.snippet
      local t = ls.text_node
      local i = ls.insert_node

      -- C++ snippets
      ls.add_snippets("cpp", {
        -- Competitive programming template
        s("cptemp", {
          t({
            "#include <bits/stdc++.h>",
            "using namespace std;",
            "",
            "typedef long long ll;",
            "typedef long double ld;",
            "#define endl '\\n'",
            "",
            "void solve() {",
            "  "
          }),
          i(1),
          t({
            "",
            "}",
            "",
            "int main() {",
            "  // Fast IO",
            "  ios::sync_with_stdio(0);",
            "  cin.tie(NULL);",
            "  cout.tie(NULL);",
            "  ",
            "  ll T;",
            "  cin >> T;",
            "  while (T--) {",
            "    solve();",
            "  }",
            "  ",
            "  return 0;",
            "}"
          })
        }),

        -- Simple main template
        s("mainsimple", {
          t({
            "#include <bits/stdc++.h>",
            "using namespace std;",
            "",
            "int main() {",
            "  "
          }),
          i(1),
          t({
            "",
            "  return 0;",
            "}"
          })
        }),

        -- Basic template
        s("cppbasic", {
          t({
            "#include <iostream>",
            "#include <vector>",
            "#include <string>",
            "using namespace std;",
            "",
            "int main() {",
            "  "
          }),
          i(1),
          t({
            "",
            "  return 0;",
            "}"
          })
        }),

        -- Algorithm practice template
        s("algotemplate", {
          t({
            "#include <iostream>",
            "#include <vector>",
            "#include <algorithm>",
            "#include <string>",
            "#include <map>",
            "#include <set>",
            "#include <queue>",
            "#include <stack>",
            "using namespace std;",
            "",
            "int main() {",
            "  "
          }),
          i(1),
          t({
            "",
            "  return 0;",
            "}"
          })
        }),

        -- Class template
        s("classtemplate", {
          t({
            "#include <iostream>",
            "using namespace std;",
            "",
            "class Solution {",
            "public:",
            "  "
          }),
          i(1),
          t({
            "",
            "};",
            "",
            "int main() {",
            "  Solution sol;",
            "  "
          }),
          i(2),
          t({
            "",
            "  return 0;",
            "}"
          })
        }),
      })
    end,
  },
}
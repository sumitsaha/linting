# Written by Sumit Saha, Learn with Sumit
#!/bin/bash

# ----------------------
# Color Variables
# ----------------------
RED="\033[0;31m"
YELLOW='\033[1;33m'
GREEN='\033[1;32m'
LCYAN='\033[1;36m'
NC='\033[0m' # No Color

# ----------------------
# Other Variables
# ----------------------
base_cmd='npx install-peerdeps --dev eslint-config-airbnb'

# --------------------------------------
# Prompts for configuration preferences
# --------------------------------------

# Package Manager Prompt
echo
echo "Which package manager are you using? Enter 1 for yarn and 2 for npm"
select package_command_choices in "Yarn" "npm" "Cancel"; do
  case $package_command_choices in
    Yarn ) pkg_cmd='yarn add'; break;;
    npm ) pkg_cmd='npm install'; break;;
    Cancel ) exit;;
  esac
done
echo

# File Format
config_opening='{';

# Checks for existing eslintrc files
if [ -f ".eslintrc.js" -o -f ".eslintrc.yaml" -o -f ".eslintrc.yml" -o -f ".eslintrc.json" -o -f ".eslintrc" ]; then
  echo -e "${RED}Existing ESLint config file(s) found:${NC}"
  ls -a .eslint* | xargs -n 1 basename
  echo
  echo -e "${RED}CAUTION:${NC} there is loading priority when more than one config file is present: https://eslint.org/docs/user-guide/configuring#configuration-file-formats"
  echo
  read -p  "Write .eslintrc${config_extension} (Y/n) Enter y for yes and n for no"
  if [[ $REPLY =~ ^[Nn]$ ]]; then
    echo -e "${YELLOW}>>>>> Skipping ESLint config${NC}"
    skip_eslint_setup="true"
  fi
fi

# Max Line Length
max_len_val="100"

# Trailing Commas Prompt
trailing_comma_pref="es5"

# ----------------------
# Perform Configuration
# ----------------------
echo
echo -e "${GREEN}Configuring your development environment... ${NC}"

echo
echo -e "1/4 ${LCYAN}ESLint & Prettier Installation... ${NC}"
echo
$pkg_cmd -D prettier # as create-react-app already comes with eslint, we don't need to install eslint

echo
echo -e "2/4 ${LCYAN}Conforming to Airbnb's JavaScript Style Guide... ${NC}"
echo
$base_cmd

echo
echo -e "3/4 ${YELLOW}Installing Babel ESLint... ${NC}"
echo
$pkg_cmd -D babel-eslint

echo
echo -e "4/4 ${LCYAN}Making ESlint and Prettier play nice with each other... ${NC}"
echo "See https://github.com/prettier/eslint-config-prettier for more details."
echo
$pkg_cmd -D eslint-config-prettier eslint-plugin-prettier


if [ "$skip_eslint_setup" == "true" ]; then
  break
else
  echo
  echo -e "4/4 ${YELLOW}Building your .eslintrc${config_extension} file...${NC}"
  > ".eslintrc${config_extension}" # truncates existing file (or creates empty)

  echo ${config_opening}'
  "extends": [
    "airbnb",
    "airbnb/hooks",
    "eslint:recommended",
    "prettier",
    "plugin:jsx-a11y/recommended"
  ],
  "parser": "babel-eslint",
  "parserOptions": {
    "ecmaVersion": 8
  },
  "env": {
    "browser": true,
    "node": true,
    "es6": true,
    "jest": true
  },
  "rules": {
    "react/jsx-props-no-spreading": [
      false,
      {
        "exceptions": ["Component"]
      }
    ],
    "react/react-in-jsx-scope": 0,
    "react-hooks/rules-of-hooks": "error",
    "no-console": 0,
    "indent": 0,
    "linebreak-style": 0,
    "react/state-in-constructor": 0,
    "react/prop-types": 0,
    "jsx-a11y/click-events-have-key-events": 0,
    "react/jsx-filename-extension": [
      1,
      {
        "extensions": [
          ".js",
          ".jsx"
        ]
      }
    ],
    "prettier/prettier": [
      "error",
      {
        "trailingComma": "'${trailing_comma_pref}'",
        "singleQuote": true,
        "printWidth": '${max_len_val}',
        "tabWidth": 4,
        "semi": true,
        "endOfLine": "auto"
      }
    ]
  },
  "plugins": [
    "prettier",
    "react",
    "react-hooks"
  ]
}' >> .eslintrc${config_extension}
fi

echo
echo -e "${GREEN}Finished setting up!${NC}"
echo
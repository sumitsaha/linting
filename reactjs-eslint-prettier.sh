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
echo "Which package manager are you using?"
select package_command_choices in "Yarn" "npm" "Cancel"; do
  case $package_command_choices in
    Yarn ) pkg_cmd='yarn add'; break;;
    npm ) pkg_cmd='npm install'; break;;
    Cancel ) exit;;
  esac
done
echo

# File Format Prompt
echo "Which ESLint and Prettier configuration format do you prefer?"
select config_extension in ".js" ".json" "Cancel"; do
  case $config_extension in
    .js ) config_opening='module.exports = {'; break;;
    .json ) config_opening='{'; break;;
    Cancel ) exit;;
  esac
done
echo

# Checks for existing eslintrc files
if [ -f ".eslintrc.js" -o -f ".eslintrc.yaml" -o -f ".eslintrc.yml" -o -f ".eslintrc.json" -o -f ".eslintrc" ]; then
  echo -e "${RED}Existing ESLint config file(s) found:${NC}"
  ls -a .eslint* | xargs -n 1 basename
  echo
  echo -e "${RED}CAUTION:${NC} there is loading priority when more than one config file is present: https://eslint.org/docs/user-guide/configuring#configuration-file-formats"
  echo
  read -p  "Write .eslintrc${config_extension} (Y/n)? "
  if [[ $REPLY =~ ^[Nn]$ ]]; then
    echo -e "${YELLOW}>>>>> Skipping ESLint config${NC}"
    skip_eslint_setup="true"
  fi
fi
finished=false

# Max Line Length Prompt
while ! $finished; do
  read -p "What max line length do you want to set for ESLint and Prettier? (Recommendation: 100)"
  if [[ $REPLY =~ ^[0-9]{2,3}$ ]]; then
    max_len_val=$REPLY
    finished=true
    echo
  else
    echo -e "${YELLOW}Please choose a max length of two or three digits, e.g. 80 or 100 or 120${NC}"
  fi
done

# Trailing Commas Prompt
echo "What style of trailing commas do you want to enforce with Prettier?"
echo -e "${YELLOW}>>>>> See https://prettier.io/docs/en/options.html#trailing-commas for more details.${NC}"
select trailing_comma_pref in "none" "es5" "all"; do
  case $trailing_comma_pref in
    "none" ) break;;
    "es5" ) break;;
    "all" ) break;;
  esac
done
echo

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
    "react-app",
    "airbnb",
    "airbnb/hooks",
    "eslint:recommended",
    "prettier",
    "prettier/react",
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
    "react-hooks/rules-of-hooks": "error",
    "no-console": 0,
    "react/state-in-constructor": 0,
    "indent": 0,
    "linebreak-style": 0,
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
        "semi": true
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

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
base_cmd='npx install-peerdeps --dev eslint-config-airbnb-base'
max_len_val='100'
trailing_comma_pref='es5'
config_opening='{'
config_extension='.json'

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

# ----------------------
# Perform Configuration
# ----------------------
echo
echo -e "${GREEN}Configuring your development environment... ${NC}"

echo
echo -e "1/3 ${LCYAN}ESLint & Prettier Installation... ${NC}"
echo
$pkg_cmd -D eslint prettier

echo
echo -e "2/3 ${LCYAN}Conforming to Airbnb's JavaScript Style Guide... ${NC}"
echo
$base_cmd

echo
echo -e "3/3 ${LCYAN}Making ESlint and Prettier play nice with each other... ${NC}"
echo "See https://github.com/prettier/eslint-config-prettier for more details."
echo
$pkg_cmd -D eslint-config-prettier eslint-plugin-prettier


if [ "$skip_eslint_setup" == "true" ]; then
  break
else
  echo
  echo -e "3/3 ${YELLOW}Building your .eslintrc${config_extension} file...${NC}"
  > ".eslintrc${config_extension}" # truncates existing file (or creates empty)

  echo ${config_opening}'
  "extends": [
    "airbnb-base",
    "prettier"
  ],
  "parserOptions": {
    "ecmaVersion": 12
  },
  "env": {
    "commonjs": true,
    "node": true
  },
  "rules": {
    "no-console": 0,
    "indent": 0,
    "linebreak-style": 0,
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
    "prettier"
  ]
}' >> .eslintrc${config_extension}
fi

echo
echo -e "${GREEN}Finished setting up!${NC}"
echo